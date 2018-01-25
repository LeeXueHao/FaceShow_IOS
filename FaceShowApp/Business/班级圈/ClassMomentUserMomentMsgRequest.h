//
//  ClassMomentUserMomentMsgRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ClassMomentUserMomentMsgItem_Data_Msg_MomentSimple : JSONModel
@property (nonatomic, copy) NSString<Optional> *momentId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *image;
@end

@protocol ClassMomentUserMomentMsgItem_Data_Msg @end
@interface ClassMomentUserMomentMsgItem_Data_Msg : JSONModel
@property (nonatomic, copy) NSString<Optional> *momentId;
@property (nonatomic, copy) NSString<Optional> *msgType;
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *comment;
@property (nonatomic, copy) NSString<Optional> *like;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) ClassMomentUserMomentMsgItem_Data_Msg_MomentSimple<Optional> *momentSimple;
@end


@interface ClassMomentUserMomentMsgItem_Data : JSONModel
@property (nonatomic, strong) NSArray<ClassMomentUserMomentMsgItem_Data_Msg, Optional> *msgs;
@end

@interface ClassMomentUserMomentMsgItem : HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentUserMomentMsgItem_Data<Optional> *data;

@end
@interface ClassMomentUserMomentMsgRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;

@end
