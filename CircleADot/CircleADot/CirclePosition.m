//
//  CircleLocation.m
//  CircleADot
//
//  Created by leweny on 4/29/16.
//  Copyright © 2016 leweny. All rights reserved.
//
//this class to locate the dot position
#import "CirclePosition.h"

extern CirclePosition *allCircle[9][9];
extern int map[9][9];
extern int hasCircle;

@implementation CirclePosition

-(int)compare:(CirclePosition *)c1
{
    if (self.path >= 0 && c1.path >= 0) {
        if (self.path < c1.path) {
            return 1;
        }
    }
    else if (hasCircle == 1) {
        if (self.openWay > c1.openWay ) {
            return 1;
        }
        else
        return 0;
    }
    else {
        int m1 = - self.path;
        int m2 = - c1.path;
        if (m1 < m2 ) {
            return 1;
        }
        else
        return 0;
    }
    return 0;
}

-(BOOL) isBoundary
{
    if (self.row == 0 || self.row == 8 ||
        self.col == 0 || self.col == 8) {
        return YES;
    }
    else {
        return NO;
    }
}

//whether or not this dot in circle

-(int)isInCircle
{
    
    NSArray *allConnectLocation = [self getAllConnectPosition];
    int num = 0;
    for (CirclePosition* obj in allConnectLocation) {
        if (obj.path > 100 ||
            (obj.path > -100 &&
             obj.path < 0) ||
            obj.path == 100) {
            num++;
        }
    }
    
    if (num == 6) {
        return 1;
    }
    else {
        return 0;
    }
}

-(int)calculateOpenWay
{
    int i = self.row;
    int j = self.col;
    if (map[i][j] == 1) {
        self.openWay = 100;
        return self.openWay;
    }
    if ([self isBoundary]) {
        self.openWay = 0;
        return self.openWay;
    }
    NSArray *allConnectLocation = [self getAllConnectPosition];
    int number = 0;
    for (CirclePosition* obj in allConnectLocation) {
        if (map[obj.row][obj.col] == 0) {
            number++;
        }
    }
    self.openWay = number;
    return self.openWay;
}

-(int)calculatePath
{
    int i = self.row;
    int j = self.col;
    if (map[i][j] == 1) {
        self.path = 100;
        return self.path;
    }
    if ([self isBoundary]) {
        self.path = 0;
        return self.path;
    }
    NSArray *allConnectLocation = [self getAllConnectPosition];
    int min = 100;
    for (CirclePosition* obj in allConnectLocation) {
        if (obj.path > -100) {
            int tmp = obj.path;
            if (obj.path < 0) {
                tmp = -tmp;
            }
            if (min > tmp) {
                min = tmp;
            }
        }
    }
    if (min < 100) {
        self.path = min + 1;
    }
    else {
        self.path += 1;
    }
    return self.path;
}


-(NSMutableArray*) getAllConnectPosition
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:6];
    [arr insertObject:[self getLeftUp] atIndex:0];
    [arr insertObject:[self getLeft] atIndex:1];
    [arr insertObject:[self getLeftDown] atIndex:2];
    [arr insertObject:[self getRightDown] atIndex:3];
    [arr insertObject:[self getRight] atIndex:4];
    [arr insertObject:[self getRightUp] atIndex:5];
    
    return arr;
}

-(CirclePosition*) getLeft
{
    CirclePosition* newp = NULL;
    if (self.col > 0) {
        newp = allCircle[self.row][self.col-1];
    }
    return newp;
}
-(CirclePosition*) getRight
{
    CirclePosition* newp = NULL;
    if (self.col < 8) {
        newp = allCircle[self.row][self.col+1];
    }
    return newp;
}
-(CirclePosition*)  getLeftDown
{
    CirclePosition* newp = NULL;
    if (self.row < 8) {
        CirclePosition* p = allCircle[self.row+1][self.col];
        if (self.row % 2 == 0) {
            if (self.col == 0) {
                newp = NULL;
            }
            else {
                newp = allCircle[self.row+1][self.col-1];
            }
        }
        else {
            newp = p;
        }
    }
    return newp;
}
-(CirclePosition*) getRightDown
{
    CirclePosition* newp = NULL;
    if (self.row < 8) {
        CirclePosition* p = allCircle[self.row+1][self.col];
        if (self.row % 2 == 0) {
            newp = p;
        }
        else {
            if (self.col == 8) {
                newp = NULL;
            }
            else {
                newp = allCircle[self.row+1][self.col+1];
            }
        }
    }
    return newp;
}
-(CirclePosition*)  getRightUp
{
    CirclePosition* newp = NULL;
    if (self.row > 0) {
        CirclePosition* p = allCircle[self.row-1][self.col];
        if (self.row % 2 == 0) {
            newp = p;
        }
        else {
            if (self.col == 8) {
                newp = NULL;
            }
            else {
                newp = allCircle[self.row-1][self.col+1];
            }
        }
    }
    
    return newp;
}
-(CirclePosition*)  getLeftUp
{
    CirclePosition* newp = NULL;
    if (self.row > 0) {
        CirclePosition* p = allCircle[self.row-1][self.col];
        if (self.row % 2 == 0) {
            if (self.col == 0) {
                newp = NULL;
            }
            else {
                newp = allCircle[self.row-1][self.col-1];
            }
        }
        else {
            newp = p;
        }
    }
    
    return newp;
}

@end

