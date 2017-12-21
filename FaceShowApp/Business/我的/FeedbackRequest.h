//
//  FeedbackRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2017/12/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface FeedbackRequest : YXGetRequest
@property (nonatomic, strong) NSString  *content;   //意见反馈内容
@property (nonatomic, strong) NSString  *appId; //产品id: 面授-22
@property (nonatomic, strong) NSString  *sourceId; //具体的模块或者业务id： 面授：1-学员端；2-班主任端
@property (nonatomic, strong) NSString  *platId; //平台id：面授-100

@end
