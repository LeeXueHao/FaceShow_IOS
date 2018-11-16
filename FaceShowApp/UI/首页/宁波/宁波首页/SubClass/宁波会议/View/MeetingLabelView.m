//
//  MeetingLabelView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingLabelView.h"

@interface MeetingLabelView()

@property (nonatomic, copy) NSString *text;

@end

@implementation MeetingLabelView

- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        self.text = text;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.layer.backgroundColor = [[UIColor colorWithHexString:@"1EA1F3"] colorWithAlphaComponent:0.05].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithHexString:@"1EA1F3"].CGColor;
    self.layer.cornerRadius = 4.0f;

    CGSize size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.frame = CGRectMake(0, 0, size.width + 26, size.height + 16);

    UILabel *label = [[UILabel alloc] init];
    [label setText:self.text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    [label setTextColor:[UIColor colorWithHexString:@"333333"]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [self addSubview:label];
    label.center = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
