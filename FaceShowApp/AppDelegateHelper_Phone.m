//
//  AppDelegateHelper_Phone.m
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper_Phone.h"
#import "LoginViewController.h"
#import "MainPageViewController.h"
#import "MessageViewController.h"
#import "ClassMomentViewController.h"
#import "MineViewController.h"
#import "YXTestViewController.h"
#import "FSTabBarController.h"
#import "UserMessageManager.h"
#import "GetSigninRequest.h"
#import "ApnsSignInDetailViewController.h"
#import "ApnsQuestionnaireViewController.h"
#import "ApnsMessageDetailViewController.h"
#import "ApnsCourseDetailViewController.h"
#import "ApnsResourceDisplayViewController.h"
#import "GetResourceDetailRequest.h"
#import "UserSignInRequest.h"
#import "SubScanCodeResultViewController.h"
#import "UserPromptsManager.h"
#import "YXDrawerViewController.h"
#import "ChatListViewController.h"
#import "ChatPlaceViewController.h"
#import "ClassSelectionViewController.h"

@interface AppDelegateHelper_Phone()
@property (nonatomic, strong) GetSigninRequest *getSigninRequest;
@property (nonatomic, strong) GetResourceDetailRequest *resourceDetailRequest;
@property (nonatomic, strong) UserSignInRequest *userSignInRequest;
@end

@implementation AppDelegateHelper_Phone

- (UIViewController *)rootViewController{
    if ([ConfigManager sharedInstance].testFrameworkOn.boolValue) {
        return [self testViewController];
    }else if (![UserManager sharedInstance].loginStatus) {
        return [self loginViewController];
    }else {
        if (![UserManager sharedInstance].hasUsedBefore) {
            return [self classSelectionViewController];
        }
        return [self mainViewController];
    }
}

- (UIViewController *)testViewController {
    YXTestViewController *vc = [[YXTestViewController alloc]init];
    return [[FSNavigationController alloc]initWithRootViewController:vc];
}

- (UIViewController *)loginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    return [[FSNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)classSelectionViewController {
    ClassSelectionViewController *vc = [[ClassSelectionViewController alloc] init];
    return [[FSNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)mainViewController {
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
    UIViewController *mainVC = [[MainPageViewController alloc]init];
    mainVC.title = @"首页";
    [self configTabbarItem:mainVC.tabBarItem image:@"首页icon" selectedImage:@"首页icon选择"];
    FSNavigationController *mainNavi = [[FSNavigationController alloc] initWithRootViewController:mainVC];
    
    UIViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.title = @"通知";
    [self configTabbarItem:messageVC.tabBarItem image:@"通知icon" selectedImage:@"通知icon选择"];
    FSNavigationController *messageNavi = [[FSNavigationController alloc] initWithRootViewController:messageVC];
    
    UIViewController *classVC = [[ClassMomentViewController alloc]init];
    classVC.title = @"班级圈";
    [self configTabbarItem:classVC.tabBarItem image:@"朋友圈icon" selectedImage:@"朋友圈icon选择"];
    FSNavigationController *classNavi = [[FSNavigationController alloc] initWithRootViewController:classVC];
    
    ChatListViewController *chatVC = [[ChatListViewController alloc]init];
//    ChatPlaceViewController *chatVC = [[ChatPlaceViewController alloc]init];
    chatVC.title = @"聊聊";
    [self configTabbarItem:chatVC.tabBarItem image:@"聊天icon正常态" selectedImage:@"聊天icon点击态"];
    FSNavigationController *chatNavi = [[FSNavigationController alloc] initWithRootViewController:chatVC];
    
    tabBarController.viewControllers = @[mainNavi, messageNavi, classNavi, chatNavi];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
    drawerVC.paneViewController = tabBarController;
    drawerVC.drawerViewController = mineVC;
    drawerVC.drawerWidth = 305*kPhoneWidthRatio;
    
    UIView *redPointView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3 / 8 + 2, 6, 9, 9)];
    redPointView.layer.cornerRadius = 4.5f;
    redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    redPointView.hidden = YES;
    [tabBarController.tabBar addSubview:redPointView];
    [tabBarController.tabBar bringSubviewToFront:redPointView];
    [UserMessageManager sharedInstance].redPointView = redPointView;
    
    UIView *momentNewView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 5 / 8 + 2, 6, 9, 9)];
    momentNewView.layer.cornerRadius = 4.5f;
    momentNewView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    momentNewView.hidden = YES;
    [tabBarController.tabBar addSubview:momentNewView];
    [tabBarController.tabBar bringSubviewToFront:momentNewView];
    [UserPromptsManager sharedInstance].momentNewView = momentNewView;
    
    UIView *unreadView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 7 / 8 + 2, 6, 9, 9)];
    unreadView.layer.cornerRadius = 4.5f;
    unreadView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    unreadView.hidden = YES;
    [tabBarController.tabBar addSubview:unreadView];
    [tabBarController.tabBar bringSubviewToFront:unreadView];
    chatVC.unreadPromptView = unreadView;
    
    return drawerVC;
}

- (void)configTabbarItem:(UITabBarItem *)tabBarItem image:(NSString *)image selectedImage:(NSString *)selectedImage {
    tabBarItem.image = [UIImage imageNamed:image];
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"a1a8b2"],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"1da1f2"]} forState:UIControlStateSelected];
}

#pragma mark -
- (void)handleLoginSuccess {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleLogoutSuccess {
    [self.window.rootViewController presentViewController:[self loginViewController] animated:YES completion:nil];
}

- (void)handleClassChange {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

#pragma mark -
- (void)handleOpenUrl:(NSURL *)url {
    if (![UserManager sharedInstance].loginStatus) {
        return;
    }
    YXDrawerViewController *drawer = (YXDrawerViewController *)self.window.rootViewController;
    FSTabBarController *tabVC = (FSTabBarController *)drawer.paneViewController;
    FSNavigationController *navi = tabVC.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    tabVC.selectedIndex = 0;
    
//    NSDictionary *parametersDic = [UserSignInHelper getParametersFromUrlString:url.absoluteString];
//    if (isEmpty(parametersDic) ||
//        [UserManager sharedInstance].loginStatus == NO) {
//        return;
//    }
//    [self.window nyx_startLoading];
//    [self.userSignInRequest stopRequest];
//    self.userSignInRequest = [[UserSignInRequest alloc] init];
//    self.userSignInRequest.stepId = parametersDic[kStepId];
//    self.userSignInRequest.timestamp = parametersDic[kTimestamp];
//    WEAK_SELF
//    [self.userSignInRequest startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//        STRONG_SELF
//        [self.window nyx_stopLoading];
//        if (error && error.code == 1) {
//            [self.window nyx_showToast:error.localizedDescription];
//            return;
//        }
//        UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
//        SubScanCodeResultViewController *scanCodeResultVC = [[SubScanCodeResultViewController alloc] init];
//        scanCodeResultVC.data = error ? nil : item.data;
//        scanCodeResultVC.error = error ? item.error : nil;
//
//        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:scanCodeResultVC];
//        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//    }];
}

#pragma mark - Apns
- (void)handleApnsData:(YXApnsContentModel *)apns {
    NSInteger type = apns.type.integerValue;
    if (type == 100) {
        [self goSignInWithData:apns];
    }else if (type == 101) {
        [self goVoteWithData:apns];
    }else if (type == 102) {
        [self goQuestionnaireWithData:apns];
    }else if (type == 120) {
        [self goNoticeDetailWithData:apns];
    }else if (type == 130) {
        [self goClassWithData:apns];
    }else if (type == 131) {
        [self goResourceWithData:apns];
    }else if (type == 140) {
        [self goCourseDetailWithData:apns];
    }
}

- (void)goSignInWithData:(YXApnsContentModel *)data {
    [self.getSigninRequest stopRequest];
    self.getSigninRequest = [[GetSigninRequest alloc]init];
    self.getSigninRequest.stepId = data.objectId;
    WEAK_SELF
    [self.getSigninRequest startRequestWithRetClass:[GetSigninRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [[UIApplication sharedApplication].keyWindow nyx_showToast:error.localizedDescription];
            return;
        }
        GetSigninRequestItem *item = retItem;
        ApnsSignInDetailViewController *signInDetailVC = [[ApnsSignInDetailViewController alloc] init];
        signInDetailVC.signIn = item.data.signIn;
        FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:signInDetailVC];
        [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
    }];
}

- (void)goVoteWithData:(YXApnsContentModel *)data {
    ApnsQuestionnaireViewController *vc = [[ApnsQuestionnaireViewController alloc]initWithStepId:data.objectId interactType:InteractType_Vote];
    vc.name = data.title;
    FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)goQuestionnaireWithData:(YXApnsContentModel *)data {
    ApnsQuestionnaireViewController *vc = [[ApnsQuestionnaireViewController alloc]initWithStepId:data.objectId interactType:InteractType_Questionare];
    vc.name = data.title;
    FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)goNoticeDetailWithData:(YXApnsContentModel *)data {
    ApnsMessageDetailViewController *vc = [[ApnsMessageDetailViewController alloc]init];
    vc.noticeId = data.objectId;
    FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (void)goClassWithData:(YXApnsContentModel *)data {
    FSTabBarController *tabBarController = (FSTabBarController *)self.window.rootViewController;
    if ([tabBarController isKindOfClass:[FSTabBarController class]]) {
        tabBarController.selectedIndex = 0;
    }
}

- (void)goResourceWithData:(YXApnsContentModel *)data {
    [self.resourceDetailRequest stopRequest];
    self.resourceDetailRequest = [[GetResourceDetailRequest alloc] init];
    self.resourceDetailRequest.resId = data.objectId;
    WEAK_SELF
    [self.resourceDetailRequest startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [[UIApplication sharedApplication].keyWindow nyx_showToast:error.localizedDescription];
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        ApnsResourceDisplayViewController *vc = [[ApnsResourceDisplayViewController alloc] init];
        vc.urlString = item.data.type.integerValue ? item.data.url : item.data.ai.previewUrl;
        vc.name = item.data.resName;
        FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:vc];
        [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
    }];
}

- (void)goCourseDetailWithData:(YXApnsContentModel *)data {
    ApnsCourseDetailViewController *vc = [[ApnsCourseDetailViewController alloc]init];
    vc.courseId = data.objectId;
    FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:vc];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
}

- (UIViewController *)lastPresentedViewController {
    UIViewController *vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

@end
