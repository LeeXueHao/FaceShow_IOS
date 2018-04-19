//
//  UpgradePromptHandler.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpgradePromptHandler.h"

@interface UpgradePromptHandler ()
@property (nonatomic, strong) YXInitRequestItem_Body *body;
@end

@implementation UpgradePromptHandler
- (void)handleWithUpgradeBody:(YXInitRequestItem_Body *)body {
    self.body = body;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.body.title message:self.body.content preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.body.fileURL]];
    }];
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    if (self.body.isForce) {
        [alert addAction:exitAction];
        [alert addAction:updateAction];
    }
    else {
        [alert addAction:laterAction];
        [alert addAction:updateAction];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
