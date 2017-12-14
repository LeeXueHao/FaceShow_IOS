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
#import "PhotoBrowserController.h"
#import "YXImagePickerController.h"
#import "AlertView.h"
#import "FDActionSheetView.h"

@interface PublishMomentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *publicationMomentView;
@property (nonatomic, strong) SAMTextView *publicationMomentTextView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) ClassMomentPublishRequest *publishRequest;
@end

@implementation PublishMomentViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"班级圈";
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
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.publicationMomentTextView.typingAttributes = dic;
    [self.publicationMomentView addSubview:self.publicationMomentTextView];
    
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
    if (self.imageArray.count == 0) {
        rightButton.enabled = NO;
    }
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
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
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.imageArray.count != 0) {
            rightButton.enabled = YES;
            return;
        }
        UITextView *tempTextView = (UITextView *)x.object;
        rightButton.enabled = [tempTextView.text yx_stringByTrimmingCharacters].length != 0;
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [self.publicationMomentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publicationMomentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.publicationMomentView.mas_bottom).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(70.0f, 70.0f));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publicationMomentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.publicationMomentView.mas_bottom).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(60.0f, 60.0f));
    }];
    self.addImageBtn = btn;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"小图片删除按钮正常态"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"小图片删除按钮点击态"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(30, -25));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.deleteBtn = deleteBtn;
    [self refreshImages];
}

- (void)deleteBtnAction {
    [self.imageArray removeObjectAtIndex:0];
    [self refreshImages];
}

- (void)imageBtnAction:(UIButton *)sender {
    if (isEmpty(self.imageArray)) {
        [self showImagePicker];
    } else {
        PhotoBrowserController *vc = [[PhotoBrowserController alloc] init];
        vc.images = self.imageArray;
        vc.currentIndex = 0;
        WEAK_SELF
        vc.didDeleteImage = ^{
            STRONG_SELF
            [self refreshImages];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)refreshImages {
    if (!isEmpty(self.imageArray)) {
        [self.addImageBtn setImage:self.imageArray[0] forState:UIControlStateNormal];
        self.deleteBtn.hidden = NO;
    } else {
        [self.addImageBtn setImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 60, 60)] forState:UIControlStateNormal];
        self.deleteBtn.hidden = YES;
    }
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
        make.height.mas_offset(self.imageArray.count > 0 ? 90.0f : 140.0f);
    }];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - imagePicker
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}

- (void)showImagePicker {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"拍照"}, @{@"title":@"相册"}];
    AlertView *alertView = [[AlertView alloc] init];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.hideWhenMaskClicked = YES;
    alertView.contentView = actionSheetView;
    WEAK_SELF
    [alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(155.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        [self.imagePickerController pickImageWithSourceType:integer == 1 ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self.imageArray addObject:selectedImage];
            [self refreshImages];
        }];
        [alertView hide];
    };
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineHeightMultiple = 1.2f;
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.attributedText.string attributes:@{                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle}];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage] || [self stringContainsEmoji:text]) {
        return NO;
    }
    return YES;
}
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    
                                    //                                    if (0x2100 <= high && high <= 0x27BF){
                                    //                                        returnValue = YES;
                                    //                                    }
                                }
                            }];
    
    return returnValue;
}
#pragma mark - request
- (void)requestForUploadImage{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[UserManager sharedInstance].userModel.userID, (int)interval];
    [self.view nyx_startLoading];
    WEAK_SELF
    [QADataManager uploadFile:self.imageArray[0] fileName:fileName completeBlock:^(QAFileUploadSecondStepRequestItem *item, NSError *error) {
        STRONG_SELF
         if (item.result.resid == nil){
             [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            [self requestForPublishMoment:item.result.resid];
        }
    }];
}
- (void)requestForPublishMoment:(NSString *)resourceIds{
    ClassMomentPublishRequest *request = [[ClassMomentPublishRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    request.content = self.publicationMomentTextView.text;
    request.resourceIds = resourceIds;
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentPublishRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        ClassMomentPublishRequestItem *item = retItem;
        if (item.data == nil) {
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self.view nyx_stopLoading];
                BLOCK_EXEC(self.publishMomentDataBlock,item.data);
                [self dismiss];
            });
            
        }
    }];
    self.publishRequest = request;
}
@end
