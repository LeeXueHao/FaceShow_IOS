//
//  TaskFilterView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskFilterView.h"
#import "GetAllTasksRequest.h"
#import "TaskFilterItemView.h"

static const CGFloat kMargin = 1;
static const NSInteger kVerticalMaxCount = 3;
static const CGFloat kItemHeight = 95;

@interface TaskFilterView()
@property(nonatomic, strong) NSMutableArray <TaskFilterItemView *> *itemViewArray;
@end

@implementation TaskFilterView

- (instancetype)initWithDataArray:(NSArray *)dataArray {
    if (self = [super init]) {
        self.dataArray = dataArray;
        self.itemViewArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WEAK_SELF
    [self.dataArray enumerateObjectsUsingBlock:^(GetAllTasksRequestItem_interactType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        CGFloat width = (SCREEN_WIDTH - (kVerticalMaxCount - 1)*kMargin )/ kVerticalMaxCount;
        TaskFilterItemView *itemView = [[TaskFilterItemView alloc]init];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.item = obj;
        [itemView setTaskFilterItemChooseBlock:^(GetAllTasksRequestItem_interactType *item) {
            STRONG_SELF
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
        [self.itemViewArray addObject:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((kMargin + kItemHeight) * (idx/3));
            make.left.mas_equalTo((kMargin + width) * (idx%3));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(kItemHeight);
        }];
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.dataArray.count) {
        _selectedIndex = selectedIndex;
        WEAK_SELF
        [self.itemViewArray enumerateObjectsUsingBlock:^(TaskFilterItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STRONG_SELF
            obj.isSelected = NO;
            if (selectedIndex == idx) {
                obj.isSelected = YES;
            }
        }];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    WEAK_SELF
    [self.itemViewArray enumerateObjectsUsingBlock:^(TaskFilterItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        obj.item = dataArray[idx];
    }];
}

- (void)reloadTaskFilterWithIndex:(NSInteger)index {
    WEAK_SELF
    [self.itemViewArray enumerateObjectsUsingBlock:^(TaskFilterItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        if (index == idx) {
            obj.item = self.dataArray[index];
        }
    }];
}
@end
