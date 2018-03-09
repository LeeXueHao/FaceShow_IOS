//
//  IMMessageBaseCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageCellDelegate.h"
#import "IMUserInterface.h"
#import "IMChatViewModel.h"

@interface IMMessageBaseCell : UITableViewCell

@property (nonatomic, assign) id<IMMessageCellDelegate>delegate;

@property (nonatomic, strong) IMChatViewModel *model;

@property (nonatomic, assign) TopicType topicType;

@property (nonatomic, strong) UIImageView *messageBackgroundView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *stateButton;

- (void)setupUI;
- (void)setupLayout;
- (CGFloat)heigthtForMessageModel:(IMChatViewModel *)model;//此处的高度不包括 时间 的高
@end

