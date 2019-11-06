//
//  DL3DRatateView.m
//  DL3DRotate
//
//  Created by David on 2019/11/6.
//  Copyright © 2019 David. All rights reserved.
//

#import "DL3DRatateView.h"

@interface DL3DRatateView ()

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *cardParallaxView;


@end

@implementation DL3DRatateView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self setup];
}

- (void)setup {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOpacity = 0.3;
    
    self.cardImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _cardImageView.image = [UIImage imageNamed:@"poster"];
    _cardImageView.layer.cornerRadius = 5.0;
    _cardImageView.clipsToBounds = YES;
    [self addSubview:_cardImageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInCard:)];
    [self addGestureRecognizer:panGesture];
    
    self.cardParallaxView = [[UIImageView alloc] initWithFrame:_cardImageView.frame];
    _cardParallaxView.image = [UIImage imageNamed:@"5"];
    _cardParallaxView.layer.transform = CATransform3DTranslate(_cardParallaxView.layer.transform, 0, 0, 200);
    [self insertSubview:_cardParallaxView aboveSubview:_cardImageView];
    
}

- (void)panInCard:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat xFactor = MIN(1, MAX(-1,(touchPoint.x - (self.bounds.size.width/2)) / (self.bounds.size.width/2)));
        CGFloat yFactor = MIN(1, MAX(-1,(touchPoint.y - (self.bounds.size.height/2)) / (self.bounds.size.height/2)));
        
        _cardImageView.layer.transform = [self transformWithM34:1.0/-500 xf:xFactor yf:yFactor];
        _cardParallaxView.layer.transform = [self transformWithM34:1.0/-250 xf:xFactor yf:yFactor];
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:0.3 animations:^{
            self->_cardImageView.layer.transform = CATransform3DIdentity;
            self->_cardParallaxView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }
}

-(CATransform3D )transformWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf{
    
    CATransform3D t = CATransform3DIdentity;
    t.m34  = m34;
    t = CATransform3DRotate(t, M_PI/9 * yf, -1, 0, 0);
    t = CATransform3DRotate(t, M_PI/9 * xf, 0, 1, 0);
    
    return t;
    
}

@end
