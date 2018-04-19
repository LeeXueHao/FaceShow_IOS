//
//  YXMockParser.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/5/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXMockParser.h"

UIKIT_EXTERN BOOL mockFrameworkOn;

@interface YXMockItemConfig : NSObject
@property (nonatomic, assign) BOOL mockEnable;
@property (nonatomic, strong) NSArray *fileArray;
@end
@implementation YXMockItemConfig
@end

@interface YXMockItemFileConfig : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) NSInteger percent;
@end
@implementation YXMockItemFileConfig
@end

@interface YXMockParser()
@property (nonatomic, assign) BOOL mockEnable;
@property (nonatomic, assign) NSInteger maxTimeUse;
@property (nonatomic, strong) NSMutableDictionary *configDic;
@end

@implementation YXMockParser

- (instancetype)initWithConfigFile:(NSString *)filename{
    if (self = [super init]) {
        self.configDic = [NSMutableDictionary dictionary];
        [self setupWithFileName:filename];
    }
    return self;
}

- (void)setupWithFileName:(NSString *)filename{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    self.mockEnable = mockFrameworkOn;
    self.maxTimeUse = ((NSNumber *)[dict valueForKey:@"maxTimeUse"]).integerValue;
    if (!self.mockEnable) {
        return;
    }
    
    NSDictionary *data = [dict valueForKey:@"data"];
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YXMockItemConfig *config = [self configFromDic:obj];
        [self.configDic setValue:config forKey:key];
    }];
}

- (YXMockItemConfig *)configFromDic:(NSDictionary *)dic{
    NSNumber *mockEnable = [dic valueForKey:@"mockEnable"];
    if (!mockEnable.boolValue) {
        return nil;
    }
    NSArray *fileArray = [dic valueForKey:@"mockFile"];
    NSMutableArray *array = [NSMutableArray array];
    [fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = [obj valueForKey:@"fileName"];
        NSNumber *percent = [obj valueForKey:@"percent"];
        if (!isEmpty(fileName) && percent.integerValue>0) {
            YXMockItemFileConfig *fileConfig = [[YXMockItemFileConfig alloc]init];
            fileConfig.fileName = fileName;
            fileConfig.percent = percent.integerValue;
            [array addObject:fileConfig];
        }
    }];
    
    if (fileArray.count>0) {
        YXMockItemConfig *config = [[YXMockItemConfig alloc]init];
        config.mockEnable = mockEnable.boolValue;
        config.fileArray = array;
        return config;
    }
    
    return nil;
}

- (NSInteger)timeUse{
    NSInteger time = arc4random()%(self.maxTimeUse+1);
    return time;
}

- (BOOL)hasMockDataForKey:(NSString *)key{
    YXMockItemConfig *config = [self.configDic valueForKey:key];
    if (config) {
        return YES;
    }
    return NO;
}

- (NSString *)mockDataForKey:(NSString *)key{
    if (![self hasMockDataForKey:key]) {
        return nil;
    }
    YXMockItemConfig *config = [self.configDic valueForKey:key];
    __block NSInteger total = 0;
    [config.fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXMockItemFileConfig *fileConfig = (YXMockItemFileConfig *)obj;
        total += fileConfig.percent;
    }];
    NSInteger value = arc4random()%total;
    __block NSInteger start = 0;
    __block NSString *fileName = nil;
    [config.fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXMockItemFileConfig *fileConfig = (YXMockItemFileConfig *)obj;
        if (value>=start && value<start+fileConfig.percent) {
            fileName = fileConfig.fileName;
            *stop = YES;
        }
        start += fileConfig.percent;
    }];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

@end
