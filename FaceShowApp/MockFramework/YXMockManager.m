//
//  YXMockManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/5/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXMockManager.h"
#import "YXMockParser.h"

@interface YXMockManager()
@property (nonatomic, strong) YXMockParser *parser;
@end

@implementation YXMockManager
+ (YXMockManager *)sharedInstance {
    NSAssert([YXMockManager class] == self, @"Incorrect use of singleton : %@, %@", [YXMockManager class], [self class]);
    static dispatch_once_t once;
    static YXMockManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.parser = [[YXMockParser alloc]initWithConfigFile:@"MockConfig"];
    });
    
    return sharedInstance;
}

- (BOOL)hasMockDataForKey:(NSString *)key{
    return [self.parser hasMockDataForKey:key];
}

- (NSString *)mockDataForKey:(NSString *)key{
    return [self.parser mockDataForKey:key];
}

- (NSInteger)requestDuration{
    return self.parser.timeUse;
}


@end
