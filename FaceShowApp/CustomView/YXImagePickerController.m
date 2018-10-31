//
//  YXImagePickerController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "UIImage+YXImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YXImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage);
@property (nonatomic, assign) BOOL isPublish;

@end

@implementation YXImagePickerController
- (void)dealloc {
    DDLogDebug(@"release========>>%@",[self class]);
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *))completion
{
    
    self.isPublish = NO;
    UIViewController *viewController = [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController nyx_visibleViewController];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                [viewController.view nyx_showToast:@"相册权限受限\n请在设置-隐私-相册中开启"];
                return;
            }
        }else if(sourceType == UIImagePickerControllerSourceTypeCamera){
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
                [viewController.view nyx_showToast:@"相机权限受限\n请在设置-隐私-相册中开启"];
                return;
            }
        }
        self.imagePickerController.sourceType = sourceType;
        self.completion = completion;
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [viewController.view nyx_showToast:@"设备不支持拍照功能!"];
    }
}


- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = self.canEdit;
    }
    return _imagePickerController;
}

#pragma mark -

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image
{
    if (picker) {
        WEAK_SELF
        [picker dismissViewControllerAnimated:YES completion:^{
            STRONG_SELF
            if (image && self.completion) {
                self.completion(image);
            }
        }];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.canEdit) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }

    [self completionImagePick:picker image:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self completionImagePick:picker image:nil];
}

- (CGSize)getImageSizeWithImage:(UIImage *)image
{
    CGSize gSize;
    CGSize size = image.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    gSize.width = screenSize.width * [UIScreen mainScreen].scale;
    gSize.height = gSize.width/(size.width/size.height);
    return gSize;
}

@end
