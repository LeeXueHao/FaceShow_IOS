//
//  GroupDetailByStudentRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GroupDetailByStudentRequest_Item_students <NSObject> @end
@interface GroupDetailByStudentRequest_Item_students : JSONModel
@property (nonatomic, strong) NSString<Optional> *school;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *clazsUserStatus;
@property (nonatomic, strong) NSString<Optional> *userScore;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *userType;
@property (nonatomic, strong) NSString<Optional> *email;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *signInRate;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *studentsId;
@property (nonatomic, strong) NSString<Optional> *showName;
@property (nonatomic, strong) NSString<Optional> *subject;
@end

@interface GroupDetailByStudentRequest_Item_group : JSONModel
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *leaderId;
@property (nonatomic, strong) NSString<Optional> *groupAvatar;
@property (nonatomic, strong) NSString<Optional> *avgScore;
@property (nonatomic, strong) NSArray<GroupDetailByStudentRequest_Item_students,Optional> *students;
@property (nonatomic, strong) GroupDetailByStudentRequest_Item_students<Optional> *leader;
@property (nonatomic, strong) NSString<Optional> *groupName;
@property (nonatomic, strong) NSString<Optional> *scoreRank;
@property (nonatomic, strong) NSString<Optional> *signinRank;
@property (nonatomic, strong) NSString<Optional> *slogan;
@property (nonatomic, strong) NSString<Optional> *signinRate;
@property (nonatomic, strong) NSString<Optional> *groupId;
@end

@interface GroupDetailByStudentRequest_Item_data : JSONModel
@property (nonatomic, strong) GroupDetailByStudentRequest_Item_group<Optional> *group;
@end

@interface GroupDetailByStudentRequest_Item : HttpBaseRequestItem
@property (nonatomic, strong) GroupDetailByStudentRequest_Item_data<Optional> *data;
@end

@interface GroupDetailByStudentRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *groupId;
@end
