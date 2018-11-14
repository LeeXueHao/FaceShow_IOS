//
//  MeetingNameLabel.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingNameLabel.h"

@implementation MeetingNameLabel

- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        [self setupUI];
        self.edgeInsets = UIEdgeInsetsMake(8, 13, 8, 13);
        [self setText:text];
        [self sizeToFit];
    }
    return self;
}

- (void)setupUI{
    self.layer.backgroundColor = [[UIColor colorWithHexString:@"1EA1F3"] colorWithAlphaComponent:0.05].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithHexString:@"1EA1F3"].CGColor;
    self.layer.cornerRadius = 4.0f;
    self.numberOfLines = 1;
    self.font = [UIFont systemFontOfSize:14];
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
