//
//  CourseBriefViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseBriefViewController.h"
#import "EmptyView.h"

@interface CourseBriefViewController ()
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation CourseBriefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UITextView *tv = [[UITextView alloc]init];
    tv.backgroundColor = [UIColor clearColor];
    tv.textContainerInset = UIEdgeInsetsMake(25, 15, 25, 15);
    tv.textColor = [UIColor colorWithHexString:@"333333"];
    tv.font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.brief attributes:dic];
    tv.attributedText = attributeStr;
    tv.editable = NO;
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = !isEmpty(self.brief);
}

@end
