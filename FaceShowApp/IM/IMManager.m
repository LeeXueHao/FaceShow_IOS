//
//  IMManager.m
//  TestIM
//
//  Created by niuzhaowang on 2017/12/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "IMManager.h"
#import "IMConnectionManager.h"
#import "IMDatabaseManager.h"
#import "IMServiceManager.h"
#import "IMImageMessageSender.h"
#import "IMTextMessageSender.h"

@interface IMManager()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) IMMember *currentMember;
@property (nonatomic, strong) NSString *sceneID;
@end

@implementation IMManager
+ (IMManager *)sharedInstance {
    static IMManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMManager alloc] init];
    });
    return manager;
}

- (void)setupWithCurrentMember:(IMMember *)member token:(NSString *)token {
    self.currentMember = member;
    self.token = token;
    [[IMDatabaseManager sharedInstance]saveMember:member];
    [[IMDatabaseManager sharedInstance]markAllUncompleteMessagesFailed];
}

- (void)setupWithSceneID:(NSString *)sceneID {
    self.sceneID = sceneID;
}

- (void)startConnection {
    [[IMServiceManager sharedInstance]start];
}

- (void)stopConnection {
    [[IMServiceManager sharedInstance]stop];
}

@end
