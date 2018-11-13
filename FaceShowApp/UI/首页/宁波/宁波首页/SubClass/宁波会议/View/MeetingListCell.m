//
//  MeetingListCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingListCell.h"
#import "GetCourseListRequest.h"

@interface MeetingListCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation MeetingListCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    UILabel *timeTagLabel = [[UILabel alloc]init];
    timeTagLabel.font = [UIFont systemFontOfSize:11];
    timeTagLabel.textColor = [UIColor whiteColor];
    timeTagLabel.textAlignment = NSTextAlignmentCenter;
    timeTagLabel.backgroundColor = [UIColor colorWithHexString:@"979fad"];
    timeTagLabel.text = @"时间";
    timeTagLabel.layer.cornerRadius = 3;
    timeTagLabel.clipsToBounds = YES;
    [self.contentView addSubview:timeTagLabel];
    [timeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeTagLabel.mas_centerY);
    }];
}

- (void)setItem:(GetCourseListRequestItem_coursesList *)item{
    _item = item;
    self.titleLabel.text = item.courseName;
    NSString *startTime = [item.startTime omitSecondOfFullDateString];
    NSString *endTime = [item.endTime omitSecondOfFullDateString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
}



@end
