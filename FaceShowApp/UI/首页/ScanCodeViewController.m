//
//  ScanCodeViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeResultViewController.h"
#import "UserSignInRequest.h"
#import "ClassCodeItem.h"
#import "BlackAndWhiteThresholdFilter.h"
#import "VerifyPhoneViewController.h"
#import "ScanCodeMaskView.h"
#import "ScanClazsCodeRequest.h"
#import "MessagePromptView.h"
#import "AlertView.h"
#import "GetStudentClazsRequest.h"
#import "SignInPlaceViewController.h"
#import "UIButton+ExpandHitArea.h"

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
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UserSignInRequest *request;
@property (nonatomic, strong) ScanClazsCodeRequest *clazsCodeRequest;
@property (nonatomic, strong) GetStudentClazsRequest *clazsRefreshRequest;
@property (nonatomic, strong) ClassCodeItem *classCodeItem;
@property (nonatomic, strong) ScanCodeMaskView *scanCodeMaskView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) UIButton *signInPlaceButton;
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
    self.scanCodeMaskView.prompt = self.prompt;
    [self.view addSubview:self.scanCodeMaskView];
    self.scanCodeMaskView.backgroundColor = [UIColor clearColor];
    [self.scanCodeMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    UIButton *signInPlaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInPlaceButton = signInPlaceButton;
    [signInPlaceButton setImage:[UIImage imageNamed:@"位置签到"] forState:UIControlStateNormal];
    signInPlaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    signInPlaceButton.titleLabel.textColor = [UIColor colorWithHexString:@"a6b0bf"];
    [signInPlaceButton setTitle:@"位置签到" forState:UIControlStateNormal];
    CGSize size = [signInPlaceButton.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [signInPlaceButton setImageEdgeInsets:UIEdgeInsetsMake(-7 - size.height, size.width/2, 7 + size.height, -size.width/2)];
    [signInPlaceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15,0, 15)];
    [signInPlaceButton setHitTestEdgeInsets:UIEdgeInsetsMake(-30, -30, -30, -30)];
    WEAK_SELF
    [[signInPlaceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        SignInPlaceViewController *vc = [[SignInPlaceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:signInPlaceButton];
    [signInPlaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-20);
        } else {
            make.bottom.mas_equalTo(-20);
        }
        make.centerX.mas_equalTo(0);
    }];
    if (self.isShowSignInPlace) {
        self.signInPlaceButton.hidden = NO;
    }else {
        self.signInPlaceButton.hidden = YES;
    }
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
    [_device setVideoZoomFactor:MIN(1.1, _device.activeFormat.videoMaxZoomFactor)];
    [_device setExposureTargetBias:-0.5 completionHandler:nil];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
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
                [self.session stopRunning];
                [self.scanCodeMaskView.scanTimer setFireDate:[NSDate distantFuture]];
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

- (void)resumeScanning {
    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
    [self->_session startRunning];
}

- (void)dealWithQrcode:(NSString *)code {
    NSString *stringValue = code;
    printf("%s , %s\n", "我扫到的结果是: ", [stringValue cStringUsingEncoding:kCFStringEncodingUTF8]);
    NSDictionary *parametersDic = [UserSignInHelper getParametersFromUrlString:stringValue];
    if (!isEmpty(parametersDic)) {
        if (![UserManager sharedInstance].loginStatus) {
            [self.view.window nyx_showToast:@"请先登录后再签到"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
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
    }else if ([stringValue containsString:@"method=clazs.scanClazsCode"]) {
        [self.view nyx_startLoading];
        [self.clazsCodeRequest stopRequest];
        self.clazsCodeRequest = [[ScanClazsCodeRequest alloc]init];
        self.clazsCodeRequest.url = stringValue;
        WEAK_SELF
        [self.clazsCodeRequest startRequestWithRetClass:[ClassCodeItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (![UserManager sharedInstance].loginStatus) {
                if (error) {
                    [self.view nyx_showToast:error.localizedDescription];
                    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                    [self->_session startRunning];
                    return;
                }
                ClassCodeItem *item = (ClassCodeItem *)retItem;
                VerifyPhoneViewController *vc = [[VerifyPhoneViewController alloc]init];
                vc.classID = item.data.clazsId;
                WEAK_SELF
                vc.reScanCodeBlock = ^{
                    STRONG_SELF
                    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                    [self->_session startRunning];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                if (!retItem) {
                    [self.view nyx_showToast:error.localizedDescription];
                    [self.scanCodeMaskView.scanTimer setFireDate:[NSDate date]];
                    [self->_session startRunning];
                    return;
                }
                self.classCodeItem = retItem;
                if (error) {
                    NSArray *paraStrings = [[stringValue componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
                    for (NSString *paraString in paraStrings) {
                        NSString *name = [paraString componentsSeparatedByString:@"="].firstObject;
                        NSString *value = [paraString componentsSeparatedByString:@"="].lastObject;
                        if ([name isEqualToString:@"clazsId"]) {
                            ClassCodeItem_data *data = [[ClassCodeItem_data alloc]init];
                            data.clazsId = value;
                            self.classCodeItem.data = data;
                            break;
                        }
                    }
                    [self showAlertWithMessage:error.localizedDescription];
                }else {
                    [self showAlertWithMessage:[NSString stringWithFormat:@"成功加入【%@】",self.classCodeItem.data.clazsInfo.clazsName]];
                }
            }
        }];
    }else {
        if (![stringValue containsString:@"2bai.co"] && ![stringValue containsString:@"yxb.yanxiu.com"]) {
            [self.view.window nyx_showToast:@"无效二维码"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.session stopRunning];
        [self.scanCodeMaskView.scanTimer setFireDate:[NSDate distantFuture]];
        [self dealWithQrcode:stringValue];
    });
}

- (void)showAlertWithMessage:(NSString *)message {
    MessagePromptView *promptView = [[MessagePromptView alloc]init];
    promptView.layer.cornerRadius = 7;
    promptView.clipsToBounds = YES;
    promptView.message = message;
    WEAK_SELF
    [promptView setConfirmBlock:^{
        STRONG_SELF
        [self.alertView hide];
        [self updateClazsInfo];
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor colorWithHexString:@"333333"]colorWithAlphaComponent:.6];
    self.alertView.contentView = promptView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
        }];
    }];
}

- (void)updateClazsInfo {
    [self.clazsRefreshRequest stopRequest];
    self.clazsRefreshRequest = [[GetStudentClazsRequest alloc] init];
    self.clazsRefreshRequest.clazsId = self.classCodeItem.data.clazsId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.clazsRefreshRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        GetCurrentClazsRequestItem *item = retItem;
        [UserManager sharedInstance].userModel.projectClassInfo = item;
        [[UserManager sharedInstance]saveData];
        [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
    }];
}

- (void)setIsHideSignInLocBtn:(BOOL)isShowSignInPlace {
    _isShowSignInPlace = isShowSignInPlace;
    if (isShowSignInPlace) {
        self.signInPlaceButton.hidden = NO;
    }else {
        self.signInPlaceButton.hidden = YES;
    }
}
@end
