//
//  IMConnectionManager.m
//  TestIM
//
//  Created by niuzhaowang on 2017/12/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "IMConnectionManager.h"
#import <MQTTClient/MQTTClient.h>
#import "MqttMsg.pbobjc.h"
#import "ImMqtt.pbobjc.h"
#import "IMEventHandlerFactory.h"

NSString * const kIMConnectionDidCloseNotification = @"kIMConnectionDidCloseNotification";

@interface IMConnectionManager()<MQTTSessionDelegate>
@property (nonatomic, strong) MQTTSession *mySession;
@end

@implementation IMConnectionManager
+ (IMConnectionManager *)sharedInstance {
    static IMConnectionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMConnectionManager alloc] init];
    });
    return manager;
}

- (void)connectWithHost:(NSString *)host
                   port:(NSUInteger)port
               username:(NSString *)username
               password:(NSString *)password {
    [self disconnect];
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc]init];
    transport.host = host;
    transport.port = (UInt32)port;
    self.mySession = [[MQTTSession alloc]init];
    self.mySession.transport = transport;
    self.mySession.delegate = self;
    self.mySession.userName = username;
    self.mySession.password = password;
    [self.mySession connectAndWaitTimeout:3];
}

- (void)disconnect {
    [self.mySession closeWithDisconnectHandler:^(NSError *error) {
        
    }];
}

- (void)subscribeTopic:(NSString *)topic {
    [self.mySession subscribeToTopic:topic atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"subscribe error:%@",error.localizedDescription);
        }else {
            NSLog(@"successful qos:%@",gQoss);
        }
    }];
}

- (void)unsubscribeTopic:(NSString *)topic {
    [self.mySession unsubscribeTopic:topic unsubscribeHandler:nil];
}

- (BOOL)isConnectionOpen {
    return self.mySession.status != MQTTSessionStatusClosed;
}

#pragma mark - MQTTSessionDelegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSError *error = nil;
    MqttMsg *msg = [MqttMsg parseFromData:data error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    ImMqtt *imMsg = [ImMqtt parseFromData:msg.data_p error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    IMEventHandler *eventHandler = [IMEventHandlerFactory eventHandlerWithEventID:imMsg.imEvent];
    for (NSData *data in imMsg.bodyArray) {
        [eventHandler handleData:data inTopic:topic];
    }
}

- (void)connectionClosed:(MQTTSession *)session {
    [[NSNotificationCenter defaultCenter]postNotificationName:kIMConnectionDidCloseNotification object:nil];
}

@end
