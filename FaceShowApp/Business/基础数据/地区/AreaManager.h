//
//  AreaManager.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Area<NSObject>
@end
@interface Area:JSONModel
@property (nonatomic, strong) NSString<Optional> *areaID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<Area,Optional> *sub;
@end

@interface AreaModel:JSONModel
@property (nonatomic, strong) NSArray<Area,Optional> *data;
@end

@interface AreaManager : NSObject
+ (AreaManager *)sharedInstance;

@property (nonatomic, strong) AreaModel *areaModel;

- (void)updateWithLatestVersion:(NSString *)version url:(NSString *)url;
@end
