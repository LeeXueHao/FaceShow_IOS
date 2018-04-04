//
//  IMImageMessageSender.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageMessageSender.h"
#import "IMDatabaseManager.h"
#import "IMManager.h"
#import "IMConfig.h"
#import "IMRequestManager.h"
#import "IMConnectionManager.h"
#import "QiniuDataManager.h"

NSString * const kIMImageUploadDidUpdateNotification = @"kIMImageUploadDidUpdateNotification";
NSString * const kIMImageUploadTopicKey = @"kIMImageUploadTopicKey";
NSString * const kIMImageUploadMessageKey = @"kIMImageUploadMessageKey";
NSString * const kIMImageUploadProgressKey = @"kIMImageUploadProgressKey";

@interface IMImageMessageSender()
@property (nonatomic, strong) NSMutableArray<IMImageMessage *> *msgArray;
@property (nonatomic, assign) BOOL isMsgSending;
@property (nonatomic, strong) NSString *imageFolderPath;
@property (nonatomic, strong) NSMutableArray *successMsgUniqueIDArray;
@end

@implementation IMImageMessageSender
+ (IMImageMessageSender *)sharedInstance {
    static IMImageMessageSender *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMImageMessageSender alloc] init];
        manager.msgArray = [NSMutableArray array];
        manager.successMsgUniqueIDArray = [NSMutableArray array];
        manager.isMsgSending = NO;
        [manager createImageCacheFolderIfNotExist];
        [manager setupObserver];
    });
    return manager;
}

- (void)createImageCacheFolderIfNotExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"im_image_cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.imageFolderPath = path;
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        for (NSString *uniqueID in self.successMsgUniqueIDArray) {
            NSString *path = [self.imageFolderPath stringByAppendingPathComponent:uniqueID];
            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        }
    }];
}

- (UIImage *)cacheImageWithMessageUniqueID:(NSString *)uniqueID {
    NSString *path = [self.imageFolderPath stringByAppendingPathComponent:uniqueID];
    NSData *imageData = [[NSData alloc]initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc]initWithData:imageData];
    return image;
}

- (void)addImageMessage:(IMImageMessage *)msg {
    IMTopicMessage *message = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:msg.uniqueID];
    if (!message) {
        NSString *reqId = [IMConfig generateUniqueID];
        msg.uniqueID = reqId;
        msg.width = msg.image.size.width * msg.image.scale;
        msg.height = msg.image.size.height * msg.image.scale;
        message = [self imageTopicMsgFromMessage:msg];
    }else {
        msg.width = message.width;
        msg.height = message.height;
    }
    message.sendState = MessageSendState_Sending;
    message.sendTime = [[NSDate date]timeIntervalSince1970]*1000 + [IMRequestManager sharedInstance].timeoffset;
    [[IMDatabaseManager sharedInstance]saveMessage:message];
    
    [self.msgArray addObject:msg];
    [self checkAndSend];
}

- (IMTopicMessage *)imageTopicMsgFromMessage:(IMImageMessage *)msg {
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = MessageType_Image;
    message.topicID = msg.topicID;
    message.channel = [IMConfig generateUniqueID];
    message.uniqueID = msg.uniqueID;
    message.width = msg.width;
    message.height = msg.height;
    message.sender = [[IMManager sharedInstance]currentMember];
    NSData *data = UIImageJPEGRepresentation(msg.image, 1);
    NSString *path = [self.imageFolderPath stringByAppendingPathComponent:msg.uniqueID];
    [data writeToFile:path atomically:YES];
    return message;
}

- (void)checkAndSend{
    if (self.isMsgSending || self.msgArray.count == 0) {
        return;
    }
    self.isMsgSending = YES;
    IMImageMessage *msg = [self.msgArray firstObject];
    if ([[IMDatabaseManager sharedInstance]isTempTopicID:msg.topicID]) {
        WEAK_SELF
        [[IMRequestManager sharedInstance]requestNewTopicWithMember:msg.otherMember fromGroup:msg.groupID completeBlock:^(IMTopic *topic, NSError *error) {
            STRONG_SELF
            if (error) {
                [self messageSentFailed:msg];
                [self sendNext];
                return;
            }
            // 订阅新的topic
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
            [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
            
            msg.topicID = topic.topicID;
            [self sendMessage:msg];
        }];
    }else {
        [self sendMessage:msg];
    }
}

- (void)sendMessage:(IMImageMessage *)imageMsg {
    NSData *data = UIImageJPEGRepresentation(imageMsg.image, 1);
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:^(CGFloat percent) {
        STRONG_SELF
        NSDictionary *info = @{kIMImageUploadTopicKey:@(imageMsg.topicID),
                               kIMImageUploadMessageKey:imageMsg.uniqueID,
                               kIMImageUploadProgressKey:@(percent)
                               };
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMImageUploadDidUpdateNotification object:nil userInfo:info];
    } completeBlock:^(NSString *key, NSError *error) {
        STRONG_SELF
        if (error) {
            [self messageSentFailed:imageMsg];
            [self sendNext];
        }else {
            imageMsg.resourceID = key;
            [self saveMessage:imageMsg];
        }
    }];
}

- (void)saveMessage:(IMImageMessage *)imageMsg {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestSaveImageMsgWithMsg:imageMsg completeBlock:^(IMTopicMessage *msg, NSError *error) {
        STRONG_SELF
        if (error) {
            [self messageSentFailed:imageMsg];
        }else {
            [[IMDatabaseManager sharedInstance]saveMessage:msg];
            [self.successMsgUniqueIDArray addObject:imageMsg.uniqueID];
        }
        [self sendNext];
    }];
}

- (void)messageSentFailed:(IMImageMessage *)msg {
    IMTopicMessage *message = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:msg.uniqueID];
    message.sendState = MessageSendState_Failed;
    [[IMDatabaseManager sharedInstance]saveMessage:message];
}

- (void)sendNext {
    [self.msgArray removeObjectAtIndex:0];
    self.isMsgSending = NO;
    [self checkAndSend];
}

@end
