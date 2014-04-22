//
//  PuzzleViewController.h
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleImageView.h"

@interface PuzzleViewController : UIViewController <PuzzleDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *array_ImageView;

@property (strong, nonatomic) NSString *string_ImageName;

@property (assign, nonatomic) BOOL isStart;

@property (assign, nonatomic) NSInteger lvl;

@property (strong, nonatomic) UIView *view_PuzzleBoard;



@property (assign, nonatomic) BOOL isResulting;

@property (strong, nonatomic) NSMutableArray *array_Result;
@property (assign, nonatomic) NSInteger nowStep;

@end
