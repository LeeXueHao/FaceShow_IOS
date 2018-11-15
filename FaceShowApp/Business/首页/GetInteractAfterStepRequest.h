//
//  GetInteractAfterStepRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetInteractAfterStepRequestItem_afterSteps <NSObject> @end
@interface GetInteractAfterStepRequestItem_afterSteps : JSONModel
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *afterStepsId;
@property (nonatomic, strong) NSString<Optional> *stepType;
@property (nonatomic, strong) NSString<Optional> *processMode;
@end

@interface GetInteractAfterStepRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetInteractAfterStepRequestItem_afterSteps,Optional> *afterSteps;
@end

@interface GetInteractAfterStepRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetInteractAfterStepRequestItem_data<Optional> *data;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GetInteractAfterStepRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@end

NS_ASSUME_NONNULL_END
