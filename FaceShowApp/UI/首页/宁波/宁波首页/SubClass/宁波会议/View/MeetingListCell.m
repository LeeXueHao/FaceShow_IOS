//
//  MeetingListCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingListCell.h"
#import "MeetingLabelView.h"
#import "NBGetMeetingListRequest.h"
#import "GetCourseListRequest.h"

@interface MeetingListCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *containerView;
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

    self.containerView = [[UIView alloc] init];
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.containerView removeSubviews];
}

- (void)setItem:(NBGetMeetingListRequestItem_Group *)item{
    _item = item;
    self.titleLabel.text = item.categoryName;
    NSString *startTime = [item.startTime omitSecondOfFullDateString];
    NSString *endTime = [item.endTime omitSecondOfFullDateString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    [self.containerView removeSubviews];
    for (GetCourseListRequestItem_coursesList *courseList  in item.courses) {
        MeetingLabelView *view = [[MeetingLabelView alloc] initWithText:courseList.courseName];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        WEAK_SELF
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.clickBlock,courseList.courseId)
        }];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
        [self.containerView addSubview:view];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    for (int i = 0; i < self.containerView.subviews.count; i ++) {
        MeetingLabelView *nameLabel = self.containerView.subviews[i];
        if (nameLabel.width + 30 > SCREEN_WIDTH) {
            [nameLabel setWidth:SCREEN_WIDTH - 30];
            leftMargin = 15;
            if (i != 0) {
                topMargin += nameLabel.height + 8;
            }
        }
        if (leftMargin + nameLabel.width + 15 > SCREEN_WIDTH) {
            leftMargin = 15;
            topMargin += nameLabel.height + 8;
        }
        [nameLabel setX:leftMargin andY:topMargin];
        leftMargin += nameLabel.width + 4;
    }
}


@end
