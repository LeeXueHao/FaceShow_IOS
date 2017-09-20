//
//  publicationMomentViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PublishMomentViewController.h"
#import <SAMTextView.h>
#import "QADataManager.h"
@interface PublishMomentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *publicationMomentView;
@property (nonatomic, strong) SAMTextView *publicationMomentTextView;
@property (nonatomic, strong) UIImageView *publicationImageView;

@property (nonatomic, strong) ClassMomentPublishRequest *publishRequest;
@end

@implementation PublishMomentViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
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
    if (self.imageArray.count > 0) {
        self.publicationImageView.image = self.imageArray[0];
    }
    [self.publicationMomentView addSubview:self.publicationImageView];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.imageArray.count == 0) {
            [self dismiss];
        }else {
            [self showAlertView];
        }
    }];
    [self nyx_setupLeftWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        if (self.imageArray.count == 0) {
            [self requestForPublishMoment:nil];
        }else {
            [self requestForUploadImage];
        }
    }];
    [self nyx_setupRightWithCustomView:rightButton];
}
- (void)showAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出此次编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        
    }];
    [alertVC addAction:cancleAction];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self dismiss];
    }];
    [alertVC addAction:backAction];
    [[self nyx_visibleViewController] presentViewController:alertVC animated:YES completion:nil];
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
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - UITextViewDelegates
-(void)textViewDidChange:(UITextView *)textView {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:@{                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle}];
}
#pragma mark - request
- (void)requestForUploadImage{
    WEAK_SELF
    [QADataManager uploadFile:self.imageArray[0] fileName:@"发布" completeBlock:^(QAFileUploadSecondStepRequestItem *item, NSError *error) {
        STRONG_SELF
         if (item.result.resid == nil){
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            [self requestForPublishMoment:item.result.resid];
        }
    }];
}
- (void)requestForPublishMoment:(NSString *)resourceIds{
    ClassMomentPublishRequest *request = [[ClassMomentPublishRequest alloc] init];
    request.claszId = self.claszId;
    request.content = self.publicationMomentTextView.text;
    request.resourceIds = resourceIds;
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentPublishRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        ClassMomentPublishRequestItem *item = retItem;
        if (item.data == nil) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            BLOCK_EXEC(self.publishMomentDataBlock,item.data);
            [self dismiss];
        }
    }];
    self.publishRequest = request;
}
@end
