//
//  DLCurveView.m
//  DLCurveRefresh
//
//  Created by David on 2019/10/30.
//  Copyright © 2019 David. All rights reserved.
//

#import "DLCurveView.h"
#import "DLCurveLayer.h"

@interface DLCurveView ()

@property (nonatomic, strong) DLCurveLayer *curveLayer;

@end

@implementation DLCurveView

+ (Class)layerClass{
    return [DLCurveLayer class];
}

-(void)setProgress:(CGFloat)progress {
    self.curveLayer.progress = progress;
    [self.curveLayer setNeedsDisplay];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.curveLayer = [DLCurveLayer layer];
    self.curveLayer.frame = self.bounds;
    self.curveLayer.contentsScale = [UIScreen mainScreen].scale;
    self.curveLayer.progress = 0.0f;
    [self.curveLayer setNeedsDisplay];
    [self.layer addSublayer:self.curveLayer];
    
}


@end
