//
//  HomeworkRequirementViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkRequirementViewController.h"
#import "PreviewPhotosView.h"
#import "DoHomeworkViewController.h"

static const CGFloat kHomeworkButtonHeight = 45.f;

@interface HomeworkRequirementViewController ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@property (nonatomic, strong) UIButton *homeworkButton;
@end

@implementation HomeworkRequirementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupMockData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(kHomeworkButtonHeight);
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
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
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
    
    if (self.isFinished) {
        return;
    }
    self.homeworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeworkButton.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    self.homeworkButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.homeworkButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.homeworkButton setTitle:@"写作业" forState:UIControlStateNormal];
    [self.homeworkButton addTarget:self action:@selector(homeworkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeworkButton];
    [self.homeworkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(kHomeworkButtonHeight);
    }];
}

- (void)homeworkButtonClick:(UIButton *)sender {
    DoHomeworkViewController *vc = [[DoHomeworkViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupMockData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
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
//- (void)setupPhoto:(NSArray<ClassMomentListRequestItem_Data_Moment_Album> *)albums {
//    NSMutableArray<PreviewPhotosModel*> *mutableArray = [[NSMutableArray<PreviewPhotosModel*> alloc] init];
//    [albums enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Album *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
//        model.thumbnail = obj.attachment.resThumb;
//        model.original = obj.attachment.resThumb;
//        [mutableArray addObject:model];
//
//    }];
//    self.photosView.imageModelMutableArray = mutableArray;
//    [self.photosView reloadData];
//    if (mutableArray.count == 0) {
//        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.photosView.mas_bottom).offset(10.0f);
//        }];
//        self.photosView.hidden = YES;
//    }else {
//        self.photosView.hidden = NO;
//        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.photosView.mas_bottom).offset(20.0f);
//        }];
//    }
//}

@end

