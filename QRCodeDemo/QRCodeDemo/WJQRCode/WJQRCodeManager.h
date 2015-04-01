//
//  WJQRCodeManager.h
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WJQRCodeView.h"
#import "QRCodeSurfaceView.h"

@class WJQRCodeManager;

@protocol WJQRCodeManagerDelegate <NSObject>

@optional
- (void)qrCodeManager:(WJQRCodeManager *)qrCodeManager didGetQRCodeMessage:(NSString *)message;
@end

@interface WJQRCodeManager : NSObject
@property (assign, nonatomic) BOOL qrcodeFlag; //yes：只扫描二维码，no：扫描二维码和条码
@property (assign, nonatomic) CGRect cropRect;
@property (weak, nonatomic) id<WJQRCodeManagerDelegate> deleage;

- (instancetype)initWithQRCodeView:(WJQRCodeView *)qrCodeView surfaceView:(QRCodeSurfaceView *)surfaceView;

- (instancetype)initWithQRCodeView:(WJQRCodeView *)qrCodeView surfaceView:(QRCodeSurfaceView *)surfaceView sessionPreset:(NSString *)sessionPreset device:(AVCaptureDevice *)device;

- (void)startRunning;

- (void)stopRunning;
@end
