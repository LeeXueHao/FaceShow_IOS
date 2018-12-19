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
#import "ResourceTypeMapping.h"

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
        [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享点击态" action:^{
            STRONG_SELF
            [self shareUrl];
        }];
    }
}

- (void)shareUrl{

    NSString *str;
#ifdef HuBeiApp
    str = @"来自湖北师训的分享";
#else
    str = @"来自研修宝的分享";
#endif
    NSString *sourceType = [ResourceTypeMapping resourceTypeWithString:self.suffix];
    if ([sourceType isEqualToString:@"image"]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:[NSURL URLWithString:self.urlString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            NSArray *items;
            if (!error) {
                items = @[image];
            }else{
                if (isEmpty(self.name)) {
                    items = @[str,imageURL];
                }else{
                    items = @[self.name,imageURL];
                }
            }
            [self shareWithItems:items];
        }];
    }else{
        NSURL *fileUrl;
        NSMutableArray *items = [NSMutableArray array];
        if (isEmpty(self.name)) {
            [items addObject:str];
        }else{
            [items addObject:self.name];
        }
        if (self.needDownload) {
            fileUrl = [NSURL fileURLWithPath:self.urlString];
            [items addObject:fileUrl];
            if (!isEmpty(self.originUrlStr)) {
                [items addObject:[NSURL URLWithString:self.originUrlStr]];
            }
        }else{
            fileUrl = [NSURL URLWithString:self.urlString];
            [items addObject:fileUrl];
        }
        [self shareWithItems:items];
    }

}

- (void)shareWithItems:(NSArray *)items{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeCopyToPasteboard];
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
