//
//  PhotoChooseViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhotoChooseViewController.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "PhotoChooseCell.h"
@interface PhotoChooseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PhotoChooseViewController
#pragma mark - set
- (void)setChooseInteger:(NSInteger)chooseInteger{
    _chooseInteger = chooseInteger;
    self.title = [NSString stringWithFormat:@"%@/7",@(self.chooseInteger)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    self.title = [NSString stringWithFormat:@"%@/7",@(self.chooseInteger + 1)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH + 20.0f, SCREEN_HEIGHT - 64.0f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[PhotoChooseCell class] forCellWithReuseIdentifier:@"PhotoChooseCell"];
    [self.view addSubview:self.collectionView];
    
}

- (void)setupLayout {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).offset(20.0f);
        make.height.equalTo(self.view.mas_height);
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoChooseCell" forIndexPath:indexPath];
    cell.photoImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",@(indexPath.row + 1)]];
    WEAK_SELF
    cell.photoChooseBlock = ^{
        STRONG_SELF
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    };
    return cell;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.chooseInteger = (NSInteger)(scrollView.contentOffset.x / (SCREEN_WIDTH + 20.0f)) + 1;
}
@end
