//
//  QRCodeSurfaceView.h
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeSurfaceView : UIView
@property (nonatomic, assign, readonly) CGRect cropRect;
- (void)startAnimateScanLine;

- (void)stopAnimateScanLine;
@end
