//
//  IMMessageTableView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/2/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageTableView.h"

@implementation IMMessageTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (contentSize.height > self.contentSize.height)
        {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}

@end
