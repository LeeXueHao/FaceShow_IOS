//
//  ScanCodeViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeMaskView.h"
#import "ScanCodeResultViewController.h"
#import "UserSignInRequest.h"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_preview;
}

@property (nonatomic, strong) ScanCodeMaskView *scanCodeMaskView;
@property (nonatomic, strong) UserSignInRequest *request;
@end

@implementation ScanCodeViewController

- (void)dealloc {
    DDLogDebug(@"release=====>%@",[self class]);
    if (self.scanCodeMaskView.scanTimer) {
        [self.scanCodeMaskView.scanTimer invalidate];
    }
    if (_session) {
        [_session stopRunning];
        _session = nil;
    }
    if (_preview) {
        [_preview removeFromSuperlayer];
        _preview = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"签到";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [self showAlertView];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        if (!self->_session) {
                            [self setupCamera];
                        } else {
                            [self->_session startRunning];
                        }
                    });
                } else {
                    [self showAlertView];
                }
            });
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!self->_session) {
                [self setupCamera];
            } else{
                [self->_session startRunning];
            }
        });
    } else {
        [self backAction];
    }
    self.scanCodeMaskView = [[ScanCodeMaskView alloc] init];
    [self.view addSubview:self.scanCodeMaskView];
    self.scanCodeMaskView.backgroundColor = [UIColor clearColor];
    [self.scanCodeMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到“设置->隐私->相机”中设置为允许访问相机！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setupCamera {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_device == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未检测到相机" message:@"请检查相机设备是否正常" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return ;
    }
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //限制扫描区域（上左下右）
    [ _output setRectOfInterest:CGRectMake(103 * kPhoneHeightRatio / SCREEN_HEIGHT, (SCREEN_WIDTH / 2 - 125) / SCREEN_WIDTH, 250 / SCREEN_HEIGHT, 250 / SCREEN_WIDTH)];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // Preview
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_preview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view.layer insertSublayer:self->_preview atIndex:0];
    });
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate distantFuture]];
    if ([stringValue containsString:@"stepId="] && !isEmpty([stringValue substringFromIndex:7])) {
        [self.view nyx_startLoading];
        [self.request stopRequest];
        self.request = [[UserSignInRequest alloc] init];
        NSArray *array = [stringValue componentsSeparatedByString:@"&"];
        NSString *step = array.firstObject;
        self.request.stepId = [step substringFromIndex:7];
        if ([stringValue containsString:@"timestamp="]) {
            NSString *timestamp = array[1];
            self.request.timestamp = [timestamp substringFromIndex:10];
        }
        WEAK_SELF
        [self.request startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error && error.code == 1) {
                [self.view nyx_showToast:error.localizedDescription];
                [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                [_session startRunning];
                return;
            }
            UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
            ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
            scanCodeResultVC.currentIndexPath = self.currentIndexPath;
            scanCodeResultVC.data = error ? nil : item.data;
            scanCodeResultVC.error = error ? item.error : nil;
            scanCodeResultVC.reScanCodeBlock = ^{
                [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                [_session startRunning];
            };
            [self.navigationController pushViewController:scanCodeResultVC animated:YES];
        }];
    } else {
        ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
        scanCodeResultVC.currentIndexPath = self.currentIndexPath;
        HttpBaseRequestItem_Error *error = [HttpBaseRequestItem_Error new];
        error.message = @"无效二维码";
        scanCodeResultVC.error = error;
        scanCodeResultVC.reScanCodeBlock = ^{
            [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
            [_session startRunning];
        };
        [self.navigationController pushViewController:scanCodeResultVC animated:YES];
    }
}

@end
