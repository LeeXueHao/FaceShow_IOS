//
//  ContactsSearchBarView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsSearchBarView.h"
#import "UIButton+ExpandHitArea.h"

@interface ContactsSearchBarView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation ContactsSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    self.searchButton = [[UIButton alloc]init];
    [self.searchButton setImage:[UIImage imageNamed:@"搜索图标"] forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"搜索图标"] forState:UIControlStateHighlighted];
    [self addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setHitTestEdgeInsets:UIEdgeInsetsMake(-8, -10, -8, -15)];
    [self.deleteButton setImage:[UIImage imageNamed:@"聊聊-删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"聊聊-删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    self.deleteButton.hidden = YES;
    
    self.textField = [[UITextField alloc]init];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont systemFontOfSize:14];
    NSString *placeholder = @"搜索姓名或单位";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, placeholder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, placeholder.length)];
    self.textField.attributedPlaceholder = attrString;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.searchButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.deleteButton.mas_left).mas_offset(-10);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.searchBlock,x);
        self.deleteButton.hidden = isEmpty(x);
    }];
}

- (void)deleteBtnAction {
    self.textField.text = nil;
    self.deleteButton.hidden = isEmpty(self.textField.text);
    BLOCK_EXEC(self.searchBlock,self.textField.text);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BLOCK_EXEC(self.searchBlock,textField.text);
    [textField resignFirstResponder];
    return YES;
}

@end
