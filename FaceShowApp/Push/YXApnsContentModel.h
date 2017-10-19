//
//  YXApnsContentModel.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 10/9/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

//定义详见 http://wiki.yanxiu.com/pages/viewpage.action?pageId=12324155

@interface YXApnsContentModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *objectId;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *title;
@end
