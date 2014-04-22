//
//  PuzzleImageView.m
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import "PuzzleImageView.h"

@implementation PuzzleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.redColor.CGColor;
        
    }
    return self;
}
-(void) showIndex
{
    // 直观显示，测试用

    UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
    [self addSubview:label];
    
    label.text = [NSString stringWithFormat:@"%i",self.resultIndex];
/**/
}
-(BOOL)canMoveToPoint:(CGPoint)pos
{    
    CGPoint point = self.frame.origin;
    CGSize size = self.frame.size;
    
    if (abs(abs(point.x - pos.x) - size.width) < 1  && (point.y == pos.y))
    {
        return YES;
    }
    else if(abs(abs(point.y - pos.y) - size.height) < 1 && (point.x == pos.x))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(puzzleImageViewShouldMove:)])
    {
        [self.delegate puzzleImageViewShouldMove:self];
    }
    
}

@end
