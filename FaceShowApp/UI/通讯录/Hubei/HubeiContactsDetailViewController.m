//
//  HubeiContactsDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiContactsDetailViewController.h"
#import "ErrorView.h"
#import "GetUserInfoDetailRequest.h"
#import "DetailCellView.h"
#import "AreaManager.h"
#import "GetMemberIdRequest.h"
#import "ChatViewController.h"
#import "IMUserInterface.h"
#import "IMTopicInfoItem.h"
#import "ClassListRequest.h"

@interface HubeiContactsDetailViewController ()
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) MASViewAttribute *lastBottom;
@property (nonatomic, strong) DetailCellView *percentCell;

@property (nonatomic, strong) GetUserInfoDetailRequest *userInfoRequest;
@property (nonatomic, strong) GetUserInfoDetailRequestItem_Data *data;
@property (nonatomic, strong) GetMemberIdRequest *memberIdRequest;
@property (nonatomic, strong) GetMemberIdRequestItem_data *memberData;
@property (nonatomic, strong) ClassListRequest *getClassRequest;
@property (nonatomic, strong) NSArray<ClassListRequestItem_clazsInfos *> *allClassInfo;
@property (nonatomic, strong) UIButton *sendMessageBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation HubeiContactsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资料详情";

    self.errorView = [[ErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestUserInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;

    [self requestUserInfo];

    [self requestMemberIdAndComplete:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestUserInfo {
    [self.userInfoRequest stopRequest];
    self.userInfoRequest = [[GetUserInfoDetailRequest alloc] init];
    self.userInfoRequest.userId = self.userId;
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [self.userInfoRequest startRequestWithRetClass:[GetUserInfoDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetUserInfoDetailRequestItem *item = (GetUserInfoDetailRequestItem *)retItem;
        self.data = item.data;
        [self setupUI];
    }];
}

- (void)requestMemberIdAndComplete:(void(^)(NSError *error))completeBlock{
    self.memberIdRequest = [[GetMemberIdRequest alloc]init];
    self.memberIdRequest.userId = self.userId;
    self.memberIdRequest.fromGroupTopicId = self.fromGroupTopicId;
    [self.memberIdRequest startRequestWithRetClass:[GetMemberIdRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        GetMemberIdRequestItem *item = (GetMemberIdRequestItem *)retItem;
        self.memberData = item.data;
        BLOCK_EXEC(completeBlock,error);
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *headWhiteView = [[UIView alloc] init];
    headWhiteView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:headWhiteView];
    [headWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(76);
    }];

    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 6;
    avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    [headWhiteView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    self.avatarImageView = avatarImageView;

    self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendMessageBtn setImage:[UIImage imageNamed:@"对话"] forState:0];
    [self.sendMessageBtn addTarget:self action:@selector(clickSendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [headWhiteView addSubview:self.sendMessageBtn];
    [self.sendMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(0);
    }];
    [self.sendMessageBtn setHidden:isEmpty(self.fromGroupTopicId)];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = self.data.realName;
    [headWhiteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.sendMessageBtn).offset(-15);
    }];
    self.nameLabel = nameLabel;

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [headWhiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    //-手机号-性别-学段-学科-省市区-学校-身份证号-子项目编号-子项目名称-承训单位-学校所在区域-学校类别-民族-职称--职务（非必填）最高学历-毕业院校-所学专业-电话（非必填）-电子邮箱（非必填）
    NSArray *titles = @[@"手机号", @"性别", @"学段", @"学科", @"省", @"市", @"区", @"学校"];
    Area *province = nil;
    Area *city = nil;
    Area *district = nil;
    if (!isEmpty(self.data.aui.province)) {
        for (Area *area in [AreaManager sharedInstance].areaModel.data) {
            if (self.data.aui.province.integerValue == area.areaID.integerValue) {
                province = area;
                break;
            }
        }
    }
    if (!isEmpty(self.data.aui.city)) {
        for (Area *area in province.sub) {
            if (self.data.aui.city.integerValue == area.areaID.integerValue) {
                city = area;
                break;
            }
        }
    }
    if (!isEmpty(self.data.aui.country)) {
        for (Area *area in city.sub) {
            if (self.data.aui.country.integerValue == area.areaID.integerValue) {
                district = area;
                break;
            }
        }
    }
    NSArray *contents = @[
                          self.data.mobilePhone,
                          [self.data sexString],
                          isEmpty(self.data.stageName) ? @"暂无" : self.data.stageName,
                          isEmpty(self.data.subjectName) ? @"暂无" : self.data.subjectName,
                          isEmpty(province) ? @"暂无" : province.name,
                          isEmpty(city) ? @"暂无" : city.name,
                          isEmpty(district) ? @"暂无" : district.name,
                          isEmpty(self.data.school) ? @"暂无" : self.data.school
                          ];
    self.lastBottom = headWhiteView.mas_bottom;
    for (int i = 0; i < titles.count; i++) {
        DetailCellView *detailCell = [[DetailCellView alloc] initWithTitle:titles[i] content:contents[i]];
        WEAK_SELF
        detailCell.clickContentBlock = ^(NSString *content){
            STRONG_SELF
            if (i) {
                return;
            }
            NSString *urlStr=[[NSString alloc] initWithFormat:@"tel:%@",content];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:urlStr];
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {

                }];
            } else {
                // Fallback on earlier versions
                [application openURL:URL];
            }
        };
        if (i == titles.count - 1) {
            detailCell.needBottomLine = NO;
        }
        [self.contentView addSubview:detailCell];
        [detailCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.lastBottom);
            if (i == titles.count-1) {
                make.bottom.mas_equalTo(-5);
            }
        }];
        self.lastBottom = detailCell.mas_bottom;
    }
}
-(void)clickSendMessageAction{
    if (self.memberData) {
        [self startChat];
    }else {
        WEAK_SELF
        [self requestMemberIdAndComplete:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
            }else{
                [self startChat];
            }
        }];
    }
}

- (void)startChat {
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    IMMember *member = [[IMMember alloc] init];
    member.userID = atoll([self.userId UTF8String]);
    member.memberID = atoll([self.memberData.memberId UTF8String]);
    member.avatar = self.data.avatar;
    member.name = self.data.realName;
    //如果是自己则返回
    GetUserInfoRequestItem_imTokenInfo *info = [UserManager sharedInstance].userModel.imInfo;
    if (member.memberID == [info.imMember toIMMember].memberID) {
        return;
    }
    IMTopic *topic = [IMUserInterface findTopicWithMember:member];
    if (topic) {
        chatVC.topic = topic;
    }else {
        IMTopicInfoItem *item = [[IMTopicInfoItem alloc]init];
        item.member = member;
        item.group =  [self.memberData.topic toContactsGroup];
        chatVC.info = item;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
