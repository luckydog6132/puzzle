//
//  MenuViewController.h
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (assign, nonatomic) NSInteger lvl;

@property (strong, nonatomic) IBOutlet UILabel *label_lvl;

- (IBAction)sliderValueChange:(id)sender;

@end
