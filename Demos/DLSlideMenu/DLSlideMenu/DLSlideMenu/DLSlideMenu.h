//
//  DLSlideMenu.h
//  DLSlideMenu
//
//  Created by David on 2017/9/24.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuButtonClickedBlock)(NSUInteger buttonIndex);

@interface DLSlideMenu : UIView

@property(nonatomic,copy)MenuButtonClickedBlock buttonClickedBlock;

-(instancetype)initWithButtonTitles:(NSArray *)buttonTitles;

-(instancetype)initWithButtonTitles:(NSArray *)buttonTitles buttonHeight:(CGFloat)buttonHeight menuColor:(UIColor *)menuColor andBackBlurStyle:(UIBlurEffectStyle)style;

-(void)show;

@end
