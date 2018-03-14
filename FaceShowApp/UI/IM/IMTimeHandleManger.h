//
//  IMTimeHandleManger.h
//  FaceShowApp
//
//  Created by ZLL on 2018/2/27.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int64_t,IMTimeType) {
    IMTimeType_Second = 1,
    IMTimeType_Minute,
    IMTimeType_Hour,
    IMTimeType_Day,
    IMTimeType_Month,
    IMTimeType_Year
};

@interface IMTimeHandleManger : NSObject

/**
 比较两个时间的间隔

 @param time1 要比较的时间
 @param time2 参考时间
 @param type 返回的时间类型
 @return 时间间隔
 */
+ (long)compareTime1:(NSTimeInterval)time1
         withTime2:(NSTimeInterval)time2
                     type:(IMTimeType)type;

/**
 将消息的发送时间的时间戳转换为要显示的字符串
 
 @param currentTime 当前的时间戳(加上与server的时间差后)
 @param originalTime 要转化的时间戳
 @return 符合要求的字符串
 0.当天的消息 显示上/下午+收发消息的时间 (注没日期)
 1.消息超过1天、小于1周，显示星期+收发消息的时间（注没日期）
 2.消息大于1周，显示手机收发的时间（注 日期+时间)
 3.1年内的,显示手机收发的时间（注 日期+时间)
 4.超过1年的,显示手机收发的时间（注 年+日期+时间)
 */
+ (NSString *)displayedTimeStringComparedCurrentTime:(NSTimeInterval)currentTime
                                        WithOriginalTime:(NSTimeInterval)originalTime;
@end
