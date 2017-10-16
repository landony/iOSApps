//
//  ViewController.m
//  CircleADot
//
//  Created by leweny on 4/29/16.
//  Copyright © 2016 leweny. All rights reserved.
//

#import "ViewController.h"
#import "CirclePosition.h"

CirclePosition *allCircle[9][9];
int map[9][9];
int hasCircle = 0;
CirclePosition *clickPoint;
int levelNumber = 0;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *hardButton;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"gray.png"];
    
    self.allButtonArray = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 9; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:9];
        [self.allButtonArray addObject:arr];
        for (int j = 0; j < 9; j++) {
            UIButton *btn = [[UIButton alloc] init];
            if (i % 2 == 0) {
                btn.frame = CGRectMake(28*j+20, 28*i+170, 28, 28);
            }
            else {
                btn.frame = CGRectMake(28*j+34, 28*i+170, 28, 28);
            }
            [btn setImage:image forState:UIControlStateNormal];
            [self.view addSubview:btn];
            [arr addObject:btn];
            [btn addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
            CirclePosition *cl = [[CirclePosition alloc]init];
            cl.row = i;
            cl.col = j;
            cl.path = -100;
            allCircle[i][j] = cl;
        }
    }
    
    self.dot = [[CirclePosition alloc]init];
    

    UIImage *dotleftImage = [UIImage imageNamed:@"left2.png"];
    UIImage *dotRightImage = [UIImage imageNamed:@"right2.png"];
    self.dotImageview = [[UIImageView alloc]initWithFrame:CGRectMake(28*4+20, 28*3+170, 30, 56)];

    self.dotImageview.animationImages = [NSArray arrayWithObjects:dotleftImage,dotRightImage, nil];
    self.dotImageview.animationDuration = 1.0;
    [self.view addSubview:self.dotImageview];
    [self.dotImageview startAnimating];
    
    [self redoInitilazation];
    
}

- (IBAction)chooseEasy:(id)sender {
    [self.easyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.normalButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.hardButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    levelNumber = 0;
    
    [self redoInitilazation];
}

- (IBAction)chooseNormal:(id)sender {
    [self.easyButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.normalButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.hardButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    levelNumber = 1;
    
    [self redoInitilazation];
}

- (IBAction)chooseHard:(id)sender {
    [self.easyButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.normalButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.hardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    levelNumber = 2;
    
    [self redoInitilazation];
}



-(void) produceGameLevel
{
    int level = 0;
    int num = 0;
    //To Create different Blocks number for different game level
    if (levelNumber == 0) {
        level = arc4random() % 20 + 25;
    }else if (levelNumber == 1){
        level = arc4random() % 15 + 10;
    }else{
        level = arc4random() % 10 + 10;
    }

    while (num < level) {
        int row = arc4random() % 9;
        int col = arc4random() % 9;
//        *************************
        if ((row != 4 || col != 4) &&
            map[row][col] == 0) {
            num++;
            map[row][col] = 1;
            UIImage *image = [UIImage imageNamed:@"yellow2.png"];
            [self.allButtonArray[row][col] setImage:image forState:UIControlStateNormal];
        }
    }
}

-(void)redoInitilazation
{
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            map[i][j] = 0;
            UIImage *image = [UIImage imageNamed:@"gray.png"];
            [self.allButtonArray[i][j] setImage:image forState:UIControlStateNormal];
        }
    }
    self.pathNumber = 0;
    self.isGameOver = 0;
    self.dot.row = 4;
    self.dot.col = 4;
    self.dot.path = 888;
    map[4][4] = 1;
    self.dotImageview.frame = CGRectMake(28*4+20, 28*3+170, 30, 56);
    
    [self produceGameLevel];
    [self calAllOpenWay];

}
-(void) runAgain
{
    [ self redoInitilazation ];
    
}

-(void) clickMe:(id) sender
{
    UIButton *btn = (UIButton *)sender;
    UIImage *image = [UIImage imageNamed:@"yellow2.png"];
    [btn setImage:image forState:UIControlStateNormal];
    int row = [self getButtonRow:btn];
    int col = [self getButtonCol:btn];
    [self updateCostRow:row col:col];
    self.pathNumber++;
    if (self.isGameOver == 1 && self.dot.row == row && self.dot.col == col) {
        [self performSelector:@selector(showWinAlertView) withObject:nil afterDelay:0.1];
        return;
    }
    else if (self.isGameOver == 1) {
        //only one point remining, if not to choose, do again
    }
    else {
        self.isGameOver = [self dotAutoGo];
        
        if (self.isGameOver == -1){
            [self performSelector:@selector(showLoseAlertView) withObject:nil afterDelay:0.1];
            return;
        }
        [self calAllOpenWay];

    }
    
}

-(void) showWinAlertView
{
    NSString *msg = [NSString stringWithFormat:@"Your Steps：%d Steps", self.pathNumber];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:@"Cong! You arrested the Terrorist！" delegate:self cancelButtonTitle:@"Exit Game？" otherButtonTitles:@"Play Again？", nil];
    [alert show];
}

-(void) showLoseAlertView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry, Terrorists Escaped！" message:@"You lose！Keep Trying！" delegate:self cancelButtonTitle:@"Exit Game？" otherButtonTitles:@"Play Again？", nil];
    [alert show];
}



-(void) updateCostRow:(int) row col:(int) col
{
    CirclePosition * loc = allCircle[row][col];
    map[loc.row][loc.col] = 1;
    clickPoint = loc;
    [self clearAllCost];
    [self calAllOpenWay];

}

-(int) getButtonRow:(UIButton *) btn
{
    int y = btn.frame.origin.y;
    int row = (y - 170) / 28;
    return row;
}

-(int) getButtonCol:(UIButton *) btn
{
    int x = btn.frame.origin.x;
    int y = btn.frame.origin.y;
    int row = (y - 170) / 28;
    
    int col = 0;
    if (row % 2 == 0) {
        col = (x - 20) / 28;
    }
    else {
        col = (x - 34) / 28;
    }
    return col;
}



-(CirclePosition *) getMaxCost:(int *)pMax
{
    if (hasCircle == 0) {
        return nil;
    }
    int i = self.dot.row;
    int j = self.dot.col;
    CirclePosition *p = allCircle[i][j];
    NSArray *allConnectLocation = [p getAllConnectPosition];
    p = (CirclePosition*)[allConnectLocation objectAtIndex:0];
    int max = p.openWay;
    int index = 0;
    int wallNum = 0;
    CirclePosition *p1 = nil;
    for (i = 0; i < 6; i++) {
        p = (CirclePosition*)[allConnectLocation objectAtIndex:i];
        if (p.openWay < 100) {
            max = p.openWay;
            p1 = p;
            index = i;
            break;
        }
    }
    for (i = 0; i < 6; i++) {
        p = (CirclePosition*)[allConnectLocation objectAtIndex:i];
        if (p.openWay == 100) {
            wallNum++;
            continue;
        }
        if (max < p.openWay) {
            max = p.openWay;
            index = i;
        }
    }

    
    if (wallNum < 6) {
        *pMax = p.openWay;
        p = (CirclePosition*)[allConnectLocation objectAtIndex:index];
        return p;
    }
    else {
        *pMax = -1;
        return nil;
    }
}

-(CirclePosition *) getBestLocation
{

    NSMutableArray *dotAllconnects = [self.dot getAllConnectPosition];
    
    if (levelNumber == 0) {
//********** Easy Level Dot Moving Algorithm **********
        
//  Easy Level: By calculate six points around the Terrorist situation,
//              the terrorist just choose an empty point to go.
        CirclePosition *best = nil;

        if (dotAllconnects.count > 0) {
            for (int i = 0; i<6; i++) {
                if (map[((CirclePosition *)[dotAllconnects objectAtIndex:i]).row][((CirclePosition *)[dotAllconnects objectAtIndex:i]).col] == 0)
                {
                    best = [dotAllconnects objectAtIndex:i];
                }
            }

        }
        
        return best;
        
    }else if(levelNumber == 1){
        
//********** Normal Level Dot Moving Algorithm **********
//Normal Level: By calculate points around the Terrorist situation,
//        the terrorist will choose the point around which will most free way points for every step.
//        It likes the greed algorithm.
        
        CirclePosition *best = nil;
        
        int maxOpenWay = 0;
        int maxOpenWayPointIndex = 0;
        if (dotAllconnects.count > 0) {
            for (int i = 0; i<6; i++) {
                
                if ((((CirclePosition*)[dotAllconnects objectAtIndex:i]).row == 0 ||((CirclePosition*)[dotAllconnects objectAtIndex:i]).row == 8  ||((CirclePosition*)[dotAllconnects objectAtIndex:i]).col == 0 || ((CirclePosition*)[dotAllconnects objectAtIndex:i]).col == 8 ) && (map[((CirclePosition *)[dotAllconnects objectAtIndex:i]).row][((CirclePosition *)[dotAllconnects objectAtIndex:i]).col] == 0) ){
                    best = [dotAllconnects objectAtIndex:i];
                    break;
                }
                else if (map[((CirclePosition *)[dotAllconnects objectAtIndex:i]).row][((CirclePosition *)[dotAllconnects objectAtIndex:i]).col] == 0)
                {
                    
                    
                    if (maxOpenWay <= ((CirclePosition*)[dotAllconnects objectAtIndex:i]).openWay) {
                        maxOpenWay = ((CirclePosition*)[dotAllconnects objectAtIndex:i]).openWay;
                        maxOpenWayPointIndex = i;
                        
                    }
                    best = [dotAllconnects objectAtIndex:maxOpenWayPointIndex];
                }
            }
                 return best;
        }
        
        return best;
    }
    else  {
        
//********** Hard Level Dot Moving Algorithm **********
//  Hard Level:By calculate the distance to the boundary，
//             the terrorist will choose the shortest path to escape to the boundary.
//             And if the terrorist is surround，he will choose Normal Level ’s algorithm to keep himself arrested later.

    CirclePosition *best = nil;
    
    int max = 0;
    best = [self getMaxCost:&max];
    if (best != nil) {
        return best;
    }
    else if (hasCircle == 1) {
        return best;
    }
    
//    NSArray *catAllSelects = [self.cat getAllConnectLocation];
    int i = 0;
    for (i = 0; i < 6; i++) {
        CirclePosition *tmp = (CirclePosition*)[dotAllconnects objectAtIndex:i];
        if (map[tmp.row][tmp.col] == 0) {
            best = tmp;
            break;
        }
    }
    for (int j = i+1; j < 6; j++) {
        CirclePosition *tmp = (CirclePosition*)[dotAllconnects objectAtIndex:j];
        if ( map[tmp.row][tmp.col] == 0 && [tmp compare:best] == 1) {
            best = tmp;
        }
    }
    if (best != NULL) {
        printf("Dot's Best location: row is %d, col is %d\n",best.row, best.col);
    }
        return best;
    }
    
//    return best;
    
}

-(int) dotAutoGo
{
    CirclePosition *best = [self getBestLocation];
    if (best != NULL) {
        int i = self.dot.row;
        int j = self.dot.col;
        if (clickPoint.row == allCircle[i][j].row && clickPoint.col == allCircle[i][j].col) {
            
        }
        else {
            map[i][j] = 0;
        }
        self.dot.row = best.row;
        self.dot.col = best.col;
        i = self.dot.row;
        j = self.dot.col;
        map[i][j] = 1;
        if (i%2 == 0) {
            self.dotImageview.frame = CGRectMake(28*j+20, 28*(i-1)+170, 30, 56);
        }
        else {
            self.dotImageview.frame = CGRectMake(28*j+34, 28*(i-1)+170, 30, 56);
        }
        if (i == 0 || i == 8 || j == 0 || j == 8) {
            return -1;//To boundary
        }
    }
    else {
        return 1; //Only one point
    }
    return 0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //Exit
        exit(1);
    }
    else {//Play Again
        [self runAgain];
    }
}
-(void) clearAllCost
{
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            allCircle[i][j].path = -100;
            allCircle[i][j].openWay = -100;
        }
    }
}

-(void) calAllOpenWay
{
    [self clearAllCost];
    
    //Scan by this way
    //    o o o o
    //     o o o
    //    o o o
    //     o o
    for (int i = 0; i < 9; i++) {
        int k = i;
        for (int j = 0; j <= i; j++) {
            [allCircle[j][k] calculatePath];
            [allCircle[8-j][8-k] calculatePath];
            k--;
        }
    }
    
    //Scan by this way
    //    o o o o
    //     o o o
    //      o o o
    //       o o
    for (int i = 0; i < 9; i++) {
        int k = 8-i;
        for (int j = 0; j <= i; j++) {
            [allCircle[j][k] calculatePath];
            [allCircle[k][j] calculatePath];
            k++;
        }
    }
    
    //Scan by four directions: left, right, up and down
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            [allCircle[j][i] calculatePath];
            [allCircle[i][j] calculatePath];
            [allCircle[j][8-i] calculatePath];
            [allCircle[8-i][j] calculatePath];
        }
    }
    
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            [allCircle[i][j] calculateOpenWay];
        }
    }
    
    //Whether a dot in a Circle
    hasCircle = [self.dot isInCircle];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

