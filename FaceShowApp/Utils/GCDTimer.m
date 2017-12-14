//
//  GCDTimer.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()
@property (nonatomic, strong) dispatch_source_t timerSource;
@property (nonatomic, strong) void(^triggerBlock) (void);
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) NSTimeInterval interval;
@end

@implementation GCDTimer

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats triggerBlock:(void(^)(void))triggerBlock {
    if (self = [super init]) {
        self.triggerBlock = triggerBlock;
        self.repeats = repeats;
        self.interval = interval;
        [self setupTimer];
    }
    
    return self;
}

- (void)setupTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t timerInterval = self.interval * NSEC_PER_SEC;
    if (!self.repeats) {
        timerInterval = DISPATCH_TIME_FOREVER;
    }
    dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), timerInterval, 0.0f);
    WEAK_SELF
    dispatch_source_set_event_handler(self.timerSource, ^{
        STRONG_SELF
        [self sendTriggerEvent];
    });
    __block dispatch_source_t timerSource = self.timerSource;
    dispatch_source_set_cancel_handler(timerSource, ^{
        timerSource = nil;
    });
}

- (void)sendTriggerEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        BLOCK_EXEC(self.triggerBlock);
    });
}

- (void)resume {
    dispatch_resume(self.timerSource);
}

- (void)suspend {
    dispatch_source_cancel(self.timerSource);
    [self setupTimer];
}

@end
