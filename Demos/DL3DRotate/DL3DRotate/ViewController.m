//
//  ViewController.m
//  DL3DRotate
//
//  Created by David on 2019/11/6.
//  Copyright © 2019 David. All rights reserved.
//

#import "ViewController.h"
#import "DL3DRatateView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DL3DRatateView *ratateView = [[DL3DRatateView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    ratateView.center = self.view.center;
    [self.view addSubview:ratateView];
    
}


@end
