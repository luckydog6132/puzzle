//
//  OtherSolve.h
//  八数码
//
//  Created by luckydog on 14-1-10.
//  Copyright (c) 2014年 Szdcec. All rights reserved.
//

#import <Foundation/Foundation.h>

const int ROW = 3;
const int COL = 3;

typedef struct _Node{
    int digit[ROW][COL];
    int dist;   // distance between one state and the destination
    int dep;    // the depth of node
    // So the comment function = dist + dep.
    int index; // point to the location of parent
} Node;

@interface OtherSolve : NSObject

+(NSMutableArray *)solveFromArray:(NSMutableArray *)array;

@end
