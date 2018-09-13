//
//  ScanPCCodeViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScanPCCodeViewController.h"
#import "ScanPCCodeResultViewController.h"
#import "ScanPCLoginCodeRequest.h"

@interface ScanPCCodeViewController ()
@property (nonatomic, strong) ScanPCLoginCodeRequest *request;
@end

@implementation ScanPCCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫码登录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealWithQrcode:(NSString *)code {
    NSString *stringValue = code;
    printf("%s , %s\n", "我扫到的结果是: ", [stringValue cStringUsingEncoding:kCFStringEncodingUTF8]);

    if ([stringValue containsString:@"uc/loginByCode"]) {
        [self.view nyx_startLoading];
        [self.request stopRequest];
        self.request = [[ScanPCLoginCodeRequest alloc]init];
        self.request.url = stringValue;
        WEAK_SELF
        [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            ScanPCCodeResultViewController *vc = [[ScanPCCodeResultViewController alloc]init];
            vc.error = error;
            WEAK_SELF
            [vc setReScanCodeBlock:^{
                STRONG_SELF
                [self resumeScanning];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else {
        [self.view.window nyx_showToast:@"非登录二维码，请确认后重新扫码"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
