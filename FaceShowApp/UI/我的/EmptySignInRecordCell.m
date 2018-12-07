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
#pragma mark- Event Response methods
#pragma mark- Net request
#pragma mark- Private methods
- (void)placeSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.lineImageView];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
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
