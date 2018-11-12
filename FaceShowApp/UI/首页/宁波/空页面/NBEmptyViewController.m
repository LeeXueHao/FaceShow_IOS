//
//  NBEmptyViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBEmptyViewController.h"
#import "YXDrawerController.h"

#import "GetClassConfigRequest.h"

@interface NBEmptyViewController ()

@property (nonatomic, strong) GetClassConfigRequest *request;

@end

@implementation NBEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];

    [self setupUI];

}

- (void)setupUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 5.0f;
    [btn setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.25]];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];

    WEAK_SELF
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self requestClassConfig];
    }];

}

- (void)requestClassConfig{
    [self.request stopRequest];
    [self.view nyx_startLoading];
    self.request = [[GetClassConfigRequest alloc] init];
    self.request.modleId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.modelId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetClassConfigRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].configItem = (GetClassConfigRequest_Item *)retItem;
        [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
    }];
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
