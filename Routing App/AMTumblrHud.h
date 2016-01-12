//
//  AMTumblrHud.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 16/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTumblrHud : UIView
@property (nonatomic, strong) UIColor *hudColor;

-(void)showAnimated:(BOOL)animated;
-(void)hide;
@end
