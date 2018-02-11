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
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) PreviewPhotosView *photosView;

@property (nonatomic, strong) UIButton *openCloseButton;
@property (nonatomic, strong) ClassMomentLikeView *likeView;


@end
@implementation ClassMomentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set 
- (void)setMoment:(ClassMomentListRequestItem_Data_Moment *)moment {
    _moment = moment;
    [self.userButton sd_setImageWithURL:[NSURL URLWithString:_moment.publisher.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"]];
    self.userButton.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.nameLabel.text = _moment.publisher.realName;
    self.timeLabel.text = _moment.publishTimeDesc;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attributedString  = [[NSAttributedString alloc] initWithString:_moment.content?:@"\n" attributes:@{NSParagraphStyleAttributeName :paragraphStyle}];
    self.contentLabel.attributedText = attributedString;
    CGFloat height = [self sizeForTitle:_moment.content?:@""];
    if (height >= 85.0f) {
        if (!_moment.isOpen.boolValue) {
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel.mas_left);
                make.top.equalTo(self.nameLabel.mas_bottom).offset(3.0f);
                make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
                make.height.mas_equalTo(85.0f);
            }];
        }else {
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel.mas_left);
                make.top.equalTo(self.nameLabel.mas_bottom).offset(3.0f);
                make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
                make.height.mas_equalTo(height);
            }];
        }
        self.openCloseButton.selected = _moment.isOpen.boolValue;
        [self.openCloseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(14.0f);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10.0f);
        }];
    }else {
        self.openCloseButton.selected = _moment.isOpen.boolValue;
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.height.mas_equalTo(height);
        }];
        [self.openCloseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.00001f);
            make.top.equalTo(self.contentLabel.mas_bottom);
        }];
    }
    [self setupPhoto:_moment.albums];
    if (_moment.likes.count == 0 && _moment.comments.count == 0) {
        [self.likeView reloadLikes:_moment.likes withType:ClassMomentLikeType_Not];
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentButton.mas_bottom).offset(10.0f);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
        }];
    }else if (_moment.likes.count != 0 && _moment.comments.count != 0) {
        [self.likeView reloadLikes:_moment.likes withType:ClassMomentLikeType_Double];
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentButton.mas_bottom);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
        }];

    }else if (_moment.likes.count != 0) {
        [self.likeView reloadLikes:_moment.likes withType:ClassMomentLikeType_Like];
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentButton.mas_bottom);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
        }];
        
    }else {
        [self.likeView reloadLikes:_moment.likes withType:ClassMomentLikeType_Comment];
        [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentButton.mas_bottom);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
        }];
    } 
}
- (void)setupPhoto:(NSArray<ClassMomentListRequestItem_Data_Moment_Album> *)albums {
    NSMutableArray<PreviewPhotosModel*> *mutableArray = [[NSMutableArray<PreviewPhotosModel*> alloc] init];
    [albums enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Album *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = obj.attachment.resThumb;
        model.original = obj.attachment.resThumb;
        [mutableArray addObject:model];

    }];
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    if (mutableArray.count == 0) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photosView.mas_bottom).offset(10.0f);
        }];
        self.photosView.hidden = YES;
    }else {
        self.photosView.hidden = NO;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photosView.mas_bottom).offset(20.0f);
        }];
    }
}

#pragma mark - setupUI
- (void)setupUI{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    self.photosView.widthFloat = SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f;
//    self.photosView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];

    [self.contentView addSubview:self.photosView];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.text = @"3分钟前";
    [self.contentView addSubview:self.timeLabel];
    
    self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reportButton setImage:[UIImage imageNamed:@"投诉举报icon正常态"] forState:UIControlStateNormal];
    [self.reportButton setImage:[UIImage imageNamed:@"投诉举报icon点击态"] forState:UIControlStateHighlighted];
//    self.reportButton.backgroundColor = [UIColor redColor];
    self.reportButton.imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.reportButton];
    WEAK_SELF
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentReportBlock);
    }];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"赞评论展开按钮-点击态"] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"赞评论展开按钮张常态"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.commentButton];
    [[self.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentLikeCommentBlock,self.commentButton);
    }];
    
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCloseButton.clipsToBounds = YES;
    [self.openCloseButton setTitle:@"全文" forState:UIControlStateNormal];
    [self.openCloseButton setTitle:@"收起" forState:UIControlStateSelected];
    [self.openCloseButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    self.openCloseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.openCloseButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.openCloseButton];
    [[self.openCloseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentOpenCloseBlock,self.openCloseButton.selected);
    }];
    
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
        make.height.mas_offset(14.0f);
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
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f)).priorityHigh();
    }];
    
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.openCloseButton.mas_bottom).offset(8.0f);
        //            make.height.mas_offset(0.0001f);
    }];
    
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentButton.mas_bottom).offset(10.0f);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
    
    
}
- (CGFloat)sizeForTitle:(NSString *)title {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 1999)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                NSParagraphStyleAttributeName :paragraphStyle} context:NULL];
    return ceilf(rect.size.height);
}
@end
