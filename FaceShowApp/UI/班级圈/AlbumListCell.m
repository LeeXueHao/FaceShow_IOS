//
//  AlbumListCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AlbumListCell.h"

@interface AlbumListCell()
@property (nonatomic, strong) UIImageView *collectionImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation AlbumListCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮点击态"];
    }
    else{
        self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.collectionImageView = [[UIImageView alloc]init];
    self.collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.collectionImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.collectionImageView];
    [self.collectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(0);
    }];
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (assetsFetchResults.count==0) {
        self.collectionImageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"ebeff2"]];
    }else {
        PHAsset *asset = assetsFetchResults[0];
        CGSize size = CGSizeMake(120, 120);
        WEAK_SELF
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            STRONG_SELF
            self.collectionImageView.image = result;
        }];
    }
    NSString *countStr = [NSString stringWithFormat:@"(%@)",@(assetsFetchResults.count)];
    NSString *totalStr = [NSString stringWithFormat:@"%@   %@",collection.localizedTitle,countStr];
    NSRange range = [totalStr rangeOfString:countStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:range];
    self.nameLabel.attributedText = attrStr;
}

@end
