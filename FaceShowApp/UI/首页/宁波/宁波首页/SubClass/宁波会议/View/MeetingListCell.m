//
//  MeetingListCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingListCell.h"
#import "MeetingNameLabel.h"
#import "NBGetMeetingListRequest.h"

@interface MeetingListCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeTagLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) MASViewAttribute *topAttribute;
@property (nonatomic, strong) MASViewAttribute *leftAttribute;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, copy) NSArray<UILabel *> *labelArray;
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
    self.timeTagLabel = [[UILabel alloc]init];
    self.timeTagLabel.font = [UIFont systemFontOfSize:11];
    self.timeTagLabel.textColor = [UIColor whiteColor];
    self.timeTagLabel.textAlignment = NSTextAlignmentCenter;
    self.timeTagLabel.backgroundColor = [UIColor colorWithHexString:@"979fad"];
    self.timeTagLabel.text = @"时间";
    self.timeTagLabel.layer.cornerRadius = 3;
    self.timeTagLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.timeTagLabel];
    [self.timeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.timeTagLabel.mas_centerY);
    }];

    self.containerView = [[UIView alloc] init];
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeTagLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];

}


- (void)layoutSubviews{
    self.topAttribute = self.containerView.mas_top;
    self.leftAttribute = self.containerView.mas_left;
    __block CGFloat lastLeftMargin = 15;
    __block CGFloat lastTopMargin = 10;
    __block UILabel *lastLabel;
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj.text sizeWithFont:[UIFont systemFontOfSize:14]];
        if (lastLeftMargin + size.width + 26 + 15 > SCREEN_WIDTH) {
            lastLeftMargin = 15;
            lastTopMargin += size.height + 16;
            self.leftAttribute = self.containerView.mas_left;
            self.topAttribute = lastLabel.mas_bottom;
        }
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftAttribute).offset(15);
            make.top.mas_equalTo(self.topAttribute).offset(10);
            make.size.mas_equalTo(CGSizeMake(size.width + 26, size.height + 16));
            if (idx == self.labelArray.count - 1) {
                make.bottom.mas_equalTo(self.containerView.mas_bottom);
            }
        }];
        lastLabel = obj;
        self.leftAttribute = obj.mas_right;
        lastLeftMargin += size.width + 26 + 15;
    }];
    [super layoutSubviews];
}

- (void)setGroup:(NBGetMeetingListRequestItem_Group *)group{
    _group = group;
    self.titleLabel.text = group.categoryName;
    NSString *startTime = [group.startTime omitSecondOfFullDateString];
    NSString *endTime = [group.endTime omitSecondOfFullDateString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    NSMutableArray *arr = [NSMutableArray array];
    for (GetCourseListRequestItem_coursesList *coursesList in group.courses) {
        MeetingNameLabel *meetLabel = [[MeetingNameLabel alloc] initWithText:coursesList.courseName];
        [self.containerView addSubview:meetLabel];
        [arr addObject:meetLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        WEAK_SELF
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.clickTagBlock,coursesList.courseId);
        }];
        meetLabel.userInteractionEnabled = YES;
        [meetLabel addGestureRecognizer:tap];
    }
    self.labelArray = arr.copy;
}



@end
