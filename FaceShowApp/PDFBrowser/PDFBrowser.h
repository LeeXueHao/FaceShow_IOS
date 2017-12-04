//
//  PDFBrowser.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFBrowser : NSObject
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) UIViewController *baseViewController;

- (void)browseFile;
@end
