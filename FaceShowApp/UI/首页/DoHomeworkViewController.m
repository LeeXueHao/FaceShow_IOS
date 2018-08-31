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
#import "HomeworkAttachmentView.h"
#import "AttachmentUploadGuideViewController.h"
#import "ResourceTypeMapping.h"
#import "ResourceDisplayViewController.h"
#import "YXPlayerViewController.h"

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

@property (nonatomic, strong) NSMutableArray *attachmentViewArray;
@property (nonatomic, strong) UIView *attachTitleView;
@property (nonatomic, assign) BOOL isDraft;
@end

@implementation DoHomeworkViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attachmentViewArray = [NSMutableArray array];
    self.title = self.homework.title;
    [self setupMock];
    [self setupNavView];
    [self setupUI];
    [self setupObservers];
    [self refreshSubmitButtonEnable];
}
- (void)setupMock {
    GetHomeworkRequestItem_attachmentInfo *attach1 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach1.resName = @"附件1";
    attach1.ext = @"doc";
    attach1.previewUrl = @"http://pavlal4my.bkt.clouddn.com/Fh0Q6qT3-7pbhKXBQsvk0XifJHNH";
    GetHomeworkRequestItem_attachmentInfo *attach2 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach2.resName = @"附件2";
    attach2.ext = @"xlsx";
    attach2.previewUrl = @"http://pavlal4my.bkt.clouddn.com/Fh0Q6qT3-7pbhKXBQsvk0XifJHNH";
    GetHomeworkRequestItem_attachmentInfo *attach3 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach3.resName = @"附件3";
    attach3.ext = @"ppt";
    attach3.previewUrl = @"http://pavlal4my.bkt.clouddn.com/Fh0Q6qT3-7pbhKXBQsvk0XifJHNH";
    GetHomeworkRequestItem_attachmentInfo *attach4 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach4.resName = @"附件4";
    attach4.ext = @"jpg";
    attach4.previewUrl = @"http://imgsrc.baidu.com/imgad/pic/item/b21bb051f8198618076e0ba640ed2e738bd4e6e3.jpg";
    GetHomeworkRequestItem_attachmentInfo *attach5 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach5.resName = @"附件5";
    attach5.ext = @"m3u8";
    attach5.previewUrl = @"http://yuncdn.teacherclub.com.cn/course/cf/ts/xkb/zgxsfzhxsyjg/video/4.1-1_l/4.1-1_l.m3u8";
//    self.userHomework = [[GetHomeworkRequestItem_userHomework alloc]init];
    self.userHomework.attachmentInfos2 = @[attach1,attach2,attach3,attach4,attach5];
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
        self.isDraft = NO;
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
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.titleLabel.text = @"标题:";
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    
    self.titleTextView = [[SAMTextView alloc]init];
    self.titleTextView.backgroundColor = [UIColor whiteColor];
    self.titleTextView.font = [UIFont systemFontOfSize:14];
    self.titleTextView.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(14, 0, 11, 0);
    self.titleTextView.delegate = self;
    self.titleTextView.scrollEnabled = NO;
    self.titleTextView.text = self.userHomework.title;
    [self.titleView addSubview:self.titleTextView];
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.height.mas_greaterThanOrEqualTo(45);
    }];
}

- (void)setupContentView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 50);
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-47);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-47);
        }
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
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
    if (self.userHomework.content) {
        self.contentTextView.attributedText = [[NSAttributedString alloc]initWithString:self.userHomework.content attributes:dic1];
    }
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(90);
    }];

    self.imageContainerView = [[ImageAttachmentContainerView alloc]init];
    NSMutableArray<ImageAttachment *> *attachArray = [NSMutableArray array];
    for (GetHomeworkRequestItem_attachmentInfo *attach in self.userHomework.attachmentInfos) {
        ImageAttachment *item = [[ImageAttachment alloc]init];
        item.url = attach.previewUrl;
        item.resId = attach.resKey;
        [attachArray addObject:item];
    }
    [self.imageContainerView addImages:attachArray];
    WEAK_SELF
    [self.imageContainerView setImagesChangeBlock:^(NSArray *images) {
        STRONG_SELF
        self.imageArray = [NSMutableArray arrayWithArray:images];
        [self refreshSubmitButtonEnable];
        [self.imageContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([ImageAttachmentContainerView heightForCount:images.count]);
        }];
    }];
    [self.contentView addSubview:self.imageContainerView];
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo([ImageAttachmentContainerView heightForCount:self.userHomework.attachmentInfos.count]);
    }];
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.imageContainerView.mas_bottom);
        make.height.mas_offset(5.0f);
    }];
    UIView *attachmentContainerView = [[UIView alloc]init];
    [self.contentView addSubview:attachmentContainerView];
    [attachmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(sepView.mas_bottom);
        
    }];
    UIView *titleView = [[UIView alloc]init];
    self.attachTitleView = titleView;
    [attachmentContainerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
        if (self.userHomework.attachmentInfos2.count == 0) {
            make.bottom.mas_equalTo(0);
        }
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"作业附件:";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UIView *top = titleView;
    for (GetHomeworkRequestItem_attachmentInfo *item in self.userHomework.attachmentInfos2) {
        HomeworkAttachmentView *attach = [[HomeworkAttachmentView alloc]init];
        attach.data = item;
        WEAK_SELF
        [attach setDeleteAction:^(HomeworkAttachmentView *attachment){
            STRONG_SELF
            [self deleteAttachWithIndex:[self.attachmentViewArray indexOfObject:attachment]];
        }];
        [attach setPreviewAction:^(HomeworkAttachmentView *attachment) {
            STRONG_SELF
            [self previewAttachment:attachment.data];
        }];
        [attachmentContainerView addSubview:attach];
        [attach mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
            CGFloat t = [self.userHomework.attachmentInfos2 indexOfObject:item]==0? 0:5;
            make.top.mas_equalTo(top.mas_bottom).mas_offset(t);
            if (self.userHomework.attachmentInfos2.lastObject == item) {
                make.bottom.mas_equalTo(0);
            }
        }];
        [self.attachmentViewArray addObject:attach];
        top = attach;
    }
    UIButton *uploadAttachButton = [[UIButton alloc]init];
    [uploadAttachButton setTitle:@"上传附件" forState:UIControlStateNormal];
    [uploadAttachButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    uploadAttachButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [[uploadAttachButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self uploadAttachment];
    }];
    [self.view addSubview:uploadAttachButton];
    [uploadAttachButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.height.mas_equalTo(47);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    UIButton *draftButton = [uploadAttachButton clone];
    [draftButton setTitle:@"存草稿" forState:UIControlStateNormal];
    [draftButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [[draftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self saveDraft];
    }];
    [self.view addSubview:draftButton];
    [draftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.height.mas_equalTo(47);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    if ([self.userHomework.finishStatus isEqualToString:@"1"]) {
        draftButton.enabled = NO;
    }
}

- (void)deleteAttachWithIndex:(NSInteger)index {
    UIView *deleteView = self.attachmentViewArray[index];
    [deleteView removeFromSuperview];
    if (index+1 < self.attachmentViewArray.count) {
        HomeworkAttachmentView *back = self.attachmentViewArray[index+1];
        UIView *top = self.attachTitleView;
        if (index-1>=0) {
            top = self.attachmentViewArray[index-1];
        }
        [back mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat t = top==self.attachTitleView? 0:5;
            make.top.mas_equalTo(top.mas_bottom).mas_offset(t);
        }];
    }else{
        if (index-1>=0) {
            UIView *top = self.attachmentViewArray[index-1];
            [top mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }
    }
    [self.attachmentViewArray removeObjectAtIndex:index];
    if (self.attachmentViewArray.count == 0) {
        [self.attachTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)previewAttachment:(GetHomeworkRequestItem_attachmentInfo *)attach {
    if ([[ResourceTypeMapping resourceTypeWithString:attach.ext] isEqualToString:@"video"]) {
        YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
        vc.videoUrl = attach.previewUrl;
        vc.title = attach.resName;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc]init];
        vc.urlString = attach.previewUrl;
        vc.name = attach.resName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)uploadAttachment {
    AttachmentUploadGuideViewController *vc = [[AttachmentUploadGuideViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveDraft {
    self.isDraft = YES;
    [self.view nyx_startLoading];
    if (self.imageArray.count == 0) {
        [self requestForSubmitHomework:nil];
    }else {
        [self requestForUploadImage];
    }
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
    if (str.length > 1500) {
        str = [str substringToIndex:1500];
        textView.text = str;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextPosition* beginning = textView.beginningOfDocument;
            UITextPosition* startPosition = [textView positionFromPosition:beginning offset:1500];
            UITextPosition* endPosition = [textView positionFromPosition:beginning offset:1500];
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
    ImageAttachment *attach = self.imageArray[index];
    if (!isEmpty(attach.resId)) {
        [self.resIdArray addObject:attach.resId];
        self.imageIndex++;
        if (self.imageIndex < self.imageArray.count) {
            [self uploadImageWithIndex:self.imageIndex];
        }else {
            [self requestForSubmitHomework:[self.resIdArray componentsJoinedByString:@","]];
        }
        return;
    }
    UIImage *img = self.imageArray[index].image;
    NSData *data = [UIImage compressionImage:img limitSize:0.1 * 1024 * 1024];
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:nil completeBlock:^(NSString *key,NSString *host, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self nyx_enableRightNavigationItem];
            [self.view nyx_showToast:@"发布失败请重试"];
            return;
        }
        NSString *resId = [NSString stringWithFormat:@"%@|jpeg",key];
        [self.resIdArray addObject:resId];
        self.imageArray[self.imageIndex].resId = resId;
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
    self.submitRequest.finishStatus = self.isDraft? @"0":@"1";
    NSMutableArray *attachIdArray = [NSMutableArray array];
    for (HomeworkAttachmentView *attach in self.attachmentViewArray) {
        [attachIdArray addObject:attach.data.resId];
    }
    self.submitRequest.attachment2 = [attachIdArray componentsJoinedByString:@","];
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
        BLOCK_EXEC(self.userHomeworkUpdateBlock,item.data.userHomework);
        if ([self.userHomework.finishStatus isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.isDraft) {
            [self.view nyx_showToast:@"保存成功"];
        }else {
            FinishedHomeworkViewController *vc = [[FinishedHomeworkViewController alloc]init];
            vc.userHomework = item.data.userHomework;
            vc.homework = item.data.homework;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end

