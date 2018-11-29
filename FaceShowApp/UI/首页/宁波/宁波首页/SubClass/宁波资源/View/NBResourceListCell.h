//
//  NBResourceListCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetResourceListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NBResourceListCell : UITableViewCell
@property (nonatomic, strong) GetResourceListRequestItem_tagList *tagList;
@property (nonatomic, strong) GetResourceListRequestItem_resList *resList;
@end

NS_ASSUME_NONNULL_END
