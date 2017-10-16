//
//  ViewController.h
//  CircleADot
//
//  Created by leweny on 4/29/16.
//  Copyright © 2016 leweny. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CirclePosition;

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *allButtonArray;
@property (strong, nonatomic) UIImageView *dotImageview;
@property (strong, nonatomic) CirclePosition *dot;
@property int pathNumber, isGameOver;

@end

