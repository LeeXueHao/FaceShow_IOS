//
//  AlbumListCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumListCell : UITableViewCell
@property (nonatomic, strong) PHAssetCollection *collection;
@end
