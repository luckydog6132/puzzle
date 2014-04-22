//
//  PuzzleImageView.h
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PuzzleImageView;

@protocol PuzzleDelegate <NSObject>

@optional
-(void) puzzleImageViewShouldMove:(PuzzleImageView *)imageview;

@end

@interface PuzzleImageView : UIImageView

@property (assign, nonatomic) id <PuzzleDelegate> delegate;

@property (assign, nonatomic) NSInteger resultIndex;
@property (assign, nonatomic) NSInteger nowIndex;

-(BOOL)canMoveToPoint:(CGPoint)pos;

-(void) showIndex;

@end
