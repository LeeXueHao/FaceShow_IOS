//
//  EmptySignInRecordCell.m
//  FaceShowApp
//
//  Created by srt on 2018/12/7.
//  Copyright © 2018 niuzhaowang. All rights reserved.
//

#import "EmptySignInRecordCell.h"

@interface EmptySignInRecordCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation EmptySignInRecordCell

#pragma mark- Live circle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self placeSubViews];
    }
    return self;
}

#pragma mark- Overwrite
#pragma mark- Delegate
#pragma mark- Notification methods
#pragma mark- Interface methods
- (void)resetCellContent {
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(59);
    }];
    
    [self.lineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark- Private methods
- (void)placeSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.lineImageView];
}

#pragma mark- Setter and getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLab.text = @"暂无签到";
    }
    return _titleLab;
}

- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    }
    return _lineImageView;
}

@end
