//
//  WJQRCodeView.h
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WJQRCodeView : UIView
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *previewLayer;
@end
