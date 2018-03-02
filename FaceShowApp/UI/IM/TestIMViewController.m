//
//  TestIMViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TestIMViewController.h"
#import "IMMessageCell.h"
#import "IMManager.h"
#import "IMConnectionManager.h"
#import "IMUserInterface.h"

@interface TestIMViewController ()<UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<IMTopicMessage *> *dataArray;
@end

@implementation TestIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [IMUserInterface findMessagesInTopic:16 count:100 asending:NO completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
//        self.dataArray = [NSMutableArray arrayWithArray:array];
//    }];
    self.dataArray = [NSMutableArray array];
    [self setupUI];
    [self setupObserver];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kIMMessageDidUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopicMessage *message = noti.object;
        if (message.topicID != 16) {
            return;
        }
        for (IMTopicMessage *item in self.dataArray) {
            if ([item.uniqueID isEqualToString:message.uniqueID]) {
                NSUInteger index = [self.dataArray indexOfObject:item];
                [self.dataArray replaceObjectAtIndex:index withObject:message];
                [self.tableView reloadData];
                return;
            }
        }
        [self.dataArray addObject:message];
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    UITextField *tf = [[UITextField alloc]init];
    self.textField = tf;
    tf.returnKeyType = UIReturnKeyDone;
    tf.layer.borderColor = [UIColor redColor].CGColor;
    tf.borderStyle = UITextBorderStyleLine;
    tf.placeholder = @"请输入";
    tf.delegate = self;
    [self.view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(40);
    }];
    UIButton *sendButton = [[UIButton alloc]init];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sendButton.layer.borderColor = [UIColor redColor].CGColor;
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(60);
    }];
    [self.tableView registerClass:[IMMessageCell class] forCellReuseIdentifier:@"IMMessageCell"];
}

- (void)sendAction {
    [IMUserInterface sendTextMessageWithText:self.textField.text topicID:16];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMMessageCell"];
    cell.message = self.dataArray[indexPath.row];
    return cell;
}

@end
