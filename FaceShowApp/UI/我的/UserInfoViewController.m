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
#import "UploadHeadImgRequest.h"
#import "UpdateAvatarRequest.h"
@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentMutableArray;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;
@property (nonatomic, strong) UploadHeadImgRequest *uploadHeadImgRequest;
@property (nonatomic, strong) UpdateAvatarRequest *avatarRequest;
@end

@implementation UserInfoViewController
- (void)dealloc {
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    self.contentMutableArray =
    [@[[@{@"title":@"姓名",@"content": [UserManager sharedInstance].userModel.realName?:@"暂无"} mutableCopy],
       [@{@"title":@"联系电话",@"content":[UserManager sharedInstance].userModel.mobilePhone?:@"暂无"} mutableCopy],
       [@{@"title":@"性别",@"content":[UserManager sharedInstance].userModel.sexName?:@"暂无"} mutableCopy],
       [@{@"title":@"学段",@"content":[UserManager sharedInstance].userModel.stageName?:@"暂无"} mutableCopy],
       [@{@"title":@"学科",@"content":[UserManager sharedInstance].userModel.subjectName?:@"暂无"} mutableCopy]] mutableCopy];
    [self setupUI];
    [self setupLayout];
    [self requestForUserInfo];
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
        [self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVC addAction:cameraAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVC addAction:photoAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    WEAK_SELF
    [self.imagePickerController pickImageWithSourceType:sourceType completion:^(UIImage *selectedImage) {
        STRONG_SELF
        [self updateWithHeaderImage:selectedImage];
    }];
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
    return section == 0 ? 5.0f : 0.00001f;
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
- (void)requestForUserInfo{
   GetUserInfoRequest *request = [[GetUserInfoRequest alloc] init];
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        GetUserInfoRequestItem *item = retItem;
        if (item.data != nil) {
            [[UserManager sharedInstance].userModel updateFromUserInfo:item.data];
            self.contentMutableArray[0][@"content"] = [UserManager sharedInstance].userModel.realName?:@"暂无";
            self.contentMutableArray[1][@"content"] = [UserManager sharedInstance].userModel.mobilePhone?:@"暂无";
            self.contentMutableArray[2][@"content"] = [UserManager sharedInstance].userModel.sexName?:@"暂无";
            self.contentMutableArray[3][@"content"] = [UserManager sharedInstance].userModel.stageName?:@"暂无";
            self.contentMutableArray[4][@"content"] = [UserManager sharedInstance].userModel.subjectName?:@"暂无";
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kYXUploadUserPicSuccessNotification" object:nil];
        }
    }];
    self.userInfoRequest = request;
}
- (void)updateWithHeaderImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    NSData *data = [UIImage compressionImage:image limitSize:2*1024*1024];
    [self.uploadHeadImgRequest stopRequest];
    self.uploadHeadImgRequest = [[UploadHeadImgRequest alloc] init];
    [self.uploadHeadImgRequest.request setData:data
                                  withFileName:@"head.jpg"
                                andContentType:nil
                                        forKey:@"easyfile"];
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.uploadHeadImgRequest startRequestWithRetClass:[UploadHeadImgItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        UploadHeadImgItem *item = retItem;
        if (error) {
            [self.view nyx_stopLoading];

            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.tplData.data.count != 0) {
            UploadHeadImgItem_TplData_Data *data = item.tplData.data[0];
            [self requestForUploadAvatar:data.url?:data.shortUrl];
        } else {
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:item.tplData.message];
        }
    }];
}
- (void)requestForUploadAvatar:(NSString *)url {
    UpdateAvatarRequest *request = [[UpdateAvatarRequest alloc] init];
    request.avatar = url;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (!error) {
            [UserManager sharedInstance].userModel.avatarUrl = url;
            [[UserManager sharedInstance] saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kYXUploadUserPicSuccessNotification" object:nil];
        }
    }];
    self.avatarRequest = request;
}

@end
