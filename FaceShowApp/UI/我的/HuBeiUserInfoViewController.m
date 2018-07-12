//
//  HuBeiUserInfoViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HuBeiUserInfoViewController.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "UserInfoHeaderCell.h"
#import "UserInfoDefaultCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXImagePickerController.h"
#import "UserModel.h"
#import "UploadHeadImgRequest.h"
#import "UpdateAvatarRequest.h"
#import "UpdateUserInfoRequest.h"
#import "ModifySexViewController.h"
#import "ModifyNameViewController.h"
#import "StageSubjectViewController.h"
#import "HeadImageHandler.h"
#import "ModifySchoolViewController.h"
#import "QiniuDataManager.h"
#import "AreaSubjectViewController.h"
#import "UserInfoNameModel.h"
#import "UpdateTextInfoViewController.h"
@interface HuBeiUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) HeadImageHandler *imageHandler;

@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;
@property (nonatomic, strong) UploadHeadImgRequest *uploadHeadImgRequest;
@property (nonatomic, strong) UpdateAvatarRequest *avatarRequest;
@property (nonatomic, strong) UpdateUserInfoRequest *updateUserInfoRequest;
@end

@implementation HuBeiUserInfoViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.imageHandler = [[HeadImageHandler alloc]init];
    //头像-0姓名-1手机号-2性别-3学段学科-4省市区-5学校-6身份证号-7子项目编号-8子项目名称-9承训单位-10学校所在区域-11学校类别-12民族-13职称-14职务(非必填)-15最高学历-16毕业院校-17所学专业-18电话(非必填)-19电子邮件(非必填)
    [self setupUI];
    [self setupLayout];
    [self requestForUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stageSubjectString {
    if (isEmpty([UserManager sharedInstance].userModel.stageName) || isEmpty([UserManager sharedInstance].userModel.subjectName)) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@", [UserManager sharedInstance].userModel.stageName, [UserManager sharedInstance].userModel.subjectName];
}
- (NSString *)areaSubjectString {
    NSString *areaString = [UserManager sharedInstance].userModel.aui.provinceName;
    if (!isEmpty([UserManager sharedInstance].userModel.aui.cityName)) {
        areaString = [areaString stringByAppendingString:[NSString stringWithFormat:@"-%@",[UserManager sharedInstance].userModel.aui.cityName]];
    }
    if (!isEmpty([UserManager sharedInstance].userModel.aui.countryName)) {
           areaString = [areaString stringByAppendingString:[NSString stringWithFormat:@"-%@",[UserManager sharedInstance].userModel.aui.countryName]];
    }
    if (isEmpty(areaString)) {
        return nil;
    }
    return areaString;
}

#pragma  mark - get
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
        _imagePickerController.canEdit = YES;
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
        [self pickImageFromCamera];
        //        [self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVC addAction:cameraAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVC addAction:photoAction];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alertVC.popoverPresentationController.sourceView = self.view;
        alertVC.popoverPresentationController.sourceRect = CGRectMake(200,100,200,200);
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    WEAK_SELF
    [self.imagePickerController pickImageWithSourceType:sourceType completion:^(UIImage *selectedImage) {
        STRONG_SELF
        [self updateWithHeaderImage:selectedImage];
    }];
}
- (void)pickImageFromCamera {
    WEAK_SELF
    [self.imageHandler pickImageFromCameraWithCompleteBlock:^(UIImage *image) {
        STRONG_SELF
        [self updateWithHeaderImage:image];
    }];
}
- (void)showUpdateSexAlertViewWithIndex:(NSIndexPath *)index{
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"男"}, @{@"title":@"女"}];
    self.alertView = [[AlertView alloc] init];
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
                make.height.mas_offset(155.0f);
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
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.mas_equalTo(0);
                    }
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if ([UserManager sharedInstance].userModel.sexID.integerValue == integer%2) {
            [self.alertView hide];
            return;
        }
        [self updateUserInfoWithSexID:integer%2 sexIndex:index];
    };
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
    switch (indexPath.section) {
        case 0:
        {
            [self showAlertView];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [self showUpdateSexAlertViewWithIndex:indexPath];
        }
            break;
        case 4:
        {
            [TalkingData trackEvent:@"点击修改学段学科"];
            StageSubjectViewController *vc = [[StageSubjectViewController alloc] init];
            vc.selectedStageSubjectString = [self stageSubjectString];
            WEAK_SELF
            vc.completeBlock = ^{
                STRONG_SELF
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            [TalkingData trackEvent:@"点击修改省市区"];
            AreaSubjectViewController *vc = [[AreaSubjectViewController alloc] init];
            vc.dataArray = [AreaManager sharedInstance].areaModel.data;
            AreaSubjectItem *province = [[AreaSubjectItem alloc] init];
            province.chooseId = [UserManager sharedInstance].userModel.aui.province;
            province.chooseName = [UserManager sharedInstance].userModel.aui.provinceName;
            vc.provinceItem = province;
            AreaSubjectItem *city = [[AreaSubjectItem alloc] init];
            city.chooseId = [UserManager sharedInstance].userModel.aui.city;
            city.chooseName = [UserManager sharedInstance].userModel.aui.cityName;
            vc.cityItem = city;
            AreaSubjectItem *country = [[AreaSubjectItem alloc] init];
            country.chooseId = [UserManager sharedInstance].userModel.aui.country;
            country.chooseName = [UserManager sharedInstance].userModel.aui.countryName;
            vc.countryItem = country;
            vc.status = AreaSubject_Province;
            WEAK_SELF
            vc.completeBlock = ^{
                STRONG_SELF
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            UpdateTextInfoViewController *vc = [[UpdateTextInfoViewController alloc] init];
            vc.infoType = indexPath.section - 1;
            WEAK_SELF
            [vc setCompleteBlock:^{
                STRONG_SELF
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                BLOCK_EXEC(self.completeBlock);
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

#pragma mark - UITableViewDataScource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 21;
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
        if (indexPath.section == 1) {
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.realName)?[UserManager sharedInstance].userModel.realName:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 2){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.mobilePhone)?[UserManager sharedInstance].userModel.mobilePhone:@"暂无"};
        }else if (indexPath.section == 3){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.sexName)?[UserManager sharedInstance].userModel.sexName:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 4){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": [self stageSubjectString]?:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 5){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": [self areaSubjectString]?:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 6){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.school)?[UserManager sharedInstance].userModel.school:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 7){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.idCard)?[UserManager sharedInstance].userModel.aui.idCard:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 8){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.childProjectId)?[UserManager sharedInstance].userModel.aui.childProjectId:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 9){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.childProjectName)?[UserManager sharedInstance].userModel.aui.childProjectName:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 10){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.organizer)?[UserManager sharedInstance].userModel.aui.organizer:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 11){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.area)?[UserManager sharedInstance].userModel.aui.area:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 12){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.schoolType)?[UserManager sharedInstance].userModel.aui.schoolType:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 13){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content":!isEmpty([UserManager sharedInstance].userModel.aui.nation)?[UserManager sharedInstance].userModel.aui.nation:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 14){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.title)?[UserManager sharedInstance].userModel.aui.title:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 15){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.job)?[UserManager sharedInstance].userModel.aui.job:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 16){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.recordeducation)?[UserManager sharedInstance].userModel.aui.recordeducation:@"暂无",@"next":@(YES)};
        }else if (indexPath.section == 17){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.graduation)?[UserManager sharedInstance].userModel.aui.graduation:@"暂无",@"next":@(YES)};
        }
        else if (indexPath.section == 18){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.professional)?[UserManager sharedInstance].userModel.aui.professional:@"暂无",@"next":@(YES)};
        }
        else if (indexPath.section == 19){
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.aui.telephone)?[UserManager sharedInstance].userModel.aui.telephone:@"暂无",@"next":@(YES)};
        }
        else {
            cell.contenDictionary = @{@"title": [UserInfoNameModel userInfoName:indexPath.section - 1], @"content": !isEmpty([UserManager sharedInstance].userModel.email)?[UserManager sharedInstance].userModel.email:@"暂无",@"next":@(YES)};
        }
        
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
            [[UserManager sharedInstance] saveData];
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
    [self.view nyx_startLoading];
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:nil completeBlock:^(NSString *key,NSString *host, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"上传失败请重试"];
            return;
        }
        [self requestForUploadAvatar:[NSString stringWithFormat:@"%@/%@",host,key]];
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
- (void)updateUserInfoWithSexID:(NSInteger)sexID sexIndex:(NSIndexPath *)index {
    [self.updateUserInfoRequest stopRequest];
    self.updateUserInfoRequest = [[UpdateUserInfoRequest alloc]init];
    self.updateUserInfoRequest.sex = [NSString stringWithFormat:@"%@", @(sexID)];
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.updateUserInfoRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.sexName = sexID ? @"男" : @"女";
        [UserManager sharedInstance].userModel.sexID = [NSString stringWithFormat:@"%@", @(sexID)];
        [[UserManager sharedInstance]saveData];
        [self.alertView hide];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

@end
