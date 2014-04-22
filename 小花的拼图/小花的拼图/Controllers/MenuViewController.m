//
//  MenuViewController.m
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import "MenuViewController.h"
#import "PuzzleViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[PuzzleViewController class]])
    {
        ((PuzzleViewController *)vc).lvl = self.lvl;
    }
}
#pragma mark -
#pragma mark 初始化

// 初始化必要数据
-(void)initData
{
    self.title = @"菜单";
    self.lvl = 3;
}
- (IBAction)sliderValueChange:(id)sender
{
    UISlider *slider = sender;
    
    if (slider.value < 4)
    {
        self.lvl = 3;
        [slider setValue:3.0];
        self.label_lvl.text = @"简单";
    }else if (slider.value < 5)
    {
        self.lvl = 4;
        [slider setValue:4.0];
        self.label_lvl.text = @"中等";
    }else if (slider.value > 4)
    {
        self.lvl = 5;
        [slider setValue:5.0];
        self.label_lvl.text = @"困难";
    }
}
@end
