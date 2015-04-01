//
//  QRCodeViewController.m
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import "QRCodeViewController.h"
#import "WJQRCodeView.h"
#import "WJQRCodeManager.h"
#import "QRCodeSurfaceView.h"

@interface QRCodeViewController ()<WJQRCodeManagerDelegate>
@property (strong, nonatomic) WJQRCodeView *qrCodeView;
@property (strong, nonatomic) WJQRCodeManager *qrCodeManager;
@property (strong, nonatomic) QRCodeSurfaceView *surfaceView;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _qrCodeView = [[WJQRCodeView alloc] init];
    _qrCodeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    [self.view addSubview:_qrCodeView];
    
    _surfaceView = [[QRCodeSurfaceView alloc] init];
    _surfaceView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    [self.view addSubview:_surfaceView];
    
    _qrCodeManager = [[WJQRCodeManager alloc] initWithQRCodeView:_qrCodeView surfaceView:_surfaceView];
    _qrCodeManager.deleage = self;
    _qrCodeManager.cropRect = _surfaceView.cropRect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.qrCodeManager startRunning];
    [self installNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.qrCodeManager stopRunning];
    [self removeNotifications];
}

#pragma mark
- (void)installNotifications
{
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf.qrCodeManager startRunning];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf.qrCodeManager stopRunning];
    }];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
#pragma mark - WJQRCodeManagerDelegate
- (void)qrCodeManager:(WJQRCodeManager *)qrCodeManager didGetQRCodeMessage:(NSString *)message
{
    NSLog(@"qrcode msg = %@",message);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
