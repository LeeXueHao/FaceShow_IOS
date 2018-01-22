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
#import "ImageAttachmentContainerView.h"
#import "QiniuDataManager.h"

@interface PublishMomentViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *publicationMomentView;
@property (nonatomic, strong) SAMTextView *publicationMomentTextView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) ClassMomentPublishRequest *publishRequest;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) ImageAttachmentContainerView *imageContainerView;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableArray *resIdArray;

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
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
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
        NSLog(@"--------UIControlEventTouchUpInside--------");
        [self.view nyx_startLoading];
        if (self.imageArray.count == 0) {
            [self requestForPublishMoment:nil];
        }else {
            [self requestForUploadImage];
        }
    }];
    self.publishButton = rightButton;
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
        make.left.equalTo(self.publicationMomentView.mas_left).offset(0.0f);
        make.bottom.equalTo(self.publicationMomentView.mas_bottom).offset(0.0f);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 70*3+10*4));
    }];
    self.imageContainerView = [[ImageAttachmentContainerView alloc]init];
    [self.imageContainerView setImagesChangeBlock:^(NSArray *images) {
        STRONG_SELF
        self.imageArray = [NSMutableArray arrayWithArray:images];
        [self refreshImages];
    }];
    [containerView addSubview:self.imageContainerView];
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)deleteBtnAction {
    [self.publicationMomentTextView resignFirstResponder];
    [self.imageArray removeObjectAtIndex:0];
    [self refreshImages];
}

- (void)imageBtnAction:(UIButton *)sender {
    [self.publicationMomentTextView resignFirstResponder];
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
    BOOL publishEnabled = [self.publicationMomentTextView.text yx_stringByTrimmingCharacters].length != 0;
    if (!isEmpty(self.imageArray)) {
        publishEnabled = publishEnabled || YES;
    } else {
        publishEnabled = publishEnabled || NO;
    }
    self.publishButton.enabled = publishEnabled;
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
        make.height.mas_offset(195.0f+210);
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
//    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage] || [self stringContainsEmoji:text]) {
//        return NO;
//    }
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
    self.imageIndex = 0;
    self.resIdArray = [NSMutableArray array];
    [self.view nyx_startLoading];
    [self nyx_disableRightNavigationItem];
    [self uploadImageWithIndex:self.imageIndex];
}

- (void)uploadImageWithIndex:(NSInteger)index {
    UIImage *img = self.imageArray[index];
    NSData *data = [UIImage compressionImage:img limitSize:0.1 * 1024 * 1024];
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:nil completeBlock:^(NSString *key, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self nyx_enableRightNavigationItem];
            [self.view nyx_showToast:@"发布失败请重试"];
            return;
        }
        [self.resIdArray addObject:[NSString stringWithFormat:@"%@|jpeg",key]];
        self.imageIndex++;
        if (self.imageIndex < self.imageArray.count) {
            [self uploadImageWithIndex:self.imageIndex];
        }else {
            [self requestForPublishMoment:[self.resIdArray componentsJoinedByString:@","]];
        }
    }];
}
- (void)requestForPublishMoment:(NSString *)resourceIds{
    ClassMomentPublishRequest *request = [[ClassMomentPublishRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    request.content = self.publicationMomentTextView.text;
    request.resourceIds = resourceIds;
    [self nyx_disableRightNavigationItem];
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentPublishRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        ClassMomentPublishRequestItem *item = retItem;
        if (item.data == nil) {
            [self nyx_enableRightNavigationItem];
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self nyx_enableRightNavigationItem];
                [self.view nyx_stopLoading];
                BLOCK_EXEC(self.publishMomentDataBlock,item.data);
                [self dismiss];
            });
            
        }
    }];
    self.publishRequest = request;
}
@end
