//
//  WJCameraDevice.h
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WJCameraDevice : NSObject
//查看所有摄像头的分辨率
- (NSString *)bestSessionPresetCompatibleWithAllDevices;

//根据前摄像头或者后摄像头来获取摄像头支持的最佳的分辨率
- (NSString *)bestSessionPresetCompatibleWithDevice:(AVCaptureDevice *)device;

//前摄像头
- (AVCaptureDevice *)frontCamera;

//后摄像头
- (AVCaptureDevice *)backCamera;

//是否有多个摄像头
- (BOOL)hasMultipleCameras;

//摄像头的个数
- (NSUInteger)cameraCount;

- (CMVideoDimensions)videoBestDimensionsWithDevice:(AVCaptureDevice *)device;
@end
