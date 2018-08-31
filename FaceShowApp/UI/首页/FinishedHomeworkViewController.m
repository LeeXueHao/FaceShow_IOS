//
//  FinishedHomeworkViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "FinishedHomeworkViewController.h"
#import "PreviewPhotosView.h"
#import "HomeworkRequirementViewController.h"
#import "DoHomeworkViewController.h"
#import "GetHomeworkRequest.h"

@interface FinishedHomeworkViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *appraiseLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@property (nonatomic, strong) UIButton *homeworkButton;
@end

@implementation FinishedHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNavView];
//    [self setupMockData];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction {
    [super backAction];
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[DoHomeworkViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[HomeworkRequirementViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
}

- (void)setupUI {
    self.title = self.homework.title;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        CGFloat bottom = isEmpty(self.userHomework.assess)? -45:0;
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(bottom);
        } else {
            make.bottom.mas_equalTo(bottom);
        }
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"这是作业的标题这是作业的标题这是作业的标题";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    self.appraiseLabel = [[UILabel alloc]init];
    self.appraiseLabel.font = [UIFont boldSystemFontOfSize:14];
    self.appraiseLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.appraiseLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.appraiseLabel];
    [self.appraiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(11);
        make.left.right.mas_equalTo(self.titleLabel);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 0;
    NSString *contentStr = @"这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容这是内容这个是内容";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.contentLabel.textColor range:NSMakeRange(0, contentStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.contentLabel.font range:NSMakeRange(0, contentStr.length)];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, [contentStr length])];
    self.contentLabel.attributedText = attrStr;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.appraiseLabel);
        make.top.mas_equalTo(self.appraiseLabel.mas_bottom).offset(30);
    }];
    
    self.photosView = [[PreviewPhotosView alloc] init];
    self.photosView.widthFloat = SCREEN_WIDTH - 15.0f - 15.0f;
    [self.contentView addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
        make.height.mas_equalTo(0.1);
    }];
    if (isEmpty(self.userHomework.assess)) {
        self.homeworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.homeworkButton.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
        self.homeworkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.homeworkButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [self.homeworkButton setTitle:@"修 改" forState:UIControlStateNormal];
        [self.homeworkButton addTarget:self action:@selector(homeworkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.homeworkButton];
        [self.homeworkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.scrollView.mas_bottom);
            make.height.mas_equalTo(45);
        }];
    }
}

- (void)setupNavView {
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"作业要求" action:^{
        STRONG_SELF
        HomeworkRequirementViewController *vc = [[HomeworkRequirementViewController alloc]init];
        vc.homework = self.homework;
        vc.isFinished = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)setupData {
    self.titleLabel.text = self.userHomework.title;
    if (!self.userHomework.assess) {
        self.userHomework.assess = @"暂无";
    }
    NSString *appraise = [NSString stringWithFormat:@"班主任评价:%@",self.userHomework.assess];
    NSMutableAttributedString *appraiseAttStr = [[NSMutableAttributedString alloc]initWithString:appraise];
    [appraiseAttStr addAttributes:@{NSFontAttributeName:self.appraiseLabel.font,NSForegroundColorAttributeName:self.appraiseLabel.textColor} range:NSMakeRange(0,[appraise length])];
    [appraiseAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f56f5d"] range:NSMakeRange(6, [appraise length] - 6)];
    self.appraiseLabel.attributedText = appraiseAttStr;
    self.contentLabel.text = self.userHomework.content;
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (int i = 0; i < self.userHomework.attachmentInfos.count; i++) {
        GetHomeworkRequestItem_attachmentInfo *attachmentInfo = self.userHomework.attachmentInfos[i];
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = attachmentInfo.previewUrl;
        model.original = attachmentInfo.downloadUrl;
        [mutableArray addObject:model];
    }
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.photosView.heightFloat);
    }];
}

- (void)homeworkButtonClick:(UIButton *)sender {
    DoHomeworkViewController *vc = [[DoHomeworkViewController alloc]init];
    vc.homework = self.homework;
    vc.userHomework = self.userHomework;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupMockData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = @"http://i0.sinaimg.cn/edu/2014/0607/U6360P352DT20140607090037.jpg";
        model.original = @"http://i0.sinaimg.cn/edu/2014/0607/U6360P352DT20140607090024.jpg";
        [mutableArray addObject:model];
    }
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.photosView.heightFloat);
    }];
}


@end
