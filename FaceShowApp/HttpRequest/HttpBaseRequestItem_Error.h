//
//  HttpBaseRequestItem_Error.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HttpBaseRequestItem_Error_UserSignIn : JSONModel
@property (nonatomic, strong) NSString<Optional> *signinTime;
@end

@interface HttpBaseRequestItem_Error_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) HttpBaseRequestItem_Error_UserSignIn<Optional> *userSignIn;
@end

@interface HttpBaseRequestItem_Error : JSONModel
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) HttpBaseRequestItem_Error_Data<Optional> *data;
@end
