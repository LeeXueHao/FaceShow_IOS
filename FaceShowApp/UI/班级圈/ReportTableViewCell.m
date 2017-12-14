//
//  ReportTableViewCell.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReportTableViewCell.h"

@interface ReportTableViewCell ()
@property (nonatomic, strong) UIImageView *selectedImageView;
@end

@implementation ReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择按钮"]];
    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(19, 15));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
}

@end
