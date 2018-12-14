//
//  ClassMomentViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentViewController.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "ClassMomentHeaderView.h"
#import "ClassMomentCell.h"
#import "ClassMomentTableHeaderView.h"
#import "ClassMomentFooterView.h"
#import "PublishMomentViewController.h"
#import "ClassMomentFloatingView.h"
#import "YXImagePickerController.h"
#import "CommentInputView.h"
#import "ClassMomentListFetcher.h"
#import "ClassMomentClickLikeRequest.h"
#import "ClassMomentCommentRequest.h"
#import "ReportViewController.h"
#import "UserPromptsManager.h"
#import "ClassMomentReplyRequest.h"
#import "ClassMomentCancelLikeRequest.h"
#import "ClassMomentDiscardCommentRequest.h"
#import "ClassMomentDiscardRequest.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "ClassMomentUserViewController.h"
#import "ClassMomentNotificationViewController.h"
#import "FSTabBarController.h"
#import "YXDrawerController.h"
#import "UserPromptsManager.h"
typedef NS_ENUM(NSUInteger,ClassMomentCommentType) {
    ClassMomentComment_Normal = 0,
    ClassMomentComment_Comment = 1,
    ClassMomentComment_Reply = 2,
};


@interface ClassMomentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ClassMomentTableHeaderView *headerView;
@property (nonatomic, strong) ClassMomentFloatingView *floatingView;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) CommentInputView *comInputView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) NSInteger commtentInteger;
@property (nonatomic, strong) NSIndexPath *replyIndexPath;

@property (nonatomic, assign) ClassMomentCommentType commentType;

@property (nonatomic, strong) ClassMomentClickLikeRequest *clickLikeRequest;
@property (nonatomic, strong) ClassMomentCommentRequest *commentRequest;
@property (nonatomic, strong) ClassMomentReplyRequest *replyRequest;
@property (nonatomic, strong) ClassMomentCancelLikeRequest *cancelLikeRequest;
@property (nonatomic, strong) ClassMomentDiscardCommentRequest *discardCommentRequest;
@property (nonatomic, strong) ClassMomentDiscardRequest *discardRequest;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation ClassMomentViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    ClassMomentListFetcher *fetcher = [[ClassMomentListFetcher alloc] init];
    fetcher.pagesize = 20;
    fetcher.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"班级圈";
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self nyx_setupRightWithTitle:@"发布" action:^{
        STRONG_SELF
        PublishMomentViewController *VC = [[PublishMomentViewController alloc]init];
        WEAK_SELF
        VC.publishMomentDataBlock = ^(ClassMomentListRequestItem_Data_Moment *moment) {
            STRONG_SELF
            if (moment != nil) {
                self.emptyView.hidden = YES;
                self.errorView.hidden = YES;
                [self.dataArray insertObject:moment atIndex:0];
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointZero;
            }
        };
        FSNavigationController *navi = [[FSNavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:navi animated:YES completion:nil];
    }];
    [self setupUI];
    [self setupObservers];
//    self.edgesForExtendedLayout = UIRectEdgeAll;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideFloatingView];
}

#pragma mark - set & get
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}
- (ClassMomentFloatingView *)floatingView {
    if (_floatingView == nil) {
        _floatingView = [[ClassMomentFloatingView alloc] init];
    }
    return _floatingView;
}
- (void)setCommtentInteger:(NSInteger)commtentInteger {
    _commtentInteger = commtentInteger;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.emptyView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ClassMomentHeaderView class] forHeaderFooterViewReuseIdentifier:@"ClassMomentHeaderView"];
    [self.tableView registerClass:[ClassMomentCell class] forCellReuseIdentifier:@"ClassMomentCell"];
    [self.tableView registerClass:[ClassMomentFooterView class] forHeaderFooterViewReuseIdentifier:@"ClassMomentFooterView"];
    self.headerView = [[ClassMomentTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157.0f)];
    WEAK_SELF
    self.headerView.classMomentUserButtonBlock = ^(NSInteger tag) {
        STRONG_SELF
        if (tag == 1) {
            ClassMomentUserViewController *VC = [[ClassMomentUserViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            ClassMomentNotificationViewController *VC = [[ClassMomentNotificationViewController alloc] init];
            VC.classMomentNotificationReloadBlock = ^{
                self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 157.0f);
                self.tableView.tableHeaderView = self.headerView;
                [UserPromptsManager sharedInstance].data.momentMsgNew.promptNum = nil;
                if ([UserPromptsManager sharedInstance].data.momentNew.promptNum.integerValue == 0) {
                    [UserPromptsManager sharedInstance].momentNewView.hidden = YES;
                }
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    };
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    NSInteger msgCount = [UserPromptsManager sharedInstance].data.momentMsgNew.promptNum.integerValue;
    if (msgCount > 0) {
        self.headerView.hidden = NO;
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 157.0f + 81.0f);
        self.headerView.messageInteger = msgCount;
        self.tableView.tableHeaderView = self.headerView;
    }
    
    self.comInputView = [[CommentInputView alloc]init];
    self.comInputView.isChangeBool = YES;
    self.comInputView.textView.returnKeyType = UIReturnKeySend;
    self.comInputView.completeBlock = ^(NSString *text) {
        STRONG_SELF
        if (text.length != 0) {
            if (self.commentType == ClassMomentComment_Comment) {
                [self requstForPublishComment:text];
            }else {
                [self requstForReplyComment:text];
            }
        }
    };
    self.comInputView.textHeightChangeBlock = ^(CGFloat textHeight) {
        STRONG_SELF
        [self.comInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight + 12.0f);
        }];
    };
    [self.view addSubview:self.comInputView];
    [self.comInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45.0f);
        make.bottom.mas_equalTo(100.0f);
    }];
    
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.enabled = NO;
    [self.emptyView removeFromSuperview];
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 157.0f)];
    self.emptyView.hidden = NO;
    [self.footerView addSubview:self.emptyView];
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}
- (void)tapAction {
    [self hideFloatingView];
}
- (void)hideFloatingView {
    if (self.floatingView.superview != nil) {
        [self.floatingView hiddenViewAnimate:YES];
        self.tapGesture.enabled = NO;
    }
}
- (void)hiddenInputTextView {
    if (self.commentType == ClassMomentComment_Comment) {
        ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.commtentInteger];
        moment.draftModel = self.comInputView.textView.text;
    }else if (self.commentType == ClassMomentComment_Reply){
        ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.replyIndexPath.section];
        ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[self.replyIndexPath.row];
        comment.draftModel = self.comInputView.textView.text;
    }
    self.comInputView.textString = nil;
    [self.comInputView.textView resignFirstResponder];
    self.commentType = ClassMomentComment_Normal;
}
- (void)stopAnimation {
    [super stopAnimation];
    [self.headerView reload];
    self.headerView.hidden = NO;
}
- (void)hideErrorView {
    [super hideErrorView];
    if (self.dataArray.count == 0) {
        self.emptyView.hidden = NO;
        self.tableView.tableFooterView = self.footerView;
    }else {
        self.tableView.tableFooterView = nil;
    }
}
- (void)showAlertView:(NSIndexPath *)indexPath {
    [self hiddenInputTextView];
    [self hideFloatingView];
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"删除"}];
    self.alertView = [[AlertView alloc]init];
    self.alertView.backgroundColor = [UIColor clearColor];
    self.alertView.hideWhenMaskClicked = YES;
    self.alertView.contentView = actionSheetView;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(105.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [self.alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(105.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(105.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (integer == 1) {
            [self requestForDiscardComment:indexPath];
        }
        [self.alertView hide];
    };
}
- (void)presentNextPublishViewController:(UIImage *)image {
    PublishMomentViewController *VC = [[PublishMomentViewController alloc] init];
    if (image != nil) {
        VC.imageArray = [@[image] mutableCopy];
    }
    WEAK_SELF
    VC.publishMomentDataBlock = ^(ClassMomentListRequestItem_Data_Moment *moment) {
        STRONG_SELF
        if (moment != nil) {
            self.emptyView.hidden = YES;
            self.errorView.hidden = YES;
            [self.dataArray insertObject:moment atIndex:0];
            [self.tableView reloadData];
        }

    };
    FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.comInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (SCREEN_HEIGHT == keyboardFrame.origin.y) {
                    make.bottom.mas_equalTo(-(SCREEN_HEIGHT -keyboardFrame.origin.y) + 100.0f);
                }else {
                    make.bottom.mas_equalTo(-(SCREEN_HEIGHT -keyboardFrame.origin.y) + SafeAreaBottomHeight(self.navigationController.view));
                }
            }];
            [self.view layoutIfNeeded];
        }];
        if (SCREEN_HEIGHT > keyboardFrame.origin.y) {
            UIView *bottomView = nil;
            if (self.commentType == ClassMomentComment_Comment) {
                bottomView = [self.tableView footerViewForSection:self.commtentInteger];
            }else if (self.commentType == ClassMomentComment_Reply){
                bottomView = [self.tableView footerViewForSection:self.replyIndexPath.section];
            }
            if (bottomView != nil) {
                CGRect rect = [bottomView convertRect:bottomView.bounds toView:self.tableView];
                CGFloat bottomY = CGRectGetMaxY(rect);
                CGFloat offset = bottomY - (keyboardFrame.origin.y - self.comInputView.height) + CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.tableView.contentOffset.y;
                if (offset > 0) {
                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+offset) animated:YES];
                }
            }else {
                NSIndexPath *indexPath = nil;
                if (self.commentType == ClassMomentComment_Comment) {
                    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.commtentInteger];
                    indexPath = [NSIndexPath indexPathForRow:moment.comments == 0 ? NSNotFound : moment.comments.count - 1 inSection:self.commtentInteger];
                }else if (self.commentType == ClassMomentComment_Reply){
                    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.replyIndexPath.section];
                    indexPath = [NSIndexPath indexPathForRow:moment.comments.count - 1  inSection:self.replyIndexPath.section];
                }
                [self.tableView beginUpdates];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                [self.tableView endUpdates];
            }
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewMomentNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        NSInteger msgCount = [UserPromptsManager sharedInstance].data.momentMsgNew.promptNum.integerValue;
        if (msgCount > 0) {
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 157.0f + 81.0f);
            self.headerView.messageInteger = msgCount;
            self.tableView.tableHeaderView = self.headerView;
        }else{
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 157.0f);
            self.tableView.tableHeaderView = self.headerView;
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kTabBarDidSelectNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.navigationController == x.object) {
            [self firstPageFetch];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"kReloadMomentNotification" object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        ClassMomentListRequestItem_Data_Moment *moment = noti.object;
        [self.dataArray enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (moment.momentID.integerValue == obj.momentID.integerValue) {
                [self.dataArray replaceObjectAtIndex:idx withObject:moment];
                [self.tableView reloadData];
                *stop = YES;
            }
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewCertificateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        UIBarButtonItem *navItem = self.navigationItem.leftBarButtonItems.lastObject;
        UIButton *customBtn = (UIButton *)navItem.customView;
        UIView *redPointView = [[UIView alloc] init];
        redPointView.layer.cornerRadius = 4.5f;
        redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
        [customBtn.imageView addSubview:redPointView];
        [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-3.5);
            make.top.mas_equalTo(3.5);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasReadCertificateNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        UIBarButtonItem *navItem = self.navigationItem.leftBarButtonItems.lastObject;
        UIButton *customBtn = (UIButton *)navItem.customView;
        [customBtn.imageView removeSubviews];
    }];
}

- (void)firstPageFetch {
    [super firstPageFetch];
    [UserPromptsManager sharedInstance].data.momentNew.promptNum = nil;
    if ([UserPromptsManager sharedInstance].data.momentMsgNew.promptNum.integerValue == 0) {
        [UserPromptsManager sharedInstance].momentNewView.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    return moment.comments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassMomentCell" forIndexPath:indexPath];
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[indexPath.section];
    ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[indexPath.row];
    [cell reloadName:comment.publisher.realName withToReplyName:comment.toUser.realName withComment:comment.content withLast:indexPath.row + 1 == moment.comments.count];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassMomentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassMomentHeaderView"];
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    headerView.moment = moment;
    WEAK_SELF
    headerView.classMomentLikeCommentBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.view];
        [self showFloatView:rect withSection:section];
    };
    headerView.classMomentReportBlock = ^{
        STRONG_SELF
        ReportViewController *vc = [[ReportViewController alloc] init];
        vc.userId = moment.publisher.userID;
        vc.objectId = moment.momentID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    headerView.classMomentOpenCloseBlock = ^(BOOL isOpen) {
        STRONG_SELF
        moment.isOpen = [NSString stringWithFormat:@"%@",@(!isOpen)];
//        [tableView beginUpdates];
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        [tableView endUpdates];
        
//        [tableView beginUpdates];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:section];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [tableView endUpdates];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
        [self.tableView reloadData];

    };
    return headerView;
}
- (void)showFloatView:(CGRect)rect withSection:(NSInteger)section{
    if (self.floatingView.superview != nil) {
        [self hideFloatingView];
        return;
    }
    self.tapGesture.enabled = YES;
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:section];
    if (moment.comments.count > 0) {
        indexPath = [NSIndexPath indexPathForRow:moment.comments.count - 1 inSection:section];
    }
    WEAK_SELF
    self.floatingView.classMomentFloatingBlock = ^(ClassMomentClickStatus status) {
        STRONG_SELF
        self.tapGesture.enabled = NO;
        if (status == ClassMomentClickStatus_Comment) {
            self.commentType = ClassMomentComment_Comment;
            self.commtentInteger = section;
            if (moment.draftModel != nil) {
                self.comInputView.textString = moment.draftModel;
            }
            self.comInputView.placeHolder = @"评论";
            [self.comInputView.textView becomeFirstResponder];
        }else if(status == ClassMomentClickStatus_Like){
            [self requestForClickLike:section];
        }else if(status == ClassMomentClickStatus_Cancel){
            [self requestForCancelLike:section];
        }else if(status == ClassMomentClickStatus_Delete){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               [self requestForDiscardMoment:section];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:delete];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    };
    [self.view addSubview:self.floatingView];
    if (moment.publisher.userID.integerValue == [UserManager sharedInstance].userModel.userID.integerValue &&
        moment.myLike.integerValue >= 0) {
        [self.floatingView reloadFloatingView:rect withStyle:ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Cancel | ClassMomentFloatingStyle_Delete];
    }else if (moment.publisher.userID.integerValue == [UserManager sharedInstance].userModel.userID.integerValue &&
              moment.myLike.integerValue < 0) {
        [self.floatingView reloadFloatingView:rect withStyle:ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Like | ClassMomentFloatingStyle_Delete];
    }else if (moment.publisher.userID.integerValue != [UserManager sharedInstance].userModel.userID.integerValue &&
              moment.myLike.integerValue >= 0) {
        [self.floatingView reloadFloatingView:rect withStyle:ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Cancel];
    }else if (moment.publisher.userID.integerValue != [UserManager sharedInstance].userModel.userID.integerValue &&
             moment.myLike.integerValue < 0) {
        [self.floatingView reloadFloatingView:rect withStyle:ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Like];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ClassMomentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassMomentFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    if (moment.likes.count > 0 || moment.comments.count > 0) {
        return 16.0f;
    }
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ClassMomentCell" configuration:^(ClassMomentCell *cell) {
        ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[indexPath.section];
        ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[indexPath.row];
        [cell reloadName:comment.publisher.realName withToReplyName:comment.toUser.realName withComment:comment.content withLast:indexPath.row + 1 == moment.comments.count];
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hiddenInputTextView];
    [self hideFloatingView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableHeightForHeaderInSection:section];
}
- (CGFloat)tableHeightForHeaderInSection:(NSInteger)section {
    //
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    CGFloat photoHeight = (SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f) * 348.0f/590.0f;
    CGFloat contentHeight = [self sizeForTitle:moment.content?:@""];
    CGFloat height = 15.0f + 5.0f + 14.0f + 6.0f;
    if (contentHeight >= 85.0f) {
        if (!moment.isOpen.boolValue) {
            height += 85.0f;
        }else {
            height += contentHeight;
        }
        height += 14.0 + 10.0f;
    }else {
        height += contentHeight + 1.0f;
    }
    if (moment.albums.count > 0) {
        if (moment.albums.count > 0 && moment.albums.count < 2) {
            height += photoHeight + 5.0f;
        }else if (moment.albums.count >= 2 && moment.albums.count < 4 ){
            height = height + (SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f - 10.0f)/3.0f;
        }else if(moment.albums.count >= 4 && moment.albums.count <= 6){
            height = height + (SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f - 10.0f)/3.0f * 2.0f + 10.0f;
        }else {
            height = height + SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f - 10.0f + 10.0f;
        }
    }

    height = height + 10.0f + 30.0f;
    if (moment.likes.count == 0 && moment.comments.count == 0) {
        height = height + 5.0f;
    }else if (moment.likes.count != 0 && moment.comments.count != 0) {
        NSMutableArray *mutableArrray = [[NSMutableArray alloc] init];
        [moment.likes enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Like *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArrray addObject:obj.publisher.realName?:@""];
        }];
        height = height + 5.0f + 7.0f + [self sizeForLikes:[mutableArrray componentsJoinedByString:@","]] + 10.0f + 20.0f;
        
    }else if (moment.likes.count != 0) {
        NSMutableArray *mutableArrray = [[NSMutableArray alloc] init];
        [moment.likes enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Like *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArrray addObject:obj.publisher.realName?:@""];
        }];
        height = height + 7.0f + 7.0f + 10.0f + [self sizeForLikes:[mutableArrray componentsJoinedByString:@","]] + 10.0f;
    }else {
        NSMutableArray *mutableArrray = [[NSMutableArray alloc] init];
        [moment.likes enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Like *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArrray addObject:obj.publisher.realName?:@""];
        }];
        height = height + 7.0f + 10.0f + 10.0f;
    }
    return ceilf(height)-2.5;
}
- (CGFloat)sizeForLikes:(NSString *)title {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f - 8.0f - 12.0f - 6.0f - 25.0f, 999)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                NSParagraphStyleAttributeName :paragraphStyle} context:NULL];
    return rect.size.height;
}
- (CGFloat)sizeForTitle:(NSString *)title {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 1999)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                NSParagraphStyleAttributeName :paragraphStyle} context:NULL];
    return ceilf(rect.size.height);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideFloatingView];
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[indexPath.section];
    ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[indexPath.row];
    if (comment.userID.integerValue == [UserManager sharedInstance].userModel.userID.integerValue) {
        [self showAlertView:indexPath];
    }else {
        self.commentType = ClassMomentComment_Reply;
        self.replyIndexPath = indexPath;
        if (comment.draftModel != nil) {
            self.comInputView.textString = moment.draftModel;
        }
        self.comInputView.placeHolder = [NSString stringWithFormat:@"回复%@:",comment.publisher.realName];
        [self.comInputView.textView becomeFirstResponder];
    }

}

#pragma mark - request
- (void)requestForClickLike:(NSInteger)section {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    ClassMomentClickLikeRequest *request = [[ClassMomentClickLikeRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    request.momentId = moment.momentID;
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentClickLikeRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        ClassMomentClickLikeRequestItem *item = retItem;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.data != nil) {
            if (moment.likes.count == 0) {
                NSMutableArray<ClassMomentListRequestItem_Data_Moment_Like> *mutableArray = [[NSMutableArray<ClassMomentListRequestItem_Data_Moment_Like> alloc] init];
                [mutableArray addObject:item.data];
                moment.likes = mutableArray;
                moment.myLike = @"0";
            }else {
                moment.myLike = [NSString stringWithFormat:@"%lu",(unsigned long)moment.likes.count];
                [moment.likes addObject:item.data];
            }
            [self.tableView reloadData];
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.clickLikeRequest = request;
}
- (void)requestForCancelLike:(NSInteger) section {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    ClassMomentCancelLikeRequest *request = [[ClassMomentCancelLikeRequest alloc] init];
    request.momentId = moment.momentID;
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        HttpBaseRequestItem *item = retItem;
        if (item.code.integerValue == 0) {
            if (moment.likes.count > moment.myLike.integerValue && moment.myLike.integerValue >= 0) {
                [moment.likes removeObjectAtIndex:moment.myLike.integerValue];
                moment.myLike = @"-1";
                [self.tableView reloadData];
            }
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.cancelLikeRequest = request;
}

- (void)requstForPublishComment:(NSString *)content {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.commtentInteger];
    ClassMomentCommentRequest *request = [[ClassMomentCommentRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    request.momentId = moment.momentID;
    request.content = content;
//    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        ClassMomentCommentRequestItem *item = retItem;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.data != nil) {
            item.data.content = content;
            if (moment.comments.count == 0) {
                NSMutableArray<ClassMomentListRequestItem_Data_Moment_Comment> *mutableArray = [[NSMutableArray<ClassMomentListRequestItem_Data_Moment_Comment> alloc] init];
                [mutableArray addObject:item.data];
                moment.comments = mutableArray;
            }else {
                [moment.comments addObject:item.data];
            }
            moment.draftModel = nil;
            self.comInputView.textString = nil;
            [self.tableView reloadData];
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.commentRequest = request;
}
- (void)requestForDiscardMoment:(NSInteger)section {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[section];
    ClassMomentDiscardRequest *request = [[ClassMomentDiscardRequest alloc] init];
    request.momentId = moment.momentID;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.code.integerValue == 0) {
            if (self.dataArray.count > section) {
                [self.dataArray removeObjectAtIndex:section];
                [self.tableView reloadData];
                self.emptyView.hidden = self.dataArray.count == 0 ? NO : YES;
            }
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.discardRequest = request;
}


- (void)requstForReplyComment:(NSString *)content {
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[self.replyIndexPath.section];
    ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[self.replyIndexPath.row];
    ClassMomentReplyRequest *request = [[ClassMomentReplyRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    request.momentId = moment.momentID;
    request.content = content;
    request.toUserId = comment.userID;
    request.commentId = moment.momentID;
    //    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ClassMomentReplyItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        ClassMomentReplyItem *item = retItem;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.data != nil) {
            item.data.content = content;
            if (moment.comments.count == 0) {
                NSMutableArray<ClassMomentListRequestItem_Data_Moment_Comment> *mutableArray = [[NSMutableArray<ClassMomentListRequestItem_Data_Moment_Comment> alloc] init];
                [mutableArray addObject:item.data];
                moment.comments = mutableArray;
            }else {
                [moment.comments addObject:item.data];
            }
            comment.draftModel = nil;
            self.comInputView.textString = nil;
            [self.tableView reloadData];
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.replyRequest = request;
}

- (void)requestForDiscardComment:(NSIndexPath *)indexPath{
    ClassMomentListRequestItem_Data_Moment *moment = self.dataArray[indexPath.section];
    ClassMomentListRequestItem_Data_Moment_Comment *comment = moment.comments[indexPath.row];
    ClassMomentDiscardCommentRequest *request = [[ClassMomentDiscardCommentRequest alloc] init];
    request.commentId = comment.commentID;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.code.integerValue == 0) {
            if (moment.comments.count > indexPath.row) {
                [moment.comments removeObjectAtIndex:indexPath.row];
            }
            [self.tableView reloadData];
        }else {
            [self.view nyx_showToast:item.message];
        }
    }];
    self.discardCommentRequest = request;
}
@end
