//
//  UpdateUserInfoRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateUserInfoRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *school;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *userId;


@property (nonatomic, strong) NSString<Optional> *mobilePhone;//手机号
@property (nonatomic, strong) NSString<Optional> *idCard;    //身份证
@property (nonatomic, strong) NSString<Optional> *province;//    否    省
@property (nonatomic, strong) NSString<Optional> *city;//    否    市
@property (nonatomic, strong) NSString<Optional> *country;//    否    区县
@property (nonatomic, strong) NSString<Optional> *area;//    否    区域
@property (nonatomic, strong) NSString<Optional> *schoolType;//    否    学校类型
@property (nonatomic, strong) NSString<Optional> *nation;//    否    民族

@property (nonatomic, strong) NSString<Optional> *recordeducation;//    否    学历
@property (nonatomic, strong) NSString<Optional> *graduation;//    否    毕业院校
@property (nonatomic, strong) NSString<Optional> *professional;//    否    专业
@property (nonatomic, strong) NSString<Optional> *title;//    否    职称
@property (nonatomic, strong) NSString<Optional> *childprojectId;//    否    子项目编号
@property (nonatomic, strong) NSString<Optional> *childprojectName;//    否    子项目名称
@property (nonatomic, strong) NSString<Optional> *organizer;//    否    承办单位
@property (nonatomic, strong) NSString<Optional> *job;//    否    职务
@property (nonatomic, strong) NSString<Optional> *telephone;//    否    电话
@property (nonatomic, strong) NSString<Optional> *remarks;//    否    备注
@property (nonatomic, strong) NSString<Optional> *email;//    否邮件

@end
