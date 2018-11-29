//
//  ResourceCell.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetResourceListRequest.h"

@interface ResourceCell : UITableViewCell
@property (nonatomic, strong) GetResourceListRequestItem_tagList *tagList;
@property (nonatomic, strong) GetResourceListRequestItem_resList *resList;
@end
