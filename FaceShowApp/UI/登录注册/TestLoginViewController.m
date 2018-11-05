//
//  TestLoginViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TestLoginViewController.h"
#import "YXInputView.h"
@interface TestLoginViewController ()
@property (nonatomic, strong) YXInputView *inputView;
@end

@implementation TestLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.inputView = [[YXInputView alloc] init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
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
