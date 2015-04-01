//
//  WJQRCodeView.m
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import "WJQRCodeView.h"

@interface WJQRCodeView ()
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation WJQRCodeView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [_previewLayer removeFromSuperlayer];
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    [self.layer addSublayer:previewLayer];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer = previewLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.previewLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.previewLayer.position = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
}

@end
