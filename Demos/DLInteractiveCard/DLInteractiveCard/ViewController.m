//
//  ViewController.m
//  DLInteractiveCard
//
//  Created by David on 2019/8/13.
//  Copyright © 2019 David. All rights reserved.
//

#import "ViewController.h"

#define SCROLLDISTANCE  200.0

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.layer.masksToBounds = YES;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    static CGPoint initialPoint;
    CGFloat factorOfAngle = 0.0f;
    CGFloat factorOfScale = 0.0f;
    
    CGPoint transition = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.imageView.center = CGPointMake(initialPoint.x, initialPoint.y + transition.y);
        CGFloat Y =MIN(SCROLLDISTANCE,MAX(0,ABS(transition.y)));
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factorOfAngle*(M_PI/5), transition.y>0?-1:1, 0, 0);
        t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0);
        
        self.imageView.layer.transform = t;
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        initialPoint = self.imageView.center;
    }
}

@end
