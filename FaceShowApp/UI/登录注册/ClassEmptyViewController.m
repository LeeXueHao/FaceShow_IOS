
//
//  ClassEmptyViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassEmptyViewController.h"
#import "EmptyView.h"

@interface ClassEmptyViewController ()
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation ClassEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择班级";
    WEAK_SELF
    [self nyx_setupLeftWithTitle:@"退出" action:^{
        STRONG_SELF
        [self backAction];
    }];
    
    self.emptyView = [[EmptyView alloc] init];
    self.emptyView.title = @"暂无班级";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
