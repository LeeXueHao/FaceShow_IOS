//
//  ClassMomentHeaderView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentHeaderView.h"
#import "PreviewPhotosView.h"
@interface ClassMomentHeaderView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@end
@implementation ClassMomentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor redColor];
        self.contentView.frame = [UIScreen mainScreen].bounds;
//        [self layoutIfNeeded];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.edges.equalTo(self);
//    }];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor redColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.text = @"你啥房间啊发生";
    self.nameLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.photosView = [[PreviewPhotosView alloc] init];
    self.photosView.widthFloat = SCREEN_WIDTH - 50.0f;
    [self.contentView addSubview:self.photosView];
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
    }];
    [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
}
- (void)setTestInteger:(NSInteger)testInteger {
    _testInteger = testInteger;
    NSMutableArray<PreviewPhotosModel*> *mutableArray = [[NSMutableArray<PreviewPhotosModel*> alloc] init];
    for (int i = 0; i < testInteger; i ++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = @"http://scc.jsyxw.cn/course/89/8489.jpg";
        model.original = @"http://scc.jsyxw.cn/course/89/8489.jpg";
        [mutableArray addObject:model];
    }    
    
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    if (testInteger == 0) {
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_offset(0.0001f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }else {
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
}
@end
