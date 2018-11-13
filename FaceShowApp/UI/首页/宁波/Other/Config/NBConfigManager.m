//
//  NBConfigManager.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBConfigManager.h"
#import "NBBaseViewController.h"
@interface NBConfigManager()
@property (nonatomic, strong) NSDictionary *vcDictionary;
@end

@implementation NBConfigManager

+ (instancetype)sharedInstance{
    static NBConfigManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NBConfigManager alloc] init];
    });
    return manager;
}


- (UIViewController *)getViewControllerWithType:(NSString *)type pageConfig:(GetClassConfigRequest_Item_pageConf  * _Nullable )pageConf andTabConfigArray:(NSArray<GetClassConfigRequest_Item_tabConf *>  * _Nullable )tabArray{
    NSString *vcClassStr = [[self vcDictionary] valueForKey:type];
    Class vcClass = NSClassFromString(vcClassStr);
    UIViewController *vc = (UIViewController *)[[vcClass alloc] init];
    vc.title = pageConf.pageName;
    if([vc isKindOfClass:[NBBaseViewController class]]){
        [vc setValue:pageConf forKey:@"pageConf"];
        [vc setValue:tabArray forKey:@"tabConf"];
    }
    return vc;
}

- (NSDictionary *)vcDictionary{
    if (!_vcDictionary) {
        _vcDictionary = @{
                          @"index":@"NBMainPageViewController",
                          @"task":@"TaskListViewController",
                          @"circle":@"ClassMomentViewController",
                          @"chat":@"ChatListViewController",
                          @"link":@"NBLiveViewController",
                          @"course":@"MeetingListViewController",
                          @"schedule":@"NBScheduleViewController",
                          @"notice":@"MessageViewController",
                          @"resource":@"NBResourceListViewController"
                          };
    }
    return _vcDictionary;
}


@end
