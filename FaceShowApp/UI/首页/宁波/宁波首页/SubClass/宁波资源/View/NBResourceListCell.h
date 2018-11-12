//
//  NBResourceListCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBGetResourceListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NBResourceListCell : UITableViewCell
@property (nonatomic, strong) NBGetResourceListRequestItem_tagList *tagList;
@property (nonatomic, strong) NBGetResourceListRequestItem_resList *resList;
@end

NS_ASSUME_NONNULL_END
