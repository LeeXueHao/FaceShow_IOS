//
//  ModifyGraduationViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ModifyGraduationViewController.h"
#import "UpdateUserInfoRequest.h"
@interface ModifyGraduationViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UpdateUserInfoRequest *request;

@end

@implementation ModifyGraduationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改毕业院校";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"保存" action:^{
        STRONG_SELF
        [self saveName];
    }];
    [self setupUI];
    [self addObserver];
}
- (void)addObserver {
    UIBarButtonItem *item =  self.navigationItem.rightBarButtonItems[1];
    @weakify(self);
    RACSignal *textSignal =
    [self.textfield.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self.textfield.text yx_stringByTrimmingCharacters].length > 0);
     }];
    [[RACSignal combineLatest:@[textSignal]
                       reduce:^id(NSNumber *text) {
                           return @([text boolValue]);
                       }] subscribeNext:^(NSNumber *x) {
                           STRONG_SELF
                           item.enabled = [x boolValue];
                       }] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(45);
    }];
    
    self.textfield = [[UITextField alloc]init];
    self.textfield.textColor = [UIColor colorWithHexString:@"333333"];
    self.textfield.returnKeyType = UIReturnKeyDone;
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"毕业院校" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textfield.delegate = self;
    [bottomView addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.textfield.text = [UserManager sharedInstance].userModel.aui.graduation;
}

- (void)saveName {
    if (isEmpty(self.textfield.text)) {
        return;
    }
    [self.textfield resignFirstResponder];
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    self.request.graduation = [self.textfield.text yx_stringByTrimmingCharacters];
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.aui.graduation = [self.textfield.text yx_stringByTrimmingCharacters];
        [[UserManager sharedInstance]saveData];
        BLOCK_EXEC(self.completeBlock);
        [self backAction];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage] || [self stringContainsEmoji:string]) {
        return NO;
    }
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 200) {
        str = [str substringToIndex:200];
        textField.text = str;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextPosition* beginning = textField.beginningOfDocument;
            UITextPosition* startPosition = [textField positionFromPosition:beginning offset:200];
            UITextPosition* endPosition = [textField positionFromPosition:beginning offset:200];
            UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
            [textField setSelectedTextRange:selectionRange];
        });
        return NO;
    }
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
@end
