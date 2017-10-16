//
//  CircleLocation.h
//  CircleADot
//
//  Created by landony on 4/29/16.
//  Copyright © 2016 landony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CirclePosition : NSObject

@property int row; //recording row for every dot
@property int col; ////recording col for every dot
@property int openWay; //the unblock number around every dot
@property int path; //the shortest way to the edge.

-(int) calculatePath;
-(int) calculateOpenWay;


-(int) isInCircle;
-(int) compare:(CirclePosition*) c1;
-(NSMutableArray*) getAllConnectPosition;


@end
