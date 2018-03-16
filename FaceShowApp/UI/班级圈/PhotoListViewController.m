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
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
        } else {
            make.bottom.mas_equalTo(-50);
        }
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
    [self.view nyx_startLoading];
    dispatch_group_t group = dispatch_group_create();
    for (PhotoItem *item in self.assetArray) {
        if (item.selected) {
            dispatch_group_enter(group);
            CGSize size = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = NO;
            options.networkAccessAllowed = YES;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            WEAK_SELF
            [[PHCachingImageManager defaultManager] requestImageForAsset:item.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                STRONG_SELF
                item.image = result;
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.view nyx_stopLoading];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = YES"];
        NSArray *selectedArray = [self.assetArray filteredArrayUsingPredicate:predicate];
        selectedArray = [selectedArray sortedArrayUsingComparator:^NSComparisonResult(PhotoItem *  _Nonnull obj1, PhotoItem *  _Nonnull obj2) {
            return obj1.selectedIndex > obj2.selectedIndex;
        }];
        NSMutableArray *array = [NSMutableArray array];
        for (PhotoItem *item in selectedArray) {
            [array addObject:item.image];
        }
        BLOCK_EXEC(self.completeBlock,array);
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
            [self showReachMaxAlert];
            return;
        }
        item.selected = !item.selected;
        [self refreshUIWithItem:item];
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

- (void)refreshUIWithItem:(PhotoItem *)item {
    NSInteger count = [self countOfSelectedPhotos];
    if (item.selected) {
        item.selectedIndex = count;
    }else {
        for (PhotoItem *pItem in self.assetArray) {
            if (pItem.selected && pItem.selectedIndex>item.selectedIndex) {
                pItem.selectedIndex--;
            }
        }
    }

    for (PhotoItem *item in self.assetArray) {
        item.canSelect = YES;
    }
    if (count == self.maxCount) {
        for (PhotoItem *item in self.assetArray) {
            item.canSelect = item.selected;
        }
    }
    [self.collectionView reloadData];
    
    if (count == 0) {
        [self disableDoneButton];
    }else {
        [self enableDoneButton];
    }
}

- (void)showReachMaxAlert {
    NSString *title = [NSString stringWithFormat:@"你最多只能选择%@张照片",@(self.maxCount)];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
