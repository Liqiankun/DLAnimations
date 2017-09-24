//
//  DLSlideMenu.m
//  DLSlideMenu
//
//  Created by David on 2017/9/24.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "DLSlideMenu.h"

#define buttonSpace 30
#define menuBlankWidth 50

@interface DLSlideMenu ()

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic,strong) UIView *topSideView;
@property (nonatomic,strong) UIView *centerSideView;
@property (nonatomic,strong) UIWindow *keyWindow;
@property(nonatomic,assign) BOOL showed;
@property(nonatomic,assign) CGFloat diffX;
@property(nonatomic,strong) UIColor *menuColor;
@property(nonatomic,assign) CGFloat menuButtonHeight;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property  NSInteger animationCount;

@end


@implementation DLSlideMenu


-(instancetype)initWithButtonTitles:(NSArray *)buttonTitles{
    return [self initWithButtonTitles:buttonTitles buttonHeight:40.0f menuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] andBackBlurStyle:UIBlurEffectStyleDark];
}

-(instancetype)initWithButtonTitles:(NSArray *)buttonTitles buttonHeight:(CGFloat)buttonHeight menuColor:(UIColor *)menuColor andBackBlurStyle:(UIBlurEffectStyle)style
{
    self = [super init];
    if (self) {

        _keyWindow = [[UIApplication sharedApplication] keyWindow];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        _blurView.frame = _keyWindow.frame;
        _blurView.alpha = 0.0f;
        
        _topSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        [_keyWindow addSubview:_topSideView];
        
        _centerSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(_keyWindow.frame) / 2  - 20, 40, 40)];
        [_keyWindow addSubview:_centerSideView];
        
        self.frame = CGRectMake(- _keyWindow.frame.size.width / 2 - menuBlankWidth, 0, _keyWindow.frame.size.width / 2 + menuBlankWidth, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [_keyWindow insertSubview:self belowSubview:_topSideView];
    
        _menuColor = menuColor;
        _menuButtonHeight = buttonHeight;
        
        [self dl_addButtons:buttonTitles];
    }
    return self;
}

-(void)show {
    if (!_showed) {
        [_keyWindow insertSubview:_blurView belowSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        
        [self dl_beforeAnimation];
        
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            _topSideView.center = CGPointMake(_keyWindow.center.x, _topSideView.frame.size.height/2);
        } completion:^(BOOL finished) {
            [self dl_finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            _blurView.alpha = 1.0f;
        }];
        
        [self dl_beforeAnimation];
        
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            _centerSideView.center = _keyWindow.center;
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dl_tapToHide)];
                [_blurView addGestureRecognizer:tapGes];
                [self dl_finishAnimation];
            }
        }];
        [self dl_animateButtons];
        _showed = YES;
    } else {
        [self dl_tapToHide];
    }
}

-(void)dl_beforeAnimation {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dl_displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

-(void)dl_finishAnimation {
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(void)dl_animateButtons {
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            menuButton.transform =  CGAffineTransformIdentity;
        } completion:NULL];
    }
}

-(void)dl_tapToHide {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(- _keyWindow.frame.size.width / 2 - menuBlankWidth, 0, _keyWindow.frame.size.width/2+menuBlankWidth, _keyWindow.frame.size.height);
    }];
    
    [self dl_beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _topSideView.center = CGPointMake(-_topSideView.frame.size.height/2, _topSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self dl_finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blurView.alpha = 0.0f;
    }];
    
    [self dl_beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _centerSideView.center = CGPointMake(-_centerSideView.frame.size.height/2, CGRectGetHeight(_keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self dl_finishAnimation];
    }];
    
    _showed = NO;
}

-(void)dl_addButtons:(NSArray *)titles{
    if (titles.count % 2 == 0) {
        NSInteger index_down = titles.count/2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            UIButton *home_button = [[UIButton alloc] init];
            if (i >= titles.count / 2) {
                index_up ++;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 + _menuButtonHeight*index_up + buttonSpace*index_up + buttonSpace/2 + _menuButtonHeight/2);
            }else{
                index_down --;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - _menuButtonHeight*index_down - buttonSpace*index_down - buttonSpace/2 - _menuButtonHeight/2);
            }
            
            home_button.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, _menuButtonHeight);
            home_button.layer.cornerRadius = 20;
            home_button.layer.borderColor = [UIColor whiteColor].CGColor;
            home_button.layer.borderWidth = 1.0f;
            [home_button setTitle:title forState:UIControlStateNormal];
            [home_button addTarget:self action:@selector(dl_tapToHide) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:home_button];
            
        }
        
    }else{
        NSInteger index = (titles.count - 1) /2 +1;
        for (NSInteger i = 0; i < titles.count; i++) {
            index --;
            NSString *title = titles[i];
            UIButton *home_button = [[UIButton alloc] init];
            home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - _menuButtonHeight*index - 20*index);
            home_button.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, _menuButtonHeight);
            [home_button setTitle:title forState:UIControlStateNormal];
            home_button.layer.cornerRadius = 20;
            home_button.layer.borderColor = [UIColor whiteColor].CGColor;
            home_button.layer.borderWidth = 1.0f;
            [home_button addTarget:self action:@selector(dl_tapToHide) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:home_button];
            
        }
    }
    
}

-(void)dl_displayLinkAction:(CADisplayLink *)dis{
    
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[_topSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[_centerSideView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    _diffX = sideRect.origin.x - centerRect.origin.x;
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - menuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width - menuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(_keyWindow.frame.size.width / 2 + _diffX, _keyWindow.frame.size.height / 2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);

}



@end
