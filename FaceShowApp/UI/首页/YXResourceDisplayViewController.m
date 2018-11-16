//
//  YXResourceDisplayViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXResourceDisplayViewController.h"
#import "ResourceDownloadViewController.h"
#import "ShareManager.h"

@interface YXResourceDisplayViewController ()
@property (nonatomic, assign) BOOL needReload;
@end

@implementation YXResourceDisplayViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needReload = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.naviBarHidden animated:NO];
    if (self.needReload) {
        [self reloadWebview];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.needReload = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    if(self.needDownload){
        if (isEmpty([UserManager sharedInstance].configItem) || [UserManager sharedInstance].configItem.data.resourceDown) {
            [self nyx_setupRightWithTitle:@"下载" action:^{
                STRONG_SELF
                [TalkingData trackEvent:@"资源下载"];
                ResourceDownloadViewController *downLoad = [[ResourceDownloadViewController alloc] init];
                downLoad.resourceId = self.resourceId;
                downLoad.downloadUrl = self.downloadUrl;
                [self.navigationController pushViewController:downLoad animated:YES];
            }];
        }
    }else{
        [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享" action:^{
            STRONG_SELF
            [self shareUrl];
        }];
    }
}

- (void)shareUrl{

    NSString *shareUrl = [[ShareManager sharedInstance] generateShareUrlWithOriginUrl:self.urlString];
    NSArray *items = @[shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
    };
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.view;
            popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
        }
    }
    [self presentViewController:activityVC animated:YES completion:NULL];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
