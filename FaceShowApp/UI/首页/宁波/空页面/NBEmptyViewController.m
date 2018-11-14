//
//  NBEmptyViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBEmptyViewController.h"
#import "YXDrawerController.h"
#import "EmptyView.h"
#import "GetClassConfigRequest.h"

@interface NBEmptyViewController ()
@property (nonatomic, strong) EmptyView *emptyView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setupUI{

    self.emptyView = [[EmptyView alloc] init];
    self.emptyView.title = @"没有配置信息\n请切换班级或登录其他账号";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
