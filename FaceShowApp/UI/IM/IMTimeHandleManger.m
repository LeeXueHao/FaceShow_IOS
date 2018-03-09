//
//  IMTimeHandleManger.m
//  FaceShowApp
//
//  Created by ZLL on 2018/2/27.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTimeHandleManger.h"

@implementation IMTimeHandleManger

+ (long)compareTime1:(NSTimeInterval)time1 withTime2:(NSTimeInterval)time2 type:(IMTimeType)type {
    NSTimeInterval timeSpan = time2 - time1;
    timeSpan = timeSpan/1000.0;
    long result = 0;
    switch (type) {
        case IMTimeType_Second:
            result = (long)timeSpan;    //秒
            break;
        case IMTimeType_Minute:
            result = (long)timeSpan/60;    //分
            break;
        case IMTimeType_Hour:
            result = (long)timeSpan/60/60;    //时
            break;
        case IMTimeType_Day:
            result = (long)timeSpan/60/60/24;    //天
            break;
        case IMTimeType_Month:
            result = (long)timeSpan/60/60/24/30;    //月
            break;
        case IMTimeType_Year:
            result = (long)timeSpan/60/60/24/365;    //年
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)compareCurrentTimeWithOriginalTimeObtainDisplayedTimeString:(NSTimeInterval)originalTime {
    
    NSTimeInterval tempMilli = originalTime;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else if (nowCmps.month != myCmps.month) {
        dateFmt.dateFormat = @"MM-dd hh:mm";
    }else {
        if (nowCmps.day == myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaahh:mm";
            
        }else if ((nowCmps.day - myCmps.day) <= 7) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            
            switch (comp.weekday) {
                case 1:
                    dateFmt.dateFormat = @"星期日 aaahh:mm";
                    break;
                case 2:
                    dateFmt.dateFormat = @"星期一 aaahh:mm";
                    break;
                case 3:
                    dateFmt.dateFormat = @"星期二 aaahh:mm";
                    break;
                case 4:
                    dateFmt.dateFormat = @"星期三 aaahh:mm";
                    break;
                case 5:
                    dateFmt.dateFormat = @"星期四 aaahh:mm";
                    break;
                case 6:
                    dateFmt.dateFormat = @"星期五 aaahh:mm";
                    break;
                case 7:
                    dateFmt.dateFormat = @"星期六 aaahh:mm";
                    break;
                default:
                    break;
            }
        }else {
            dateFmt.dateFormat = @"MM-dd hh:mm";
        }
    }
    return [dateFmt stringFromDate:myDate];
}

@end
