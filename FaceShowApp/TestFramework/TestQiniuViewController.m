//
//  TestQiniuViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TestQiniuViewController.h"
#import "QiniuTokenRequest.h"
#import <QNUploadManager.h>
#import "QiniuDataManager.h"

@interface TestQiniuViewController ()
@property (nonatomic, strong) QiniuTokenRequest *request;
@property (nonatomic, strong) QNUploadManager *upManager;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TestQiniuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *tokenButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 80, 50)];
    [tokenButton setTitle:@"token" forState:UIControlStateNormal];
    tokenButton.backgroundColor = [UIColor redColor];
    [tokenButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tokenButton];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150, 100, 50)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    self.imageView = imgView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)upload {
    
    UIImage *img = [UIImage imageNamed:@"背景图片-首页"];
    NSData *data = UIImageJPEGRepresentation(img, 1);
    
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:nil completeBlock:^(NSString *key, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        NSString *oriStr = [NSString stringWithFormat:@"http://yanxiuugcpic.jsyxw.cn/%@",key];
        NSString *resize = [QiniuDataManager resizedUrlStringWithOriString:oriStr maxLongEdge:200];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:resize]];
    }];
    
}


@end
