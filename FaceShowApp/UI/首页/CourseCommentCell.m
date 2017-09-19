//
//  CourseCommentCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentCell.h"

@interface CourseCommentCell()
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation CourseCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bottomLine = [[UIView alloc]init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(5);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(8);
    }];
    self.favorButton = [[UIButton alloc]init];
    [self.favorButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favorButton];
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.mas_equalTo(-15);
    }];
    self.favorLabel = [[UILabel alloc]init];
    self.favorLabel.font = [UIFont systemFontOfSize:13];
    self.favorLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.favorLabel];
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.favorButton.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(self.favorButton.mas_centerY);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentLabel.mas_left);
        make.centerY.mas_equalTo(self.favorButton.mas_centerY);
    }];
    [self initData];
}

- (void)favorAction {
    BLOCK_EXEC(self.favorBlock);
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLine.hidden = bottomLineHidden;
}

- (void)initData {
    self.headImageView.backgroundColor = [UIColor redColor];
    self.nameLabel.text = @"郭涛";
    NSString *comment = @"访问二班跟i惹不过个人一个人关闭瑞尔给我给给我改为郭文贵问改为郭文贵问给我给问个问过问改为改为改为跟i为跟i问过访问二班跟i惹不过个人一个人关闭瑞尔给我给给我改为郭文贵问改为郭文贵问给我给问个问过问改为改为改为跟i为跟i问过1";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:comment attributes:dic];
    self.commentLabel.attributedText = attributeStr;
    self.favorLabel.text = @"赞";
    self.timeLabel.text = @"3分钟前";
}

@end
