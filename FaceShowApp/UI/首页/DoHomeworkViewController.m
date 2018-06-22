//
//  DoHomeworkViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "DoHomeworkViewController.h"
#import <SAMTextView.h>
#import "QADataManager.h"
#import "PhotoBrowserController.h"
#import "YXImagePickerController.h"
#import "AlertView.h"
#import "FDActionSheetView.h"
#import "ImageAttachmentContainerView.h"
#import "QiniuDataManager.h"
#import "FinishedHomeworkViewController.h"
#import "SubmitUserHomeworkRequest.h"
#import "GetHomeworkRequest.h"

NSString *kHomeworkFinishedNotification = @"kHomeworkFinishedNotification";

@interface DoHomeworkViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SAMTextView *titleTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) SAMTextView *contentTextView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) ImageAttachmentContainerView *imageContainerView;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) SubmitUserHomeworkRequest *submitRequest;
@property(nonatomic, strong) GetHomeworkRequest *getHomeworkRequest;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableArray *resIdArray;

@end

@implementation DoHomeworkViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"研修总结";
    [self setupNavView];
    [self setupUI];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavView {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    if (self.imageArray.count == 0) {
        rightButton.enabled = NO;
    }
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        NSLog(@"--------UIControlEventTouchUpInside--------");
        [self.view nyx_startLoading];
        if (self.imageArray.count == 0) {
            [self requestForSubmitHomework:nil];
        }else {
            [self requestForUploadImage];
        }
    }];
    self.submitButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}

- (void)backAction {
    if (self.imageArray.count == 0 && self.contentTextView.text.length == 0 && self.titleTextView.text.length == 0) {
        [super backAction];
    }else {
        [self showAlertView];
    }
}

- (void)showAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出此次编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        
    }];
    [alertVC addAction:cancleAction];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [super backAction];
    }];
    [alertVC addAction:exitAction];
    [[self nyx_visibleViewController] presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - setupUI
- (void)setupUI {
    [self setupTitleView];
    [self setupContentView];
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc]init];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.titleLabel.text = @"标题:";
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.titleTextView = [[SAMTextView alloc]init];
    self.titleTextView.backgroundColor = [UIColor whiteColor];
    self.titleTextView.font = [UIFont systemFontOfSize:14];
    self.titleTextView.textColor = [UIColor colorWithHexString:@"333333"];
    //    NSString *placeholderStr = @"作业标题（最多20字）";
    //    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    //    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"] range:NSMakeRange(0, placeholderStr.length)];
    //    [attrStr addAttribute:NSFontAttributeName value:self.titleTextView.font range:NSMakeRange(0, placeholderStr.length)];
    //    self.titleTextView.attributedPlaceholder = attrStr;
    //    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineHeightMultiple = 1.2;
    //    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    //    self.titleTextView.typingAttributes = dic;
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(14, 0, 11, 0);
    self.titleTextView.delegate = self;
    self.titleTextView.scrollEnabled = NO;
    [self.titleView addSubview:self.titleTextView];
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(-15);
    }];
}

- (void)setupContentView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f);
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_offset(180.0f+[ImageAttachmentContainerView heightForCount:0]);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    self.contentTextView = [[SAMTextView alloc] init];
    self.contentTextView.delegate = self;
    self.contentTextView.font = [UIFont systemFontOfSize:15.0f];
    self.contentTextView.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentTextView.placeholder = @"此处编辑内容";
    NSMutableParagraphStyle *paraStyle1 = [[NSMutableParagraphStyle alloc] init];
    paraStyle1.lineHeightMultiple = 1.2;
    NSDictionary *dic1 = @{NSParagraphStyleAttributeName:paraStyle1,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.contentTextView.typingAttributes = dic1;
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
        make.height.mas_offset(self.imageArray.count > 0 ? 90.0f : 140.0f);
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0.0f);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, [ImageAttachmentContainerView heightForCount:0]));
    }];
    self.imageContainerView = [[ImageAttachmentContainerView alloc]init];
    WEAK_SELF
    [self.imageContainerView setImagesChangeBlock:^(NSArray *images) {
        STRONG_SELF
        self.imageArray = [NSMutableArray arrayWithArray:images];
        [self refreshSubmitButtonEnable];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.scrollView.mas_top);
            make.height.mas_offset(180.0f+[ImageAttachmentContainerView heightForCount:images.count]);
        }];
        [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0.0f);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, [ImageAttachmentContainerView heightForCount:images.count]));
        }];
    }];
    [containerView addSubview:self.imageContainerView];
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)refreshSubmitButtonEnable {
    BOOL hasTitle = [self.titleTextView.text yx_stringByTrimmingCharacters].length != 0;
    BOOL publishEnabled = [self.contentTextView.text yx_stringByTrimmingCharacters].length != 0;
    if (!isEmpty(self.imageArray)) {
        publishEnabled = publishEnabled || YES;
    } else {
        publishEnabled = publishEnabled || NO;
    }
    self.submitButton.enabled = publishEnabled && hasTitle;
    DDLogDebug(@"self.publishButton.enabled =%@",@(self.submitButton.enabled));
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
            [self refreshSubmitButtonEnable];
        }];
        [alertView hide];
    };
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self refreshSubmitButtonEnable];
    if ([textView isEqual:self.titleTextView]) {
        if ([textView.text length] > 20) {
            textView.text = [textView.text substringToIndex:20];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (str.length > 200) {
        str = [str substringToIndex:200];
        textView.text = str;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextPosition* beginning = textView.beginningOfDocument;
            UITextPosition* startPosition = [textView positionFromPosition:beginning offset:200];
            UITextPosition* endPosition = [textView positionFromPosition:beginning offset:200];
            UITextRange* selectionRange = [textView textRangeFromPosition:startPosition toPosition:endPosition];
            [textView setSelectedTextRange:selectionRange];
        });
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
            [self requestForSubmitHomework:[self.resIdArray componentsJoinedByString:@","]];
        }
    }];
}
- (void)requestForSubmitHomework:(NSString *)resourceIds{
    [self.submitRequest stopRequest];
    self.submitRequest = [[SubmitUserHomeworkRequest alloc] init];
    self.submitRequest.stepId = self.homework.stepId;
    self.submitRequest.title = self.titleTextView.text;
    self.submitRequest.content = self.contentTextView.text;
    self.submitRequest.resourceKey = resourceIds;
    [self nyx_disableRightNavigationItem];
    WEAK_SELF
    [self.submitRequest startRequestWithRetClass:[SubmitUserHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self nyx_enableRightNavigationItem];
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"提交失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self nyx_enableRightNavigationItem];
                [self.view nyx_stopLoading];
                [self requestHomework];
                [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkFinishedNotification object:nil];
            });
        }
    }];
}

- (void)requestHomework {
    [self.getHomeworkRequest stopRequest];
    self.getHomeworkRequest = [[GetHomeworkRequest alloc]init];
    self.getHomeworkRequest.stepId = self.homework.stepId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.getHomeworkRequest startRequestWithRetClass:[GetHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        GetHomeworkRequestItem *item = (GetHomeworkRequestItem *)retItem;
        FinishedHomeworkViewController *vc = [[FinishedHomeworkViewController alloc]init];
        vc.userHomework = item.data.userHomework;
        vc.homework = item.data.homework;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end

