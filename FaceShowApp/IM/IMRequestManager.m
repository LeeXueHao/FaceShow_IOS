//
//  IMRequestManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMRequestManager.h"
#import "IMManager.h"
#import "GetMemberTopicsRequest.h"
#import "GetTopicsRequest.h"
#import "IMTopicMessage.h"
#import "GetTopicMsgsRequest.h"
#import "IMConfig.h"
#import "CreateTopicRequest.h"
#import "SaveTextMsgRequest.h"
#import "SaveImageMsgRequest.h"

@interface IMRequestManager()
@property (nonatomic, strong) GetMemberTopicsRequest *getTopicsRequest;
@property (nonatomic, strong) GetTopicsRequest *topicDetailRequest;
@property (nonatomic, strong) GetTopicMsgsRequest *msgsRequest;
@property (nonatomic, strong) CreateTopicRequest *createTopicRequest;
@property (nonatomic, strong) SaveTextMsgRequest *saveTextMsgRequest;
@property (nonatomic, strong) SaveImageMsgRequest *saveImageMsgRequest;
@property (nonatomic, strong) GetTopicsRequest *getTopicInfoRequest;
@property (nonatomic, strong) MqttServerRequest *mqttServerRequest;

@property (nonatomic, assign) NSTimeInterval timeoffset;
@end

@implementation IMRequestManager
+ (IMRequestManager *)sharedInstance {
    static IMRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMRequestManager alloc] init];
    });
    return manager;
}

- (void)updateTimeOffsetWithServerTime:(NSTimeInterval)serverTime {
    if (self.timeoffset == 0) {
        NSTimeInterval interval = [[NSDate date]timeIntervalSince1970];
        self.timeoffset = serverTime - interval*1000;
    }
}

- (void)requestTopicsWithCompleteBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.getTopicsRequest stopRequest];
    self.getTopicsRequest = [[GetMemberTopicsRequest alloc]init];
    self.getTopicsRequest.reqId = reqId;
    WEAK_SELF
    [self.getTopicsRequest startRequestWithRetClass:[GetMemberTopicsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetMemberTopicsRequestItem *item = (GetMemberTopicsRequestItem *)retItem;
        [self updateTimeOffsetWithServerTime:item.currentTime.doubleValue];
        NSMutableArray *array = [NSMutableArray array];
        for (TopicData_topic *topicItem in item.data.topic) {
            [array addObject:[topicItem toIMTopic]];
        }
        BLOCK_EXEC(completeBlock,array,nil);
    }];
}

- (void)requestTopicDetailWithTopicIds:(NSString *)topicIds completeBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.topicDetailRequest stopRequest];
    self.topicDetailRequest = [[GetTopicsRequest alloc]init];
    self.topicDetailRequest.reqId = reqId;
    self.topicDetailRequest.topicIds = topicIds;
    WEAK_SELF
    [self.topicDetailRequest startRequestWithRetClass:[GetTopicsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetTopicsRequestItem *item = (GetTopicsRequestItem *)retItem;
        NSMutableArray *array = [NSMutableArray array];
        for (TopicData_topic *topicItem in item.data.topic) {
            [array addObject:[topicItem toIMTopic]];
        }
        BLOCK_EXEC(completeBlock,array,nil);
    }];
}

- (void)requestTopicMsgsWithTopicID:(int64_t)topicID
                            startID:(int64_t)startID
                           asending:(BOOL)asending
                            dataNum:(NSInteger)num
                      completeBlock:(void(^)(NSArray<IMTopicMessage *> *msgs,NSError *error))completeBlock {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.msgsRequest stopRequest];
    self.msgsRequest = [[GetTopicMsgsRequest alloc]init];
    self.msgsRequest.reqId = reqId;
    self.msgsRequest.topicId = [NSString stringWithFormat:@"%@",@(topicID)];
    self.msgsRequest.startId = [NSString stringWithFormat:@"%@",@(startID)];
    self.msgsRequest.order = asending? @"asc":@"desc";
    self.msgsRequest.dataNum = [NSString stringWithFormat:@"%@",@(num)];
    WEAK_SELF
    [self.msgsRequest startRequestWithRetClass:[GetTopicMsgsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetTopicMsgsRequestItem *item = (GetTopicMsgsRequestItem *)retItem;
        NSMutableArray *array = [NSMutableArray array];
        for (TopicMsgData_topicMsg *msg in item.data.topicMsg) {
            [array addObject:[msg toIMTopicMessage]];
        }
        BLOCK_EXEC(completeBlock,array,nil);
    }];
}

- (void)requestNewTopicWithMember:(IMMember *)member fromGroup:(int64_t)groupID completeBlock:(void(^)(IMTopic *topic,NSError *error))completeBlock {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.createTopicRequest stopRequest];
    self.createTopicRequest = [[CreateTopicRequest alloc]init];
    self.createTopicRequest.reqId = reqId;
    self.createTopicRequest.topicType = @"1";
    if (groupID > 0) {
        self.createTopicRequest.fromGroupTopicId = [NSString stringWithFormat:@"%@",@(groupID)];
    }
    if (member.memberID > 0) {
        self.createTopicRequest.imMemberIds = [NSString stringWithFormat:@"%@,%@",@([IMManager sharedInstance].currentMember.memberID),@(member.memberID)];
    }else if (member.userID > 0) {
        self.createTopicRequest.yxUsers = [NSString stringWithFormat:@"%@,%@",@([IMManager sharedInstance].currentMember.userID),@(member.userID)];
    }
    WEAK_SELF
    [self.createTopicRequest startRequestWithRetClass:[CreateTopicRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        CreateTopicRequestItem *item = (CreateTopicRequestItem *)retItem;
        BLOCK_EXEC(completeBlock,[item.data.topic.firstObject toIMTopic],nil);
    }];
}

- (void)requestSaveTextMsgWithMsg:(IMTextMessage *)msg completeBlock:(void(^)(IMTopicMessage *msg,NSError *error))completeBlock{
    WEAK_SELF
    [self.saveTextMsgRequest stopRequest];
    self.saveTextMsgRequest = [[SaveTextMsgRequest alloc]init];
    self.saveTextMsgRequest.topicId = [NSString stringWithFormat:@"%@",@(msg.topicID)];
    self.saveTextMsgRequest.msg = msg.text;
    self.saveTextMsgRequest.reqId = msg.uniqueID;
    [self.saveTextMsgRequest startRequestWithRetClass:[SaveTextMsgRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        SaveTextMsgRequestItem *item = (SaveTextMsgRequestItem *)retItem;
        TopicMsgData_topicMsg *topicMsg = item.data.topicMsg.firstObject;
        BLOCK_EXEC(completeBlock,[topicMsg toIMTopicMessage],nil);
    }];
}

- (void)requestSaveImageMsgWithMsg:(IMImageMessage *)msg completeBlock:(void(^)(IMTopicMessage *msg,NSError *error))completeBlock{
    WEAK_SELF
    [self.saveImageMsgRequest stopRequest];
    self.saveImageMsgRequest = [[SaveImageMsgRequest alloc]init];
    self.saveImageMsgRequest.topicId = [NSString stringWithFormat:@"%@",@(msg.topicID)];
    self.saveImageMsgRequest.width = [NSString stringWithFormat:@"%@",@(msg.width)];
    self.saveImageMsgRequest.height = [NSString stringWithFormat:@"%@",@(msg.height)];
    self.saveImageMsgRequest.rid = msg.resourceID;
    self.saveImageMsgRequest.reqId = msg.uniqueID;
    [self.saveImageMsgRequest startRequestWithRetClass:[SaveImageMsgRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        SaveImageMsgRequestItem *item = (SaveImageMsgRequestItem *)retItem;
        TopicMsgData_topicMsg *topicMsg = item.data.topicMsg.firstObject;
        BLOCK_EXEC(completeBlock,[topicMsg toIMTopicMessage],nil);
    }];
}

- (void)requestTopicInfoWithTopicId:(NSString *)topicId completeBlock:(void(^)(IMTopic *topic,NSError *error))completeBlock {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.getTopicInfoRequest stopRequest];
    self.getTopicInfoRequest = [[GetTopicsRequest alloc]init];
    self.getTopicInfoRequest.reqId = reqId;
    self.getTopicInfoRequest.topicIds = topicId;
    WEAK_SELF
    [self.getTopicInfoRequest startRequestWithRetClass:[GetTopicsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        GetTopicsRequestItem *item = (GetTopicsRequestItem *)retItem;
        TopicData_topic *topic = item.data.topic.firstObject;
        BLOCK_EXEC(completeBlock,[topic toIMTopic],nil);
    }];
}

- (void)requestMqttServerWithCompleteBlock:(void(^)(MqttServerConfig *config,NSError *error))completeBlock {
    [self.mqttServerRequest stopRequest];
    self.mqttServerRequest = [[MqttServerRequest alloc]init];
    WEAK_SELF
    [self.mqttServerRequest startRequestWithRetClass:[MqttServerRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"kMqttServerKey"];
            MqttServerRequestItem *item = [[MqttServerRequestItem alloc]initWithString:json error:nil];
            BLOCK_EXEC(completeBlock,[item.data toServerConfig],error);
            return;
        }
        MqttServerRequestItem *item = (MqttServerRequestItem *)retItem;
        BLOCK_EXEC(completeBlock,[item.data toServerConfig],nil);
        [[NSUserDefaults standardUserDefaults]setValue:[item toJSONString] forKey:@"kMqttServerKey"];
    }];
}

@end
