//
//  CourseCommentViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentViewController.h"
#import "CourseCommentCell.h"
#import "CourseCommentTitleView.h"
#import "CourseCommentHeaderView.h"
#import "CommentInputView.h"

@interface CourseCommentViewController ()
@property (nonatomic, strong) CommentInputView *inputView;
@end

@implementation CourseCommentViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"课程讨论";
    [self setupUI];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)firstPageFetch{
    [self.view nyx_stopLoading];
}

- (void)setupUI {
    NSString *title = @"这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题222";
    CGFloat height = [CourseCommentTitleView heightForTitle:title];
    CourseCommentTitleView *headerView = [[CourseCommentTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    headerView.title = title;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = headerView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.tableView registerClass:[CourseCommentCell class] forCellReuseIdentifier:@"CourseCommentCell"];
    [self.tableView registerClass:[CourseCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"CourseCommentHeaderView"];
    
    self.inputView = [[CommentInputView alloc]init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
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
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y+self.inputView.height, 0);
            
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-([UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y));
            }];
            [self.view layoutIfNeeded];
        }];
    }];
}

- (void)favorCommentWithIndex:(NSInteger)index {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCommentCell"];
    cell.bottomLineHidden = indexPath.row==9;
    WEAK_SELF
    [cell setFavorBlock:^{
        STRONG_SELF
        [self favorCommentWithIndex:indexPath.row];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseCommentHeaderView"];
    header.countStr = @"45";
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end
