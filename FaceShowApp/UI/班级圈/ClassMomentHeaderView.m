//
//  ClassMomentHeaderView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentHeaderView.h"
#import "PreviewPhotosView.h"
#import "ClassMomentLikeView.h"
@interface ClassMomentHeaderView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) PreviewPhotosView *photosView;

@property (nonatomic, strong) UIButton *openCloseButton;
@property (nonatomic, strong) ClassMomentLikeView *likeView;


@end
@implementation ClassMomentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userButton.backgroundColor = [UIColor redColor];
    self.userButton.layer.cornerRadius = 5.0f;
    self.userButton.clipsToBounds = YES;
    self.userButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.userButton];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = @"葛晓萍";
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];

    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.photosView = [[PreviewPhotosView alloc] init];
    self.photosView.widthFloat = SCREEN_WIDTH - 50.0f;
    [self.contentView addSubview:self.photosView];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.text = @"3分钟前";
    [self.contentView addSubview:self.timeLabel];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.commentButton];
    WEAK_SELF
    [[self.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentLikeCommentBlock,self.commentButton);
    }];
    
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCloseButton.clipsToBounds = YES;
    [self.openCloseButton setTitle:@"全文" forState:UIControlStateNormal];
    [self.openCloseButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    self.openCloseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.openCloseButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.openCloseButton];
    
    self.likeView = [[ClassMomentLikeView alloc] init];
    [self.contentView addSubview:self.likeView];
}
- (void)setupLayout {
    [self.userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.size.mas_offset(CGSizeMake(40.0f, 40.0f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userButton.mas_right).offset(10.0f);
        make.top.equalTo(self.userButton.mas_top).offset(6.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.mas_offset(50.0f);
        make.height.mas_offset(14.0f);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f)).priorityHigh();
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.centerY.equalTo(self.commentButton.mas_centerY);
        make.top.equalTo(self.photosView.mas_bottom).offset(20.0f);
    }];
    
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.openCloseButton.mas_bottom).offset(10.0f);
        //            make.height.mas_offset(0.0001f);
    }];
    
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton.mas_bottom).offset(10.0f);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
//        make.height.mas_offset(50.0f);
    }];
    
    
}
- (void)setTestInteger:(NSInteger)testInteger {
    _testInteger = testInteger;
    self.likeView.type = ClassMomentLikeType_Double;
    NSMutableArray<PreviewPhotosModel*> *mutableArray = [[NSMutableArray<PreviewPhotosModel*> alloc] init];
    for (int i = 0; i < MIN(_testInteger, 1); i ++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = @"http://scc.jsyxw.cn/course/89/8489.jpg";
        model.original = @"http://scc.jsyxw.cn/course/89/8489.jpg";
        [mutableArray addObject:model];
    }
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    if (testInteger == 0) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photosView.mas_bottom).offset(10.0f);
        }];
    }else {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photosView.mas_bottom).offset(20.0f);
        }];
    }
    NSString *tempString = @"";
    if (_testInteger == 2 || _testInteger == 4) {
        tempString = @"撒撒娇发空间发骄傲看了房间阿发了空间啊洛克菲勒卡离开房间拉风的卡发发德哈卡就回复拉科技回复路口就哈的咖啡机红辣椒客户分类江安河类释放几哈垃圾的回复来看是的哈卡就的士速递";
    }else {
        tempString = @"撒撒娇发空间发骄傲看了房间阿发了空间啊洛克菲勒卡离开房间拉风的卡发发德哈卡就回复拉科技回复路口就哈的咖啡机红辣椒客户分类江安河";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f;
    NSAttributedString *attributedString  = [[NSAttributedString alloc] initWithString:tempString attributes:@{NSParagraphStyleAttributeName :paragraphStyle}];
    self.contentLabel.attributedText = attributedString;
    if ([self sizeForTitle:tempString] >= 85.0f) {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.height.mas_offset(108.0f).priorityHigh();
        }];
        [self.openCloseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(14.0f);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
        }];
    }else {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        }];
        [self.openCloseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.0001f);
            make.top.equalTo(self.contentLabel.mas_bottom);
        }];
    }
    
    
    [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton.mas_bottom).offset(10.0f);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
   
    

}
- (CGFloat)sizeForTitle:(NSString *)title {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 999)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                NSParagraphStyleAttributeName :paragraphStyle} context:NULL];
    return rect.size.height;
}
@end
