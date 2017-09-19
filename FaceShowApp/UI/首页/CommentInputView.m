//
//  CommentInputView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CommentInputView.h"
#import <SAMTextView.h>

@interface CommentInputView()<UITextViewDelegate>
@property (nonatomic, strong) SAMTextView *textView;
@end

@implementation CommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"c9cacb"];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    UIView *bottomLine = [topLine clone];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.textView = [[SAMTextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.returnKeyType = UIReturnKeyDone;
    NSString *placeholderStr = @"评论";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, placeholderStr.length)];
    self.textView.attributedPlaceholder = attrStr;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.delegate = self;
    self.textView.clipsToBounds = YES;
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
