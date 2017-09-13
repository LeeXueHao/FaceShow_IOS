//
//  YXMockParser.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/5/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXMockParser : NSObject

- (instancetype)initWithConfigFile:(NSString *)filename;

@property (nonatomic, readonly, assign) NSInteger timeUse;

- (BOOL)hasMockDataForKey:(NSString *)key;
- (NSString *)mockDataForKey:(NSString *)key;
@end
