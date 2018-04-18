//
//  ChatListViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "ChatListCell.h"
#import "IMManager.h"
#import "IMUserInterface.h"
#import "ChatViewController.h"
#import "IMTimeHandleManger.h"
#import "YXDrawerController.h"

@interface ChatListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<IMTopic *> *dataArray;
@property (nonatomic, strong) IMTopic *chattingTopic;
@property (nonatomic, assign) NSInteger privateTopicIndex;
@end

@implementation ChatListViewController

- (void)setUnreadPromptView:(UIView *)unreadPromptView {
    _unreadPromptView = unreadPromptView;
    // 用于激活红点逻辑
    UIView *v = self.view;
    v = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊聊";
    [self setupNavView];
    [self setupUI];
    [self setupData];
    [self updateUnreadPromptView];
    [self setupObserver];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavView {
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self nyx_setupRightWithTitle:@"通讯录" action:^{
        STRONG_SELF
        ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
        [self.navigationController pushViewController:contactsVC animated:YES];
        [TalkingData trackEvent:@"通讯录"];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setupData {
    self.dataArray = [NSMutableArray arrayWithArray:[IMUserInterface findAllTopics]];
    self.privateTopicIndex = 0;
    for (IMTopic *topic in self.dataArray) {
        if (topic.type == TopicType_Group) {
            self.privateTopicIndex++;
        }else {
            break;
        }
    }
}

- (void)updateUnreadPromptView {
    BOOL hasUnread = NO;
    for (IMTopic *topic in self.dataArray) {
        if (topic.unreadCount > 0) {
            hasUnread = YES;
            break;
        }
    }
    self.unreadPromptView.hidden = !hasUnread;
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMMessageDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopicMessage *message = noti.object;
        for (IMTopic *item in self.dataArray) {
            if (item.topicID == message.topicID) {
                NSUInteger index = [self.dataArray indexOfObject:item];
                IMTopic *topic = self.dataArray[index];
                BOOL isSameMsg = [message.uniqueID isEqualToString:topic.latestMessage.uniqueID];
                topic.latestMessage = message;
                [self.dataArray replaceObjectAtIndex:index withObject:topic];
                if (isSameMsg) {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }else {
                    if ((index==self.privateTopicIndex && topic.type==TopicType_Private)
                        || (index==0 && topic.type==TopicType_Group)) {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }else {
                        NSInteger targetIndex = topic.type==TopicType_Group? 0:self.privateTopicIndex;
                        [self.dataArray removeObjectAtIndex:index];
                        [self.dataArray insertObject:topic atIndex:targetIndex];
                        [self.tableView reloadData];
                    }
                }
                return;
            }
        }
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMTopicDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopic *topic = noti.object;
        if (topic.members.count == 0) {
            return;
        }
        for (IMTopic *item in self.dataArray) {
            if ([IMUserInterface isSameTopicWithOneTopic:item anotherTopic:topic]) {
                NSUInteger index = [self.dataArray indexOfObject:item];
                [self.dataArray replaceObjectAtIndex:index withObject:topic];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
        }
        
        NSInteger targetIndex = topic.type==TopicType_Group? 0:self.privateTopicIndex;
        [self.dataArray insertObject:topic atIndex:targetIndex];
        [self.tableView reloadData];
        if (topic.type == TopicType_Group) {
            self.privateTopicIndex++;
        }
        [self updateUnreadPromptView];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMUnreadMessageCountDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        int64_t topicID = ((NSNumber *)[noti.userInfo valueForKey:kIMUnreadMessageCountTopicKey]).longLongValue;
        int64_t count = ((NSNumber *)[noti.userInfo valueForKey:kIMUnreadMessageCountKey]).longLongValue;
        for (IMTopic *item in self.dataArray) {
            if (item.topicID == topicID) {
                item.unreadCount = count;
                NSUInteger index = [self.dataArray indexOfObject:item];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [self updateUnreadPromptView];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMTopicInfoUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopic *topic = noti.object;
        for (IMTopic *item in self.dataArray) {
            if ([IMUserInterface isSameTopicWithOneTopic:item anotherTopic:topic]) {
                NSUInteger index = [self.dataArray indexOfObject:item];
                item.group = topic.group;
                item.members = topic.members;
                [topic.members enumerateObjectsUsingBlock:^(IMMember * _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
                    IMMember *sender = item.latestMessage.sender;
                    if (sender.memberID == member.memberID) {
                        item.latestMessage.sender = member;
                    }
                }];
                [self.dataArray replaceObjectAtIndex:index withObject:item];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMHistoryMessageDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        int64_t topicID = ((NSNumber *)[noti.userInfo valueForKey:kIMHistoryMessageTopicKey]).longLongValue;
        NSArray *array = [noti.userInfo valueForKey:kIMHistoryMessageKey];
        NSError *error = [noti.userInfo valueForKey:kIMHistoryMessageErrorKey];
        if (error || array.count==0) {
            return;
        }
        for (IMTopic *item in self.dataArray) {
            if (item.topicID == topicID) {
                if (!item.latestMessage) {
                    item.latestMessage = array.firstObject;
                    NSUInteger index = [self.dataArray indexOfObject:item];
                    if ((index==self.privateTopicIndex && item.type==TopicType_Private)
                        || (index==0 && item.type==TopicType_Group)) {
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }else {
                        IMTopic *topic = item;
                        NSInteger targetIndex = item.type==TopicType_Group? 0:self.privateTopicIndex;
                        [self.dataArray removeObjectAtIndex:index];
                        [self.dataArray insertObject:topic atIndex:targetIndex];
                        [self.tableView reloadData];
                    }
                }
                break;
            }
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMUnreadMessageCountClearNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopic *topic = noti.object;
        [self clearChattingTopicUnreadCount:topic];
    }];
}

- (void)clearChattingTopicUnreadCount:(IMTopic *)topic {
    [IMUserInterface resetUnreadMessageCountWithTopicID:topic.topicID];
    for (IMTopic *item in self.dataArray) {
        if (item.topicID == topic.topicID) {
            item.unreadCount = 0;
            NSInteger index = [self.dataArray indexOfObject:item];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [self updateUnreadPromptView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListCell *cell = [[ChatListCell alloc]init]; //[tableView dequeueReusableCellWithIdentifier:@"ChatListCell" forIndexPath:indexPath];
    cell.topic = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IMTopic *topic = self.dataArray[indexPath.row];
    self.chattingTopic = topic;
    [IMUserInterface updateTopicInfoWithTopicID:topic.topicID];//更新话题的名称 成员信息等
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.topic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
    if (topic.type == TopicType_Group) {
        [TalkingData trackEvent:@"点击班级群聊"];
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        IMTopic *topic = self.dataArray[indexPath.row];
////        if (topic.type == TopicType_Group) {//群聊不可删除
////            return;
////        }
//        //删除聊天
////        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        DDLogDebug(@"删除");
//    }
//}

@end
