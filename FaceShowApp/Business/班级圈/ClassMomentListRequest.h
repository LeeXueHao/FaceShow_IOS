//
//  ClassMomentListRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ClassMomentListRequestItem_UserInfo : JSONModel
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *avatar;
@end
@protocol ClassMomentListRequestItem_Data_Moment_Like <NSObject>

@end
@interface ClassMomentListRequestItem_Data_Moment_Like : JSONModel
@property (nonatomic, copy) NSString<Optional> *likeID;
@property (nonatomic, copy) NSString<Optional> *clazsID;
@property (nonatomic, copy) NSString<Optional> *momentID;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, strong) ClassMomentListRequestItem_UserInfo<Optional> *publisher;

@end

@protocol ClassMomentListRequestItem_Data_Moment_Comment <NSObject>
@end
@interface ClassMomentListRequestItem_Data_Moment_Comment : JSONModel
@property (nonatomic, copy) NSString<Optional> *commentID;
@property (nonatomic, copy) NSString<Optional> *clazsID;
@property (nonatomic, copy) NSString<Optional> *momentID;
@property (nonatomic, copy) NSString<Optional> *parentID;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *level;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, strong) ClassMomentListRequestItem_UserInfo<Optional> *publisher;
@property (nonatomic, strong) ClassMomentListRequestItem_UserInfo<Optional> *toUser;
@end

@interface ClassMomentListRequestItem_Data_Moment_Album_Attachment : JSONModel
@property (nonatomic, copy) NSString<Optional> *resID;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *resType;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *resThumb;
@end

@protocol ClassMomentListRequestItem_Data_Moment_Album <NSObject>
@end
@interface ClassMomentListRequestItem_Data_Moment_Album :JSONModel
@property (nonatomic, copy) NSString<Optional> *albumID;
@property (nonatomic, copy) NSString<Optional> *momentID;
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment_Album_Attachment<Optional> *attachment;
@end

@protocol ClassMomentListRequestItem_Data_Moment <NSObject>


@end
@interface ClassMomentListRequestItem_Data_Moment : JSONModel
@property (nonatomic, copy) NSString<Optional> *momentID;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *clazsID;
@property (nonatomic, copy) NSString<Optional> *commentedNum;//评论数，包括一级评论和回复
@property (nonatomic, copy) NSString<Optional> *publishTime;//发布时间
@property (nonatomic, copy) NSString<Optional> *publishTimeDesc;//发布时间
@property (nonatomic, strong) NSMutableArray<ClassMomentListRequestItem_Data_Moment_Album,Optional> *albums;
@property (nonatomic, strong) NSMutableArray<ClassMomentListRequestItem_Data_Moment_Comment,Optional> *comments;
@property (nonatomic, strong) NSMutableArray<ClassMomentListRequestItem_Data_Moment_Like,Optional> *likes;
@property (nonatomic, strong) ClassMomentListRequestItem_UserInfo<Optional> *publisher;
@property (nonatomic, copy) NSString<Optional> *isOpen;//自定义展开折叠使用 0 折叠 1展开
@property (nonatomic, copy) NSString<Optional> *draftModel;
@end


@interface ClassMomentListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSMutableArray<ClassMomentListRequestItem_Data_Moment,Optional> *moments;
@property (nonatomic, copy) NSString<Optional> *hasNextPage;
@end

@interface ClassMomentListRequestItem : HttpBaseRequestItem
@property(nonatomic, strong) ClassMomentListRequestItem_Data<Optional> *data;
@end
@interface ClassMomentListRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *limit;
@property (nonatomic, copy) NSString<Optional> *offset;
@end
