//
//  ResourceCell.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetResourceRequest.h"

@interface ResourceCell : UITableViewCell
@property (nonatomic, strong) GetResourceRequestItem_Element *element;
@property (nonatomic, copy) void(^downloadBlock)(NSString *resId);
@end
