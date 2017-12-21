//
//  FeedbackViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2017/12/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "MineActionView.h"
#import "FeedbackRequest.h"

@interface FeedbackViewController ()
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) FeedbackRequest *feedbackRequest;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.textView = [[SAMTextView alloc]init];
    self.textView.layer.cornerRadius = 6.f;
    self.textView.clipsToBounds = YES;
    [self.textView setTintColor:[UIColor colorWithHexString:@"999999"]];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    NSString *placeholderStr = @"请输入您的宝贵意见,最多输入200字";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, placeholderStr.length)];
    self.textView.attributedPlaceholder = attrStr;
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 25, 15);
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.height.mas_equalTo(230.f);
        make.bottom.mas_equalTo(-50);
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    WEAK_SELF
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self sendFeedback];
    }];
    [self nyx_setupRightWithCustomView:self.rightButton];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.textView rac_textSignal]subscribeNext:^(NSString *text) {
        STRONG_SELF
        if (text.length>200) {
            self.textView.text = [text substringWithRange:NSMakeRange(0, 200)];
        }
        self.rightButton.enabled = text.length>0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    }];
}

- (void)sendFeedback {
    [self.textView resignFirstResponder];
    if (self.textView.text.length<2) {
        [self.view nyx_showToast:@"请详细描述您的问题，至少2个字"];
        return;
    }
    [self.view nyx_startLoading];
    [self.feedbackRequest stopRequest];
    self.feedbackRequest = [[FeedbackRequest alloc]init];
    self.feedbackRequest.content = self.textView.text;
    WEAK_SELF
    [self.feedbackRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"发送成功"];
        [self backAction];
    }];
}


@end
