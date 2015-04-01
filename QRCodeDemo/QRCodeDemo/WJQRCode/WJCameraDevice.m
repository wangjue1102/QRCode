//
//  WJCameraDevice.m
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import "WJCameraDevice.h"

@implementation WJCameraDevice
//查看所有摄像头的分辨率
- (NSString *)bestSessionPresetCompatibleWithAllDevices
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    CMVideoDimensions highestCompatibleDimension;
    highestCompatibleDimension.width = 0;
    highestCompatibleDimension.height = 0;
    BOOL lowestSet = NO;
    
    for (AVCaptureDevice *device in videoDevices) {
        CMVideoDimensions highestDeviceDimension = [self bestVideoDimensionsWithDevice:device];
        
        if (!lowestSet || (highestCompatibleDimension.width * highestCompatibleDimension.height > highestDeviceDimension.width * highestDeviceDimension.height)) {
            lowestSet = YES;
            highestCompatibleDimension = highestDeviceDimension;
        }
        
    }
    return [self bestAVCaptureSessionPreset:highestCompatibleDimension];
}

//根据前摄像头或者后摄像头来获取摄像头支持的最佳的分辨率
- (NSString *)bestSessionPresetCompatibleWithDevice:(AVCaptureDevice *)device
{
    CMVideoDimensions highestCompatibleDimension = [self bestVideoDimensionsWithDevice:device];
    return [self bestAVCaptureSessionPreset:highestCompatibleDimension];
}

//遍历摄像头的摄像分辨率
- (CMVideoDimensions)bestVideoDimensionsWithDevice:(AVCaptureDevice *)device
{
    CMVideoDimensions highestDeviceDimension;
    highestDeviceDimension.width = 0;
    highestDeviceDimension.height = 0;
    
    for (AVCaptureDeviceFormat *format in device.formats) {
        CMVideoDimensions dimension = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
        
        if (dimension.width * dimension.height > highestDeviceDimension.width * highestDeviceDimension.height) {
            highestDeviceDimension = dimension;
        }
    }
    
    return highestDeviceDimension;
}

- (CMVideoDimensions)videoBestDimensionsWithDevice:(AVCaptureDevice *)device
{
    CMVideoDimensions bestDimesions = [self bestVideoDimensionsWithDevice:device];
    return [self calVideoDimensionsVideoDimensions:bestDimesions];
}

//根据规则计算尺寸
- (CMVideoDimensions)calVideoDimensionsVideoDimensions:(CMVideoDimensions)videoDimensions
{
    CMVideoDimensions dimension;
    dimension.width = 0;
    dimension.height = 0;
    
    if (videoDimensions.width >= 1920 && videoDimensions.height >= 1080) {
        dimension.width = 1920;
        dimension.height = 1080;
    }
    else if (videoDimensions.width >= 1280 && videoDimensions.height >= 720) {
        dimension.width = 1280;
        dimension.height = 720;
    }
    else if (videoDimensions.width >= 960 && videoDimensions.height >= 540) {
        dimension.width = 960;
        dimension.height = 540;
    }
    else if (videoDimensions.width >= 640 && videoDimensions.height >= 480) {
        dimension.width = 640;
        dimension.height = 480;
    }
    else if (videoDimensions.width >= 352 && videoDimensions.height >= 288) {
        dimension.width = 352;
        dimension.height = 288;
    }
    
    return dimension;
}

//根据CMVideoDimensions返回摄像的质量
- (NSString *)bestAVCaptureSessionPreset:(CMVideoDimensions)highestCompatibleDimension
{
    NSString *sessionPreset;
    
    if (highestCompatibleDimension.width >= 1920 && highestCompatibleDimension.height >= 1080) {
        sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    else if (highestCompatibleDimension.width >= 1280 && highestCompatibleDimension.height >= 720) {
        sessionPreset = AVCaptureSessionPreset1280x720;
    }
    else if (highestCompatibleDimension.width >= 960 && highestCompatibleDimension.height >= 540) {
        sessionPreset = AVCaptureSessionPresetiFrame960x540;
    }
    else if (highestCompatibleDimension.width >= 640 && highestCompatibleDimension.height >= 480) {
        sessionPreset = AVCaptureSessionPreset640x480;
    }
    else if (highestCompatibleDimension.width >= 352 && highestCompatibleDimension.height >= 288) {
        sessionPreset = AVCaptureSessionPreset352x288;
    }
    else {
        sessionPreset = AVCaptureSessionPresetLow;
    }
    return sessionPreset;
}

//前摄像头
- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//后摄像头
- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//根据AVCaptureDevicePosition返回前摄像头还是后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    __block AVCaptureDevice *deviceBlock = nil;
    
    [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] enumerateObjectsUsingBlock:^( AVCaptureDevice *device, NSUInteger idx, BOOL *stop ) {
        if ( [device position] == position ) {
            deviceBlock = device;
            *stop = YES;
        }
    }];
    
    return deviceBlock;
}

//是否有多个摄像头
- (BOOL)hasMultipleCameras
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1 ? YES : NO;
}

//摄像头的个数
- (NSUInteger)cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}
@end
