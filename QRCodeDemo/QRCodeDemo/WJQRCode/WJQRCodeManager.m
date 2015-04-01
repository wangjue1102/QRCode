//
//  WJQRCodeManager.m
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import "WJQRCodeManager.h"
#import "WJQRCodeView.h"
#import "WJCameraDevice.h"

@interface WJQRCodeManager ()<AVCaptureMetadataOutputObjectsDelegate>
{
    dispatch_queue_t _captureQueue;
}
@property (nonatomic, weak) WJQRCodeView *qrCodeView;
@property (nonatomic, weak) QRCodeSurfaceView *surfaceView;
@property (nonatomic, strong) WJCameraDevice *cameraDevice;
@property (nonatomic, strong) NSString *sessionPreset;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *captureMetaDataOutput;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, assign) CMVideoDimensions outputDataDimesions;//输出数据的尺寸
@end

@implementation WJQRCodeManager
- (instancetype)init
{
    return [self initWithQRCodeView:nil surfaceView:nil sessionPreset:nil device:nil];
}

- (instancetype)initWithQRCodeView:(WJQRCodeView *)qrCodeView surfaceView:(QRCodeSurfaceView *)surfaceView
{
    return [self initWithQRCodeView:qrCodeView surfaceView:surfaceView sessionPreset:nil device:nil];
}

- (instancetype)initWithQRCodeView:(WJQRCodeView *)qrCodeView surfaceView:(QRCodeSurfaceView *)surfaceView sessionPreset:(NSString *)sessionPreset device:(AVCaptureDevice *)device
{
    self = [super init];
    if (self) {
        _qrCodeView = qrCodeView;
        _surfaceView = surfaceView;
        _sessionPreset = sessionPreset;
        _captureDevice = device;
        [self initData];
        [self initCamera];
    }
    return self;
}

- (void)initData
{
    _qrcodeFlag = YES;
    _cameraDevice = [[WJCameraDevice alloc] init];
}

- (void)initCamera
{
    NSError *error;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
    _captureMetaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    _captureQueue = dispatch_queue_create("com.jerrywong.captureqrcode", nil);
    [_captureMetaDataOutput setMetadataObjectsDelegate:self queue:_captureQueue];
    _captureSession = [[AVCaptureSession alloc] init];
    [self configurateDeviceInput:_videoInput];
    [self configurateMetaDataOutput:_captureMetaDataOutput];
    [self configurateSessionPreset:self.sessionPreset];
    [self configurateQRCodeType];
    _qrCodeView.previewLayer.session = _captureSession;
}

#pragma mark - capture config
- (void)configurateDeviceInput:(AVCaptureDeviceInput *)DeivceInput
{
    if([_captureSession canAddInput:DeivceInput]) {
        [_captureSession beginConfiguration];
        [_captureSession addInput:DeivceInput];
        [_captureSession commitConfiguration];
    }
}

- (void)configurateMetaDataOutput:(AVCaptureMetadataOutput *)metaOutput
{
    if ([_captureSession canAddOutput:metaOutput]) {
        [_captureSession beginConfiguration];
        [_captureSession addOutput:metaOutput];
        [_captureSession commitConfiguration];
    }
}

- (void)configurateSessionPreset:(NSString *)sessionPreset
{
    if ([_captureSession canSetSessionPreset:sessionPreset]) {
        [_captureSession beginConfiguration];
        _captureSession.sessionPreset = sessionPreset;
        [_captureSession commitConfiguration];
    }
}

- (void)configurateQRCodeType
{
    if (self.qrcodeFlag)
        [_captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    else
        [_captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
}

- (void)configurateOutputRectOfInterest
{
    CGSize size = _qrCodeView.frame.size;
    CGRect cropRect = _cropRect;
    CGFloat p1 = size.height/size.width;
    CGFloat w = _outputDataDimesions.width;
    CGFloat h = _outputDataDimesions.height;
    CGFloat p2 = w / h;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * w / h;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _captureMetaDataOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                           cropRect.origin.x/size.width,
                                                           cropRect.size.height/fixHeight,
                                                           cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * h / w;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _captureMetaDataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                           (cropRect.origin.x + fixPadding)/fixWidth,
                                                           cropRect.size.height/size.height,
                                                           cropRect.size.width/fixWidth);
    }
}

- (NSString *)sessionPreset
{
    if (!_sessionPreset) {
        _sessionPreset = [self.cameraDevice bestSessionPresetCompatibleWithDevice:self.captureDevice];
        _outputDataDimesions = [self.cameraDevice videoBestDimensionsWithDevice:self.captureDevice];
    }
    return _sessionPreset;
}

- (AVCaptureDevice *)captureDevice
{
    if (!_captureDevice) {
        _captureDevice = [_cameraDevice backCamera];
    }
    return _captureDevice;
}

#pragma mark - property
- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    [self configurateOutputRectOfInterest];
}

- (void)setQrcodeFlag:(BOOL)qrcodeFlag
{
    _qrcodeFlag = qrcodeFlag;
    [self configurateQRCodeType];
}
#pragma mark - method
- (void)startRunning
{
    if (_captureSession == nil) {
        [NSException raise:@"Camera" format:@"Session was not opened before"];
    }
    
    if (!_captureSession.isRunning) {
        self.isReading = YES;
        [_captureSession startRunning];
        [_surfaceView startAnimateScanLine];
    }
}

- (void)stopRunning
{
    [_surfaceView stopAnimateScanLine];
    [_captureSession stopRunning];
    self.isReading = NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!_isReading) return;
    
    if (metadataObjects && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *stringValue = metadataObj.stringValue;
        [self stopRunning];
        if ([_deleage respondsToSelector:@selector(qrCodeManager:didGetQRCodeMessage:)]) {
            __weak WJQRCodeManager *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_deleage qrCodeManager:weakSelf didGetQRCodeMessage:stringValue];
            });
        }
    }
}
@end
