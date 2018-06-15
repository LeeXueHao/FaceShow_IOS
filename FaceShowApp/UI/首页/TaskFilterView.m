//
//  TaskFilterView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskFilterView.h"

static const CGFloat kMargin = 1;
static const NSInteger kVerticalMaxCount = 3;
static const CGFloat kItemHeight = 95;

@interface TaskFilterView()
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation TaskFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDataArray];
        [self setupUI];
    }
    return self;
}

- (void)setupDataArray {
    /*
    InteractType_Vote,
    InteractType_Comment,
    InteractType_Questionare,
    InteractType_SignIn,
    InteractType_Homework,
    InteractType_Discuss,
    InteractType_Unknown
     */
    TaskFilterItem *item0 = [[TaskFilterItem alloc]init];
    item0.type = InteractType_SignIn;
    item0.finishedTask = 1;
    item0.totalTask = 3;
    item0.title = @"签到";
    
    TaskFilterItem *item1 = [[TaskFilterItem alloc]init];
    item1.type = InteractType_Homework;
    item1.finishedTask = 1;
    item1.totalTask = 3;
    item1.title = @"作业";

    TaskFilterItem *item2 = [[TaskFilterItem alloc]init];
    item2.type = InteractType_Appraise;
    item2.finishedTask = 1;
    item2.totalTask = 3;
    item2.title = @"评价";

    TaskFilterItem *item3 = [[TaskFilterItem alloc]init];
    item3.type = InteractType_Questionare;
    item3.finishedTask = 1;
    item3.totalTask = 3;
    item3.title = @"问卷";

    TaskFilterItem *item4 = [[TaskFilterItem alloc]init];
    item4.type = InteractType_Vote;
    item4.finishedTask = 1;
    item4.totalTask = 3;
    item4.title = @"投票";
    
    TaskFilterItem *item5 = [[TaskFilterItem alloc]init];
    item5.type = InteractType_Comment;
    item5.finishedTask = 1;
    item5.totalTask = 3;
    item5.title = @"讨论";

    self.dataArray = [NSArray arrayWithObjects:item0,item1,item2,item3,item4,item5, nil];
}

- (void)setupUI {
    WEAK_SELF
    [self.dataArray enumerateObjectsUsingBlock:^(TaskFilterItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        CGFloat width = (SCREEN_WIDTH - (kVerticalMaxCount - 1)*kMargin )/ kVerticalMaxCount;
        TaskFilterItemView *itemView = [[TaskFilterItemView alloc]init];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.item = obj;
        if (idx == 0) {
            itemView.isSelected = YES;
        }
        [itemView setTaskFilterItemChooseBlock:^(TaskFilterItem *item) {
            STRONG_SELF
            [self nyx_showToast:[NSString stringWithFormat:@"选中了%@项",item.title]];
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
                STRONG_SELF
                if ([obj isKindOfClass:[TaskFilterItemView class]]) {
                    TaskFilterItemView *subView = obj;
                    subView.isSelected = NO;
                    if (idx == index) {
                        subView.isSelected = YES;
                    }
                }
            }];
            BLOCK_EXEC(self.taskFilterItemChooseBlock,item);
        }];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((kMargin + kItemHeight) * (idx/3));
            make.left.mas_equalTo((kMargin + width) * (idx%3));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(kItemHeight);
        }];
    }];
}

@end
