//
//  ScoreRankingCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetClazsSocresRequestItem_element;

@interface ScoreRankingCellItem : NSObject
@property (nonatomic, strong) GetClazsSocresRequestItem_element *element;
@property(nonatomic, assign) NSInteger rank;
@end

@interface ScoreRankingCell : UITableViewCell
@property(nonatomic, strong) ScoreRankingCellItem *item;
@property(nonatomic, assign) BOOL isShowLine;
@end
