//
//  NBBaseViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "GetClassConfigRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NBBaseViewController : BaseViewController
@property (nonatomic, strong) NSArray<GetClassConfigRequest_Item_tabConf,Optional> *tabConf;
@property (nonatomic, strong) GetClassConfigRequest_Item_pageConf<Optional> *pageConf;
@end

NS_ASSUME_NONNULL_END
