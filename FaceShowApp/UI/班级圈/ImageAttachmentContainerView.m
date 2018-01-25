//
//  ImageAttachmentContainerView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ImageAttachmentContainerView.h"
#import "ImageAttachmentView.h"
#import "ImageSelectionHandler.h"

@interface ImageAttachmentContainerView()
@property (nonatomic, strong) NSMutableArray<ImageAttachmentView *> *itemArray;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) ImageSelectionHandler *imageHandler;
@end

@implementation ImageAttachmentContainerView

+ (CGFloat)heightForCount:(NSInteger)count {
    CGFloat top = 5;
    CGFloat gap = 5;
    CGFloat margin = 15;
    CGFloat width = (SCREEN_WIDTH-gap*3-margin*2)/4;
    NSInteger line = 1;
    if (count >= 8) {
        line = 3;
    }else if (count >= 4) {
        line = 2;
    }
    return width*line + top*(line+1);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArray = [NSMutableArray array];
        self.imageHandler = [[ImageSelectionHandler alloc]init];
        [self setupUI];
        [self refreshUI];
    }
    return self;
}

- (void)setupUI {
    self.addImageBtn = [[UIButton alloc]init];
    [self.addImageBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [self.addImageBtn setImage:[UIImage imageNamed:@"添加照片点击态"] forState:UIControlStateHighlighted];
    [self.addImageBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction {
    [self.imageHandler pickImageWithMaxCount:9-self.itemArray.count completeBlock:^(NSArray *array) {
        [self addImages:array];
    }];
}

- (void)refreshUI {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat top = 5;
    CGFloat gap = 5;
    CGFloat margin = 15;
    CGFloat width = (SCREEN_WIDTH-gap*3-margin*2)/4;
    [self.itemArray enumerateObjectsUsingBlock:^(ImageAttachmentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        obj.frame = CGRectMake(margin+idx%4*(width+gap), top+idx/4*(width+top), width, width);
    }];
    if (self.itemArray.count < 9) {
        [self addSubview:self.addImageBtn];
        self.addImageBtn.frame = CGRectMake(margin+self.itemArray.count%4*(width+gap), top+self.itemArray.count/4*(width+top)+10, width-10, width-10);
    }
    NSMutableArray *array = [NSMutableArray array];
    for (ImageAttachmentView *item in self.itemArray) {
        [array addObject:item.image];
    }
    BLOCK_EXEC(self.imagesChangeBlock,array);
}

- (void)addImages:(NSArray *)images {
    for (UIImage *image in images) {
        ImageAttachmentView *view = [[ImageAttachmentView alloc]init];
        view.image = image;
        __weak ImageAttachmentView *curView = view;
        WEAK_SELF
        [view setTapBlock:^{
            STRONG_SELF
            [self browseFrom:curView];
        }];
        [view setDeleteBlock:^{
            STRONG_SELF
            [self.itemArray removeObject:curView];
            [self refreshUI];
        }];
        [self.itemArray addObject:view];
    }
    [self refreshUI];
}

- (void)browseFrom:(ImageAttachmentView *)view {
    NSInteger curIndex = [self.itemArray indexOfObject:view];
    NSMutableArray *array = [NSMutableArray array];
    for (ImageAttachmentView *item in self.itemArray) {
        [array addObject:item.image];
    }
    WEAK_SELF
    [self.imageHandler browseImageWithArray:array index:curIndex deleteBlock:^(NSInteger index) {
        STRONG_SELF
        [self.itemArray removeObjectAtIndex:index];
        [self refreshUI];
    }];
}

@end
