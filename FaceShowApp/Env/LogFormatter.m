//
//  LogFormatter.m
//  MyTest
//
//  Created by CaiLei on 12/4/14.
//  Copyright (c) 2014 leso. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *path = logMessage->_file;
    NSString *levelString = @"";
    switch (logMessage->_flag) {
        case DDLogFlagError:
        {
            levelString = @"[ERROR]";
        }
            break;
        case DDLogFlagWarning:
        {
            levelString = @"[WARNING]";
        }
            break;
        case DDLogFlagInfo:
        {
            levelString = @"[INFO]";
        }
            break;
        case DDLogFlagDebug:
        {
            levelString = @"[DEBUG]";
        }
            break;
        case DDLogFlagVerbose:
        {
            levelString = @"[VERBOSE]";
        }
            break;
            
        default:
        {
            levelString = @"";
        }
            break;
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:logMessage ->_timestamp];
    NSDate *localeDate = [logMessage ->_timestamp dateByAddingTimeInterval:interval];
    return [NSString stringWithFormat:@"%@%@ >> %-20s %-15@ %4lu | %@",
            levelString,
            localeDate,
            [[path lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding],
            logMessage->_function,
            (unsigned long)logMessage->_line,
            logMessage->_message];
}

@end
