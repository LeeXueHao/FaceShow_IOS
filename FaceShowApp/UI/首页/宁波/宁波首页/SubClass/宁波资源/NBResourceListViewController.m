//
//  NBResourceListViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBResourceListViewController.h"
#import "EmptyView.h"

@interface NBResourceListViewController ()
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation NBResourceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emptyView = [[EmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)refreshUI{
    
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
