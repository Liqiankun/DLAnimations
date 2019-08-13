//
//  ViewController.m
//  DLLoadingHUD
//
//  Created by David on 2019/8/13.
//  Copyright © 2019 David. All rights reserved.
//

#import "ViewController.h"
#import "DLLoadingHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLLoadingHUD *loadingHUD = [[DLLoadingHUD alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
    loadingHUD.layer.cornerRadius = 50;
    loadingHUD.layer.masksToBounds = YES;
    loadingHUD.backgroundColor = [UIColor blueColor];
    loadingHUD.center = self.view.center;
    [self.view addSubview:loadingHUD];
    
}


@end
