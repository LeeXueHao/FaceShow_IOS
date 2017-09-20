//
//  UserInfoViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "UserInfoHeaderCell.h"
#import "UserInfoDefaultCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXImagePickerController.h"
#import "UserModel.h"
@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentMutableArray;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) UserInfoRequest *userInfoRequest;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.contentMutableArray =
    [@[@{@"title":@"姓名",@"content": [UserManager sharedInstance].userModel.realName?:@"暂无"},
       @{@"title":@"联系电话",@"content":[UserManager sharedInstance].userModel.mobilePhone?:@"暂无"},
       @{@"title":@"性别",@"content":[UserManager sharedInstance].userModel.sex?:@"暂无"},
       @{@"title":@"学段",@"content":[UserManager sharedInstance].userModel.stage?:@"暂无"},
       @{@"title":@"学科",@"content":[UserManager sharedInstance].userModel.subject?:@"暂无"}] mutableCopy];
    [self setupUI];
    [self setupLayout];
    if ([UserManager sharedInstance].userModel == nil) {
        [self requestForUserInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - get
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.tableView registerClass:[UserInfoHeaderCell class] forCellReuseIdentifier:@"UserInfoHeaderCell"];
    [self.tableView registerClass:[UserInfoDefaultCell class] forCellReuseIdentifier:@"UserInfoDefaultCell"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
}
- (void)setupLayout {
    //containerView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
    }];
    [alertVC addAction:cancleAction];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self requestForUpdateHeaderImage:selectedImage];
        }];
    }];
    [alertVC addAction:cameraAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self requestForUpdateHeaderImage:selectedImage];
        }];
    }];
    [alertVC addAction:photoAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75.5f;
    }else{
        return 45.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self showAlertView];
    }
}

#pragma mark - UITableViewDataScource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentMutableArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeaderCell" forIndexPath:indexPath];
        [cell reload];
        return cell;
    }else {
        UserInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDefaultCell" forIndexPath:indexPath];
        cell.contenDictionary = self.contentMutableArray[indexPath.section - 1];
        return cell;
    }
}
#pragma mark - request
- (void)requestForUpdateHeaderImage:(UIImage *)image {
    UserInfoHeaderCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell reload];
    BLOCK_EXEC(self.userInfoReloadBlock);
}
#pragma mark - request
- (void)requestForUserInfo{
    UserInfoRequest *request = [[UserInfoRequest alloc] init];
    //    request.userId = @"";
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[UserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        UserInfoRequestItem *item = retItem;
        if (item.data != nil) {
            [UserManager sharedInstance].userModel = [UserModel modelFromRawData:item.data];
            self.contentMutableArray = [@[@{@"title":@"姓名",@"content":@"孙长龙"},
                                          @{@"title":@"联系电话",@"content":@"13910102038"},
                                          @{@"title":@"性别",@"content":@"男"},
                                          @{@"title":@"学段",@"content":@"高中"},
                                          @{@"title":@"学科",@"content":@"数学"}] mutableCopy];
            
            self.contentMutableArray[0][@"content"] = [UserManager sharedInstance].userModel.realName?:@"暂无";
            self.contentMutableArray[1][@"content"] = [UserManager sharedInstance].userModel.mobilePhone?:@"暂无";
            self.contentMutableArray[2][@"content"] = [UserManager sharedInstance].userModel.sex?:@"暂无";
            self.contentMutableArray[3][@"content"] = [UserManager sharedInstance].userModel.stage?:@"暂无";
            self.contentMutableArray[4][@"content"] = [UserManager sharedInstance].userModel.subject?:@"暂无";
            [self.tableView reloadData];
        }
    }];
    self.userInfoRequest = request;
}
@end
