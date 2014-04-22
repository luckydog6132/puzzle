//
//  OtherSolve.m
//  八数码
//
//  Created by luckydog on 14-1-10.
//  Copyright (c) 2014年 Szdcec. All rights reserved.
//

#import "OtherSolve.h"

#include <iostream>
#include <ctime>
#include <vector>
using namespace std;

const int MAXDISTANCE = 10000;
const int MAXNUM = 10000;

Node src, dest;

vector<Node> node_v;   // store the nodes

NSMutableArray *array_Result;

@implementation OtherSolve

bool isEmptyOfOPEN() {
    for (int i = 0; i < node_v.size(); i++) {
        if (node_v[i].dist != MAXNUM)
            return false;
    }
    return true;
}

bool isEqual(int index, int digit[][COL]) {
    for (int i = 0; i < ROW; i++)
        for (int j = 0; j < COL; j++) {
            if (node_v[index].digit[i][j] != digit[i][j])
                return false;
        }
    return true;
}

ostream& operator<<(ostream& os, Node& node) {
    for (int i = 0; i < ROW; i++) {
        for (int j = 0; j < COL; j++)
            os << node.digit[i][j] << ' ';
        os << endl;
    }
    return os;
}

void PrintSteps(int index, vector<Node>& rstep_v) {
    rstep_v.push_back(node_v[index]);
    index = node_v[index].index;
    while (index != 0) {
        rstep_v.push_back(node_v[index]);
        index = node_v[index].index;
    }
    
    array_Result = [NSMutableArray array];
    
    for (int i = int(rstep_v.size() - 1); i >= 0; i--)
    {
        cout << "Step " << rstep_v.size() - i
        << endl << rstep_v[i] << endl;
        
        // 加入数组
        Node step = rstep_v[i];

        NSValue *value = nil;
        value = [NSValue valueWithBytes:&step objCType:@encode(Node)];
        
        [array_Result addObject:value];
    }
}

void Swap(int& a, int& b) {
    int t;
    t = a;
    a = b;
    b = t;
}

void Assign(Node& node, int index) {
    for (int i = 0; i < ROW; i++)
        for (int j = 0; j < COL; j++)
            node.digit[i][j] = node_v[index].digit[i][j];
}

int GetMinNode() {
    int dist = MAXNUM;
    int loc;   // the location of minimize node
    
    for (int i = 0; i < node_v.size(); i++) {
        
        if (node_v[i].dist == MAXNUM)
            continue;
        else if ((node_v[i].dist + node_v[i].dep) < dist) {
            loc = i;
            dist = node_v[i].dist + node_v[i].dep;
        }
    }
    
    return loc;
}

bool isExpandable(Node& node) {
    for (int i = 0; i < node_v.size(); i++) {
        if (isEqual(i, node.digit))
            return false;
    }
    return true;
}

int Distance(Node& node, int digit[][COL]) {
    int distance = 0;
    bool flag = false;
    for(int i = 0; i < ROW; i++)
        for (int j = 0; j < COL; j++)
            for (int k = 0; k < ROW; k++) {
                for (int l = 0; l < COL; l++) {
                    if (node.digit[i][j] == digit[k][l]) {
                        distance += abs(i - k) + abs(j - l);
                        flag = true;
                        break;
                    }
                    else
                        flag = false;
                }
                if (flag)
                    break;
            }
    return distance;
}

int MinDistance(int a, int b) {
    return (a < b ? a : b);
}

void ProcessNode(int index) {
    int x, y;
    bool flag;
    for (int i = 0; i < ROW; i++) {
        for (int j = 0; j < COL; j++) {
            if (node_v[index].digit[i][j] == 0) {
                x =i; y = j;
                flag = true;
                break;
            }
            else flag = false;
        }
        if(flag)
            break;
    }
    
    Node node_up;
    Assign(node_up, index);
    int dist_up = MAXDISTANCE;
    if (x > 0) {
        Swap(node_up.digit[x][y], node_up.digit[x - 1][y]);
        if (isExpandable(node_up)) {
            dist_up = Distance(node_up, dest.digit);
            node_up.index = index;
            node_up.dist = dist_up;
            node_up.dep = node_v[index].dep + 1;
            node_v.push_back(node_up);
        }
    }
    
    Node node_down;
    Assign(node_down, index);
    int dist_down = MAXDISTANCE;
    if (x < 2) {
        Swap(node_down.digit[x][y], node_down.digit[x + 1][y]);
        if (isExpandable(node_down)) {
            dist_down = Distance(node_down, dest.digit);
            node_down.index = index;
            node_down.dist = dist_down;
            node_down.dep = node_v[index].dep + 1;
            node_v.push_back(node_down);
        }
    }
    
    Node node_left;
    Assign(node_left, index);
    int dist_left = MAXDISTANCE;
    if (y > 0) {
        Swap(node_left.digit[x][y], node_left.digit[x][y - 1]);
        if (isExpandable(node_left)) {
            dist_left = Distance(node_left, dest.digit);
            node_left.index = index;
            node_left.dist = dist_left;
            node_left.dep = node_v[index].dep + 1;
            node_v.push_back(node_left);
        }
    }
    
    Node node_right;
    Assign(node_right, index);
    int dist_right = MAXDISTANCE;
    if (y < 2) {
        Swap(node_right.digit[x][y], node_right.digit[x][y + 1]);
        if (isExpandable(node_right)) {
            dist_right = Distance(node_right, dest.digit);
            node_right.index = index;
            node_right.dist = dist_right;
            node_right.dep = node_v[index].dep + 1;
            node_v.push_back(node_right);
        }
    }
    
    node_v[index].dist = MAXNUM;
}


+(NSMutableArray *)solveFromArray:(NSMutableArray *)array
{
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COL; j++)
        {
            NSInteger index = i * ROW + j;
            src.digit[i][j] = [[array objectAtIndex:index]integerValue];
        }
    }
    src.index = 0;
    src.dep = 1;
    
    for (int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COL; j++)
        {
            NSInteger index = i * ROW + j;
            dest.digit[i][j] = index;
        }
    }
    node_v.clear();
    node_v.push_back(src);
    
    while (1) {
        if (isEmptyOfOPEN()) {
            NSLog(@"Cann't solve this statement!");
            return Nil;
        }
        else {
            int loc;   // the location of the minimize node
            loc = GetMinNode();
            if(isEqual(loc, dest.digit)) {
                
                for (int i = 0; i < node_v.size(); i++) {
                
                    cout << node_v[i] << endl;
                }
                
                vector<Node> rstep_v;
                
                PrintSteps(loc, rstep_v);
                
                break;
            }
            else
            {
                ProcessNode(loc);
            }
        }
    }
    return array_Result;
}
@end