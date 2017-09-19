//
//  publicationMomentViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PostMomentViewController.h"
#import <SAMTextView.h>
@interface PostMomentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *publicationMomentView;
@property (nonatomic, strong) SAMTextView *publicationMomentTextView;
@property (nonatomic, strong) UIImageView *publicationImageView;
@end

@implementation PostMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f);
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:self.scrollView];
    
    self.publicationMomentView = [[UIView alloc] init];
    self.publicationMomentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.publicationMomentView];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publicationMomentView.mas_left);
        make.right.equalTo(self.publicationMomentView.mas_right);
        make.top.equalTo(self.publicationMomentView.mas_top);
        make.height.mas_offset(5.0f);
    }];
    self.publicationMomentTextView = [[SAMTextView alloc] init];
    self.publicationMomentTextView.delegate = self;
    self.publicationMomentTextView.font = [UIFont systemFontOfSize:14.0f];
    self.publicationMomentTextView.textColor = [UIColor colorWithHexString:@"333333"];
    self.publicationMomentTextView.placeholder = @"这一刻的想法......";
    [self.publicationMomentView addSubview:self.publicationMomentTextView];
    
    
    self.publicationImageView = [[UIImageView alloc] init];
    self.publicationImageView.image = self.publicationImage;
    [self.publicationMomentView addSubview:self.publicationImageView];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [self nyx_setupLeftWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [self nyx_setupRightWithCustomView:rightButton];
    
}
- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.publicationMomentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_offset(195.0f);
    }];
    
    [self.publicationMomentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publicationMomentView.mas_left).offset(15.0f);
        make.right.equalTo(self.publicationMomentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.publicationMomentView.mas_top).offset(20.0f);
        make.height.mas_offset(90.0f);
    }];
    
    [self.publicationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publicationMomentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.publicationMomentView.mas_bottom).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(60.0f, 60.0f));
    }];
}
#pragma mark - UITextViewDelegates
-(void)textViewDidChange:(UITextView *)textView {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:@{                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle}];
}
@end
