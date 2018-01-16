//
//  TestQiniuViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TestQiniuViewController.h"
#import "QiniuTokenRequest.h"

@interface TestQiniuViewController ()
@property (nonatomic, strong) QiniuTokenRequest *request;
@end

@implementation TestQiniuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *tokenButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 80, 50)];
    [tokenButton setTitle:@"token" forState:UIControlStateNormal];
    tokenButton.backgroundColor = [UIColor redColor];
    [tokenButton addTarget:self action:@selector(getToken) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tokenButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getToken {
    [self.request stopRequest];
    self.request = [[QiniuTokenRequest alloc]init];
    WEAK_SELF
    [self.request startRequestWithRetClass:[QiniuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"success"];
    }];
}

@end
