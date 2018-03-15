//
//  IMInputView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMInputView.h"
#import <SAMTextView.h>

static const NSInteger kMaxTextLength = 2000;

@interface IMInputView()<UITextViewDelegate>
@property (nonatomic, assign) CGFloat textMaxHeight;
@property (nonatomic, assign) CGFloat textHeight;

@end

@implementation IMInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textMaxHeight = 90.0f;
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
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
    
    self.contentView = [[UIView alloc]init];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.clipsToBounds = YES;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    self.textView = [[SAMTextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 8, 8, 8);
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-35);
    }];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraButton setImage:[UIImage imageNamed:@"聊聊-上传内容图标正常态"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"聊聊-上传内容图标点击态"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(cameraButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cameraButton];
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
}

- (void)cameraButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.cameraButtonClickBlock);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    if (content.length > kMaxTextLength) {
        textView.text =  [content substringToIndex:kMaxTextLength];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([[self.textView.text yx_stringByTrimmingCharacters] length]!=0) {
            BLOCK_EXEC(self.completeBlock,textView.text);
        }
        return NO;
    }
    //    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage] || [self stringContainsEmoji:text]) {
    //        return NO;
    //    }
    return YES;
}
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    
                                    //                                    if (0x2100 <= high && high <= 0x27BF){
                                    //                                        returnValue = YES;
                                    //                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)setTextString:(NSString *)textString {
    _textString = textString;
    self.textView.text = _textString;
    [self textDidChange];
}

- (void)textDidChange {
    if (!self.isChangeBool) {
        return;
    }
    NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);
    if (self.textHeight != height) { // 高度不一样，就改变了高度
        // 最大高度，可以滚动
        self.textView.scrollEnabled = height > self.textMaxHeight && self.textMaxHeight > 0;
        self.textHeight = height;
        if (self.textView.scrollEnabled == NO) {
            BLOCK_EXEC(self.textHeightChangeBlock,height);
            [self.superview layoutIfNeeded];
        }
    }
}

@end
