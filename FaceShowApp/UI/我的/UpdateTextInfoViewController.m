//
//  UpdateTextInfoViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpdateTextInfoViewController.h"
#import "UpdateUserInfoRequest.h"

@interface UpdateTextInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UpdateUserInfoRequest *request;
@property (nonatomic, assign) NSInteger maxTextInteger;
@end

@implementation UpdateTextInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [UserInfoNameModel userInfoName:self.infoType];
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"保存" action:^{
        STRONG_SELF
        [self modifyUserInfo];
    }];
    [self setupUI];
    if (self.infoType != UserInfoNameType_Email && self.infoType != UserInfoNameType_Telephone && self.infoType != UserInfoNameType_Job) {
        [self addObserver];
    }
    if (self.infoType == UserInfoNameType_School) {
        self.maxTextInteger = 20;
    }else {
        self.maxTextInteger = 200;
    }
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
    if (self.infoType == UserInfoNameType_IdCard || self.infoType == UserInfoNameType_Telephone) {
        self.textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if (self.infoType == UserInfoNameType_Email) {
        self.textfield.keyboardType = UIKeyboardTypeEmailAddress;
    }
    self.textfield.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:[UserInfoNameModel userInfoName:self.infoType] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textfield.delegate = self;
    [bottomView addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    [self setupDefaultText];
    [self.textfield becomeFirstResponder];
}
- (void)setupDefaultText{
    switch (self.infoType) {
        case UserInfoNameType_RealName:{
            self.textfield.text = [UserManager sharedInstance].userModel.realName;
        }
            break;
        case UserInfoNameType_School:{
            self.textfield.text = [UserManager sharedInstance].userModel.school;
        }
            break;
        case UserInfoNameType_IdCard:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.idCard;
        }
            break;
        case UserInfoNameType_Area:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.area;
        }
            break;
        case UserInfoNameType_SchoolType:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.schoolType;
        }
            break;
        case UserInfoNameType_Nation:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.nation;
        }
            break;
        case UserInfoNameType_RecordEducation:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.recordeducation;
        }
            break;
        case UserInfoNameType_Graduation:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.graduation;
        }
            break;
        case UserInfoNameType_Professional:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.professional;
        }
            break;
        case UserInfoNameType_Title:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.title;
        }
            break;
        case UserInfoNameType_ChildProjectId:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.childProjectId;
        }
            break;
        case UserInfoNameType_ChildProjectName:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.childProjectName;
        }
            break;
        case UserInfoNameType_Organizer:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.organizer;
        }
            break;
        case UserInfoNameType_Job:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.job;
        }
            break;
        case UserInfoNameType_Telephone:{
            self.textfield.text = [UserManager sharedInstance].userModel.aui.telephone;
        }
            break;
        case UserInfoNameType_Email:{
            self.textfield.text = [UserManager sharedInstance].userModel.email;
        }
            break;
        default:
            break;
    }
    [[UserManager sharedInstance]saveData];
}

- (void)modifyUserInfo {
    [self.textfield resignFirstResponder];
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    [self setupRequestParameter];
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self saveUserInfo];
        BLOCK_EXEC(self.completeBlock);
        [self backAction];
    }];
}


- (void)setupRequestParameter{
    switch (self.infoType) {
        case UserInfoNameType_RealName:{
             self.request.realName = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_School:{
            self.request.school = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_IdCard:{
            self.request.idCard = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Area:{
            self.request.area = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_SchoolType:{
            self.request.schoolType = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Nation:{
            self.request.nation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_RecordEducation:{
            self.request.recordeducation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Graduation:{
            self.request.graduation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Professional:{
            self.request.professional = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Title:{
            self.request.title = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_ChildProjectId:{
            self.request.childprojectId = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_ChildProjectName:{
            self.request.childprojectName = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Organizer:{
            self.request.organizer = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Job:{
            self.request.job = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Telephone:{
            self.request.telephone = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Email:{
            self.request.email = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        default:
            break;
    }
}
- (void)saveUserInfo{
    switch (self.infoType) {
        case UserInfoNameType_RealName:{
            [UserManager sharedInstance].userModel.realName = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_School:{
           [UserManager sharedInstance].userModel.school = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_IdCard:{
            [UserManager sharedInstance].userModel.aui.idCard = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Area:{
            [UserManager sharedInstance].userModel.aui.area = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_SchoolType:{
            [UserManager sharedInstance].userModel.aui.schoolType = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Nation:{
            [UserManager sharedInstance].userModel.aui.nation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_RecordEducation:{
            [UserManager sharedInstance].userModel.aui.recordeducation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Graduation:{
            [UserManager sharedInstance].userModel.aui.graduation = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Professional:{
            [UserManager sharedInstance].userModel.aui.professional = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Title:{
            [UserManager sharedInstance].userModel.aui.title = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_ChildProjectId:{
            [UserManager sharedInstance].userModel.aui.childProjectId = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_ChildProjectName:{
            [UserManager sharedInstance].userModel.aui.childProjectName = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Organizer:{
            [UserManager sharedInstance].userModel.aui.organizer = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Job:{
            [UserManager sharedInstance].userModel.aui.job = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Telephone:{
            [UserManager sharedInstance].userModel.aui.telephone = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        case UserInfoNameType_Email:{
            [UserManager sharedInstance].userModel.email = [self.textfield.text yx_stringByTrimmingCharacters];
        }
            break;
        default:
            break;
    }
    [[UserManager sharedInstance]saveData];
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
    if (str.length > self.maxTextInteger) {
        str = [str substringToIndex:self.maxTextInteger];
        textField.text = str;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextPosition* beginning = textField.beginningOfDocument;
            UITextPosition* startPosition = [textField positionFromPosition:beginning offset:self.maxTextInteger];
            UITextPosition* endPosition = [textField positionFromPosition:beginning offset:self.maxTextInteger];
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
