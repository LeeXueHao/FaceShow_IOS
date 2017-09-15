//
//  YXImagePickerController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXImagePickerController : NSObject

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void(^)(UIImage *selectedImage))completion;
@end
