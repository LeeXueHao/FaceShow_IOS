//
//  ChatViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChatViewController.h"
#import "IMTopicMessage.h"
#import "IMManager.h"
#import "IMConnectionManager.h"
#import "IMUserInterface.h"
#import "IMRequestManager.h"
#import "IMMessageBaseCell.h"
#import "IMTextMessageBaseCell.h"
#import "IMMessageCellFactory.h"
#import "IMInputView.h"
#import "IMMessageCellDelegate.h"
#import "IMMessageMenuView.h"
#import "IMMessageTableView.h"
#import "IMTimeHandleManger.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,IMMessageCellDelegate>
@property (assign,nonatomic) BOOL isFirst;
@property (nonatomic, strong) IMMessageTableView *tableView;
@property (nonatomic, strong) NSMutableArray<IMTopicMessage *> *dataArray;
@property (nonatomic, strong) IMInputView *imInputView;
@property (nonatomic, strong) IMMessageMenuView *menuView;

@property (assign,nonatomic)BOOL hasMore;
@property (strong,nonatomic)UIActivityIndicatorView *activity;
@end

@implementation ChatViewController

- (void)dealloc {
    [self.menuView dismiss];
    [IMUserInterface clearDirtyMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.topic) {
        if (self.topic.type == TopicType_Group) {
            self.title = [NSString stringWithFormat:@"%@(%@)",self.topic.name,@(self.topic.members.count)];
        }else {
            self.title = self.topic.name;
        }
    }else {
        self.title = self.member.name;
    }
    [self setupUI];
    [self setupData];
    [self setupObserver];
    self.isFirst = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self scrollToBottom];
//}

- (void)setupUI {
    self.imInputView = [[IMInputView alloc]init];
    WEAK_SELF
    [self.imInputView setCompleteBlock:^(NSString *text){
        STRONG_SELF
        if (self.topic) {
            [IMUserInterface sendTextMessageWithText:text topicID:16];
        }else {
            [IMUserInterface sendTextMessageWithText:text toMember:self.member];
        }
        self.imInputView.textView.text = nil;
    }];
    [self.imInputView setCameraButtonClickBlock:^{
        STRONG_SELF
    }];
    [self.view addSubview:self.imInputView];
    [self.imInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50.f);
    }];
    
    self.tableView = [[IMMessageTableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe3e5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[IMMessageBaseCell class] forCellReuseIdentifier:@"IMMessageBaseCell"];
    [self.tableView registerClass:[IMTextMessageBaseCell class] forCellReuseIdentifier:@"IMTextMessageBaseCell"];
    [self.tableView registerClass:[IMTextMessageLeftCell class] forCellReuseIdentifier:@"IMTextMessageLeftCell"];
    [self.tableView registerClass:[IMTextMessageRightCell class] forCellReuseIdentifier:@"IMTextMessageRightCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.equalTo(self.imInputView.mas_top);
    }];
    
    self.automaticallyAdjustsScrollViewInsets = false;  //第一个cell和顶部有留白，scrollerview遗留下来的，用来取消它
    //刷新控件
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(headerView.frame.size.width/2, 0, 20, 20);;
    [headerView addSubview:self.activity];
    self.tableView.tableHeaderView = headerView;
    headerView.hidden = YES;
}

- (void)setupData {
    WEAK_SELF
    [IMUserInterface findMessagesInTopic:self.topic.topicID count:100 asending:NO completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
        STRONG_SELF
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [self handelTimeForDataSource:self.dataArray];
        self.hasMore = hasMore;
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMMessageDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopicMessage *message = noti.object;
        for (IMTopicMessage *item in self.dataArray) {
            if ([item.uniqueID isEqualToString:message.uniqueID]) {
                NSUInteger index = [self.dataArray indexOfObject:item];
                [self.dataArray replaceObjectAtIndex:index withObject:message];
                [self handelTimeForDataSource:self.dataArray];
                [self.tableView reloadData];
                return;
            }
        }
        [self.dataArray addObject:message];
        [self handelTimeForDataSource:self.dataArray];
        [self.tableView reloadData];
        [self scrollToBottom];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.imInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-([UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y));
                make.height.mas_equalTo(50);
            }];
            [self.view layoutIfNeeded];
        }];
        [self scrollToBottom];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMTopicDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.topic) {
            return;
        }
        NSNotification *noti = (NSNotification *)x;
        IMTopic *topic = noti.object;
        if (topic.type == TopicType_Private) {
            for (IMMember *item in topic.members) {
#warning self.member需要看结构是什么
                if (self.member.memberID) {
                    if (item.memberID == self.member.memberID) {
                        self.topic = topic;
                        return;
                    }
                }
                if (item.userID == self.member.userID) {
                    self.topic = topic;
                    return;
                }
            }
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFirst) {
        self.isFirst = NO;
        [self scrollToBottom];
    }
    IMMessageBaseCell *cell = [IMMessageCellFactory cellWithMessage:self.dataArray[indexPath.row]];
    cell.message = self.dataArray[indexPath.row];
    cell.topicType = self.topic.type;
    cell.delegate = self;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.imInputView endEditing:YES];
    [self.imInputView resignFirstResponder];
}

- (void)scrollToBottom {
    if (self.dataArray.count >= 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - loadMoreHistoryData
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0  && self.hasMore) {
        [self loadMoreHistoryData];
    }
}

- (void)loadMoreHistoryData {
    WEAK_SELF
    self.tableView.tableHeaderView.hidden = NO;
    [self.activity startAnimating];
    [IMUserInterface findMessagesInTopic:self.topic.topicID count:15 beforeIndex:self.dataArray.firstObject.index completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
        STRONG_SELF
        self.hasMore = hasMore;
        if (array.count > 0) {
            for (NSInteger i = 0; i < array.count; i ++) {
                [self.dataArray insertObject:array[i] atIndex:0];
            }
            [self handelTimeForDataSource:self.dataArray];
            [self.tableView reloadData];
            [self.activity stopAnimating];
            self.tableView.tableHeaderView.hidden = YES;
        }
    }];
}

#pragma mark - IMMessageCellDelegate
- (void)messageCellDidClickAvatarForUser:(IMMember *)user {
    [self.view nyx_showToast:@"click avatar to do ..."];
}

- (void)messageCellTap:(IMTopicMessage *)message {
    [self.view nyx_showToast:@"click image to do ..."];
}

- (void)messageCellLongPress:(IMTopicMessage *)message rect:(CGRect)rect {
    DDLogDebug(@"long press to do ...");
    
    NSInteger row = [self.dataArray indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    
    WEAK_SELF
    [self.menuView setMenuItemActionBlock:^(IMMessageMenuItemType type) {
        STRONG_SELF
        if (type == IMMessageMenuItemType_Copy) {
            NSString *str = message.text;
            [[UIPasteboard generalPasteboard] setString:str];
        }
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    IMMessageMenuItemModel *model0 = [[IMMessageMenuItemModel alloc]init];
    model0.title = @"复制";
    model0.type = IMMessageMenuItemType_Copy;
    [array addObject:model0];
    
    IMMessageMenuItemModel *model1 = [[IMMessageMenuItemModel alloc]init];
    model1.title = @"删除";
    model1.type = IMMessageMenuItemType_Delete;
    [array addObject:model1];
    
    IMMessageMenuItemModel *model2 = [[IMMessageMenuItemModel alloc]init];
    model2.title = @"取消";
    model2.type = IMMessageMenuItemType_Cancel;
    [array addObject:model2];
    
    [self.menuView addMenuItemModels:array.copy];
    
    [self.menuView showInView:self.tableView  withRect:rect];
}

- (void)messageCellDoubleClick:(IMTopicMessage *)message {
    [self.view nyx_showToast:@"double click to do ..."];
}

- (void)messageCellDidClickStateButton:(IMTopicMessage *)message rect:(CGRect)rect {
    DDLogDebug(@"click state button to do ...");
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
    NSInteger row = [self.dataArray indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    
    WEAK_SELF
    [self.menuView setMenuItemActionBlock:^(IMMessageMenuItemType type) {
        STRONG_SELF
        if (type == IMMessageMenuItemType_Resend) {
            if ([self.dataArray containsObject:message]) {
                NSUInteger index = [self.dataArray indexOfObject:message];
                [self.dataArray removeObjectAtIndex:index];
                [self.dataArray addObject:message];
                [self handelTimeForDataSource:self.dataArray];
                [self.tableView reloadData];
            }
            [IMUserInterface sendTextMessageWithText:message.text topicID:self.topic.topicID uniqueID:message.uniqueID];
        }
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    IMMessageMenuItemModel *model0 = [[IMMessageMenuItemModel alloc]init];
    model0.title = @"重试";
    model0.type = IMMessageMenuItemType_Resend;
    [array addObject:model0];
    
    IMMessageMenuItemModel *model1 = [[IMMessageMenuItemModel alloc]init];
    model1.title = @"取消";
    model1.type = IMMessageMenuItemType_Delete;
    [array addObject:model1];
    
    [self.menuView addMenuItemModels:array.copy];
    
    [self.menuView showInView:self.tableView  withRect:rect];
}

- (IMMessageMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[IMMessageMenuView alloc] init];
    }
    return _menuView;
}

#pragma mark - 时间显示相关
- (void)handelTimeForDataSource:(NSMutableArray *)dataArray {
    IMTopicMessage *msg;
    NSTimeInterval lastVisibleTime = 0.0;
    for (int i=0; i<dataArray.count; i++) {
        msg = [dataArray objectAtIndex:i];
        if (i == 0) {
            msg.isTimeVisible = YES;
            lastVisibleTime = msg.sendTime;
        }else {
            int timeSpan=(int)[IMTimeHandleManger compareTime1:lastVisibleTime withTime2:msg.sendTime type:IMTimeType_Minute];
            if (timeSpan >= 5) {
                msg.isTimeVisible = YES;
                lastVisibleTime = msg.sendTime;
            }else if (timeSpan < 0) {
                msg.isTimeVisible = YES;
                lastVisibleTime = msg.sendTime;
            }else {
                msg.isTimeVisible = NO;
            }
        }
        dataArray[i] = msg;
    }
}

@end
