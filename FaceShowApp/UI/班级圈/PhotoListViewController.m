//
//  PhotoListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoCell.h"

@interface PhotoListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.collection.localizedTitle;
    [self loadAssetsFromCollection:self.collection];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAssetsFromCollection:(PHAssetCollection *)collection {
    self.assetArray = [NSMutableArray array];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset *asset in assetsFetchResults) {
        PhotoItem *item = [[PhotoItem alloc]init];
        item.asset = asset;
        [self.assetArray addObject:item];
    }
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    CGFloat width = (self.view.width-5*5)/4;
    layout.itemSize = CGSizeMake(width, width);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e5e9ec"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.doneButton = [[UIButton alloc]init];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.layer.cornerRadius = 7;
    self.doneButton.layer.borderWidth = 2;
    self.doneButton.clipsToBounds = YES;
    [self.view addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self disableDoneButton];
}

- (void)enableDoneButton {
    self.doneButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    [self.doneButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    self.doneButton.userInteractionEnabled = YES;
}

- (void)disableDoneButton {
    self.doneButton.layer.borderColor = [UIColor colorWithHexString:@"a6abad"].CGColor;
    [self.doneButton setTitleColor:[UIColor colorWithHexString:@"a6abad"] forState:UIControlStateNormal];
    self.doneButton.userInteractionEnabled = NO;
}

- (void)doneAction {
    NSMutableArray *array = [NSMutableArray array];
    for (PhotoItem *item in self.assetArray) {
        if (item.selected) {
            CGSize size = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            WEAK_SELF
            [[PHCachingImageManager defaultManager] requestImageForAsset:item.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                STRONG_SELF
                [array addObject:result];
            }];
        }
    }
    BLOCK_EXEC(self.completeBlock,array);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    PhotoItem *item = self.assetArray[indexPath.row];
    cell.photoItem = item;
    WEAK_SELF
    [cell setClickBlock:^{
        STRONG_SELF
        if ([self countOfSelectedPhotos] == self.maxCount && item.selected == NO) {
            return;
        }
        item.selected = !item.selected;
        [self refreshUI];
    }];
    return cell;
}

- (NSInteger)countOfSelectedPhotos {
    NSInteger count = 0;
    for (PhotoItem *item in self.assetArray) {
        if (item.selected) {
            count++;
        }
    }
    return count;
}

- (void)refreshUI {
    NSInteger index = 1;
    for (PhotoItem *item in self.assetArray) {
        if (item.selected) {
            item.selectedIndex = index;
            index++;
        }
    }
    [self.collectionView reloadData];
    
    if (index == 1) {
        [self disableDoneButton];
    }else {
        [self enableDoneButton];
    }
}
@end
