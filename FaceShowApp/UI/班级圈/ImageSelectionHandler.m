//
//  ImageSelectionHandler.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ImageSelectionHandler.h"
#import "UIViewController+VisibleViewController.h"
#import "YXImagePickerController.h"
#import "AlbumListViewController.h"
#import "PhotoBrowserController.h"
#import <Photos/Photos.h>

@interface ImageSelectionHandler()
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) void(^completeBlock)(NSArray *array);
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@end

@implementation ImageSelectionHandler
- (void)pickImageWithMaxCount:(NSInteger)maxCount completeBlock:(void(^)(NSArray *array))completeBlock{
    self.maxCount = maxCount;
    self.completeBlock = completeBlock;
    [self showAlertView];
}

- (void)showAlertView {
    UIViewController *visibleVC = [[UIApplication sharedApplication].keyWindow.rootViewController nyx_visibleViewController];
    [visibleVC.view endEditing:YES];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
    }];
    [alertVC addAction:cancleAction];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
            STRONG_SELF
            BLOCK_EXEC(self.completeBlock,@[selectedImage]);
        }];
    }];
    [alertVC addAction:cameraAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                STRONG_SELF
                AlbumListViewController *vc = [[AlbumListViewController alloc]init];
                vc.maxCount = self.maxCount;
                WEAK_SELF
                [vc setCompleteBlock:^(NSArray *imageArray) {
                    STRONG_SELF
                    BLOCK_EXEC(self.completeBlock,imageArray);
                }];
                FSNavigationController *navi = [[FSNavigationController alloc]initWithRootViewController:vc];
                [visibleVC presentViewController:navi animated:YES completion:nil];
            }else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                [self showAlertWithTitle:@"照片访问权限被禁用，请到设置中允许研修宝访问照片" rootVC:visibleVC];
            }
            
        }];
    }];
    [alertVC addAction:photoAction];    
    [visibleVC presentViewController:alertVC animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title rootVC:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:edit];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}

- (void)browseImageWithArray:(NSMutableArray *)imageArray index:(NSInteger)index deleteBlock:(void(^)(NSInteger index))deleteBlock {
    PhotoBrowserController *vc = [[PhotoBrowserController alloc] init];
    vc.images = imageArray;
    vc.currentIndex = index;
    WEAK_SELF
    vc.deleteImageBlock = ^(NSInteger index){
        STRONG_SELF
        BLOCK_EXEC(deleteBlock,index);
    };
    UIViewController *visibleVC = [[UIApplication sharedApplication].keyWindow.rootViewController nyx_visibleViewController];
    [visibleVC.navigationController pushViewController:vc animated:YES];
}

@end
