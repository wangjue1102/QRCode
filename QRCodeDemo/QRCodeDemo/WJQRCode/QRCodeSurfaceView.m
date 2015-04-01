//
//  QRCodeSurfaceView.m
//  QRCodeDemo
//
//  Created by x1371 on 15/3/31.
//  Copyright (c) 2015年 Jerry‘s PC. All rights reserved.
//

#import "QRCodeSurfaceView.h"

static CGFloat const pickerMarginY = 60;
static CGFloat const pickerMarginX = 50;
static CGFloat cornerLineW = 20;
@interface QRCodeSurfaceView ()
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, strong) UIImageView *scanLine;
@end

@implementation QRCodeSurfaceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
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
    self.backgroundColor = [UIColor clearColor];
}

- (CGRect)cropRect
{
    if (CGRectEqualToRect(_cropRect, CGRectZero)) {
        _cropRect = CGRectMake(pickerMarginX, pickerMarginY, CGRectGetWidth(self.frame) - 2 * pickerMarginX, CGRectGetWidth(self.frame) - 2 * pickerMarginX);
    }
    return _cropRect;
}

- (void)startAnimateScanLine
{
    [_scanLine removeFromSuperview];
    CGRect cropRect = self.cropRect;
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(cropRect.origin.x + 5, cropRect.origin.y, cropRect.size.width - 10, 2)];
    _scanLine.image = [UIImage imageNamed:@"line"];
    [self addSubview:_scanLine];

    NSTimeInterval duration = 2.0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGFloat pointX = _scanLine.frame.origin.x + _scanLine.frame.size.width / 2.0;
    CGFloat startPointY = _scanLine.frame.origin.y + _scanLine.frame.size.height / 2.0;
    CGFloat endPointY = _scanLine.frame.origin.y + cropRect.size.height - _scanLine.frame.size.height / 2.0;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(pointX, startPointY)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(pointX, endPointY)];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = NSIntegerMax;
    [_scanLine.layer addAnimation:animation forKey:@"ScanlineAnimation"];
}

- (void)stopAnimateScanLine
{
    [_scanLine.layer removeAllAnimations];
    [_scanLine removeFromSuperview];
    _scanLine = nil;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat x = self.cropRect.origin.x;
    CGFloat y = self.cropRect.origin.y;
    CGFloat wh = self.cropRect.size.width;
    CGFloat borderW = 1;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.5);
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, wh, wh)];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, borderW);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor);
    [pickingFieldPath stroke];
    
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    CGContextSetLineWidth(contextRef, 3);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor greenColor].CGColor);
    //left top
    CGContextMoveToPoint(contextRef, x + borderW, y + borderW);
    CGContextAddLineToPoint(contextRef, x + borderW + cornerLineW, y + borderW);
    CGContextMoveToPoint(contextRef, x + borderW, y + borderW);
    CGContextAddLineToPoint(contextRef, x + borderW, y + borderW + cornerLineW);
    
    //right top
    CGContextMoveToPoint(contextRef, x + wh - borderW, y + borderW);
    CGContextAddLineToPoint(contextRef, x + wh - borderW - cornerLineW, y + borderW);
    CGContextMoveToPoint(contextRef, x + wh - borderW, y + borderW);
    CGContextAddLineToPoint(contextRef, x + wh - borderW, y + borderW + cornerLineW);
    
    //left bottom
    CGContextMoveToPoint(contextRef, x + borderW, y + wh - borderW);
    CGContextAddLineToPoint(contextRef, x + borderW + cornerLineW, y + wh - borderW);
    CGContextMoveToPoint(contextRef, x + borderW, y + wh - borderW);
    CGContextAddLineToPoint(contextRef, x + borderW, y + wh - borderW - cornerLineW);
    
    //right bottom
    CGContextMoveToPoint(contextRef, x + wh - borderW, y + wh - borderW);
    CGContextAddLineToPoint(contextRef, x + wh - borderW - cornerLineW, y + wh - borderW);
    CGContextMoveToPoint(contextRef, x + wh - borderW, y + wh - borderW);
    CGContextAddLineToPoint(contextRef, x + wh - borderW, y + wh - borderW - cornerLineW);
    
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
}

@end
