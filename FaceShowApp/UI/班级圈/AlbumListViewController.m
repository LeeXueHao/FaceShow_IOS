//
//  AlbumListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AlbumListViewController.h"
#import <Photos/Photos.h>
#import "AlbumListCell.h"
#import "PhotoListViewController.h"

@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"照片";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"取消" action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self loadCollections];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCollections {
    self.collectionArray = [NSMutableArray array];
    PHFetchResult *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in results) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
            [self.collectionArray insertObject:collection atIndex:0];
        }else if (collection.assetCollectionSubtype!=PHAssetCollectionSubtypeSmartAlbumVideos && collection.assetCollectionSubtype!=PHAssetCollectionSubtypeSmartAlbumSlomoVideos) {
            [self.collectionArray addObject:collection];
        }
    }
    results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in results) {
        [self.collectionArray addObject:collection];
    }
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[AlbumListCell class] forCellReuseIdentifier:@"AlbumListCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumListCell"];
    cell.collection = self.collectionArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListViewController *vc = [[PhotoListViewController alloc]init];
    vc.collection = self.collectionArray[indexPath.row];
    vc.maxCount = self.maxCount;
    vc.completeBlock = self.completeBlock;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
