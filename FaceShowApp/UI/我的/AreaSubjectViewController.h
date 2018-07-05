//
//  AreaSubjectViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "AreaManager.h"
@interface AreaSubjectItem: NSObject
@property (nonatomic, strong) NSString *chooseId;
@property (nonatomic, strong) NSString *chooseName;
@end

typedef NS_ENUM(NSInteger, AreaSubjectStatus) {
    AreaSubject_Province,
    AreaSubject_city,
    AreaSubject_country
};
@interface AreaSubjectViewController : BaseViewController
@property (nonatomic, strong) NSArray<Area,Optional> *dataArray;
@property (nonatomic, assign) AreaSubjectStatus status;
@property (nonatomic, strong) AreaSubjectItem *provinceItem;
@property (nonatomic, strong) AreaSubjectItem *cityItem;
@property (nonatomic, strong) AreaSubjectItem *countryItem;
@property (nonatomic, copy) void (^completeBlock)(void);

@end
