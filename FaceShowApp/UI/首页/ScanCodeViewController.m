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

#import "BlackAndWhiteThresholdFilter.h"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoDataOutput *_dataoutput;
    AVCaptureVideoPreviewLayer *_preview;
    
    CFAbsoluteTime _lastScanTime;
    CIDetector *_qrDetector;
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
    if (!isEmpty(self.presentingViewController)) {
        [self nyx_setupLeftWithTitle:@"返回" action:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
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
    // qrdetector
    if (!_qrDetector) {
        _qrDetector = [CIDetector detectorOfType: CIDetectorTypeQRCode
                                         context: nil
                                         options: nil];
    }
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_device == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未检测到相机" message:@"请检查相机设备是否正常" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return ;
    }
    
    [_device lockForConfiguration:nil];
    [_device setVideoZoomFactor:1.1];
    [_device setExposureTargetBias:-0.5 completionHandler:nil];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetMedium];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //限制扫描区域（上左下右）
    [ _output setRectOfInterest:CGRectMake(103 * kPhoneHeightRatio / SCREEN_HEIGHT, (SCREEN_WIDTH / 2 - 125) / SCREEN_WIDTH, 250 / SCREEN_HEIGHT, 250 / SCREEN_WIDTH)];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // Preview
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_preview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view.layer insertSublayer:self->_preview atIndex:0];
    });
    
    _dataoutput = [AVCaptureVideoDataOutput new];
    _dataoutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
                                                            forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    
    [_dataoutput setAlwaysDiscardsLateVideoFrames:YES];
    
    if ( [_session canAddOutput:_dataoutput] )
        [_session addOutput:_dataoutput];
    [_session commitConfiguration];
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    [_dataoutput setSampleBufferDelegate:self queue:queue];
    
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
//    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CIImage* input = [CIImage imageWithCVImageBuffer: imageBuffer];
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    if (time - _lastScanTime >= 1) {
        _lastScanTime = time;
        NSString *qrcode = [self stringWithImage:input];
        if (qrcode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dealWithQrcode:qrcode];
            });
        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (CIImage *)change:(CIImage *)input threshold:(CGFloat)threshold {
    [BlackAndWhiteThresholdFilter registerFilter];
    CIImage *output = [CIFilter filterWithName:@"BlackAndWhiteThreshold"
                                 keysAndValues:@"inputImage", input,
                       @"inputThreshold", [NSNumber numberWithFloat:threshold],
                       nil].outputImage;
    return output;
}

- (NSString *)stringWithImage:(CIImage *)img {
    CGFloat threhold = 0.0;
    NSString *ret = nil;
    while ((ret == nil) && (threhold < 1.0)) {
        CIImage *output = [self change:img threshold:threhold];
//        NSArray *arr = [_qrDetector featuresInImage:output];
        for (CIQRCodeFeature *feature in [_qrDetector featuresInImage:output]) {
            ret = feature.messageString;
            break;
        }
        threhold += 0.1;
    }
    
    return ret;
}

- (void)dealWithQrcode:(NSString *)code {
    NSString *stringValue = code;
    printf("%s , %s\n", "我扫到的结果是: ", [stringValue cStringUsingEncoding:kCFStringEncodingUTF8]);
    [_session stopRunning];
    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate distantFuture]];
    
    NSDictionary *parametersDic = [UserSignInHelper getParametersFromUrlString:stringValue];
    if (!isEmpty(parametersDic)) {
        [self.view nyx_startLoading];
        [self.request stopRequest];
        self.request = [[UserSignInRequest alloc] init];
        self.request.stepId = parametersDic[kStepId];
        self.request.timestamp = parametersDic[kTimestamp];
        WEAK_SELF
        [self.request startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error && error.code == 1) {
                [self.view nyx_showToast:error.localizedDescription];
                [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                [self->_session startRunning];
                return;
            }
            UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
            ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
            scanCodeResultVC.currentIndexPath = self.currentIndexPath;
            scanCodeResultVC.data = error ? nil : item.data;
            scanCodeResultVC.error = error ? item.error : nil;
            scanCodeResultVC.reScanCodeBlock = ^{
                [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                [self->_session startRunning];
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
            [self->_session startRunning];
        };
        [self.navigationController pushViewController:scanCodeResultVC animated:YES];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dealWithQrcode:stringValue];
    });
}


@end
