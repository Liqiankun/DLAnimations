//
//  ViewController.m
//  DLSlideMenu
//
//  Created by David on 2017/9/24.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "ViewController.h"
#import "DLSlideMenu.h"
@interface ViewController ()

@property(nonatomic,strong) DLSlideMenu *slideMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"DLSlideMenu";
    _slideMenu = [[DLSlideMenu alloc] initWithButtonTitles:@[@"Button One", @"Button Two", @"Button Three", @"Button Four"]];
}

- (IBAction)buttonAction:(id)sender {
    [_slideMenu show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
