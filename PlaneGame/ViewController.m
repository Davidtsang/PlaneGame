//
//  ViewController.m
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PGCell.h"
#import "PGPlane.h"
#import "GCHelper.h"
//#import "AppDelegate.h"
#import <Social/Social.h>

#define kMapViewTag 100
#define kWinScreenTag 101

@interface ViewController ()
{
    PGCell  *_levelMap[10][10];
    NSInteger _level[10][10];
    
    NSInteger _tapedCell[10][10];
    
    NSTimer *_hpTimer;
    NSInteger _updateHpPoints;
    
}
@property(assign,nonatomic)NSInteger score;
@property(assign,nonatomic)NSInteger best;

@property (weak, nonatomic) IBOutlet UILabel *flashLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconPlane1;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlane2;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlane3;

@property (weak, nonatomic) IBOutlet UILabel *hpLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong,nonatomic)UIView *mapView;

@property (assign,nonatomic)NSInteger planesNum;

@property (nonatomic,assign)NSInteger hp;

@end

@implementation ViewController
//make random map

// 1 .random make a plane ,try into a random row/col ,
-(BOOL)addPlaneToLevel :(PGPlane*)plane row:(NSInteger)row col:(NSInteger)col isPertest:(BOOL)isPretest
{
    BOOL result = YES;
    
    NSArray *planeGraph = plane.planeGraph;
    
    // row x-axis row + width
    for (NSInteger j = 0 ;j < [planeGraph count] ; j++) {
        //
        NSArray *planeRow  = [planeGraph objectAtIndex:j ];
        
        for (NSInteger i =0; i < [planeRow count]; i++) {
            //
            BOOL isCellNull = _level[col+j][row+i] == 0 ? YES: NO ;
            BOOL isPlanePointNull = [[planeRow objectAtIndex:i] integerValue] == 0? YES:NO;
            
            //cell null && palne null :nothing to do
            //cell not null && plane null: nothing to do
            //cell null && plane not null :cell = plane
            //cell not null && plane not null : can not add plane
            
            if (isCellNull && isPlanePointNull == NO ) {
                //
                if (isPretest == NO ) {
                    _level[col+j][row+i] = [[planeRow objectAtIndex:i] integerValue];
                }
                
            }else if(isCellNull ==NO && isPlanePointNull == NO ){
                
                result = NO ;
                break;
            }
            
        }
        
        if (result ==NO ) {
            break;
        }
    }
    
    if (result == YES  && isPretest == YES) {
        //
        [self addPlaneToLevel:plane row:row col:col isPertest:NO];
        
    }
    
 
    return result;
    
}//


-(BOOL)genRandomPlaneTryAddToLevel
{
    NSLog(@"TRY ADD NEW PLANE TO LEVEL...");
    // make a random plane
    PGPlane *plane = [[PGPlane alloc] initWithRandomDirection];
    
    //put to a random postion
    
    //U:1 D:3  SIZE:4*5
    NSInteger rowLimit = [[plane.planeGraph objectAtIndex:0] count];
    NSInteger colLimit = [plane.planeGraph count];
    
//    if (plane.planeDirection == 0 || plane.planeDirection == 2) {
//        // L:0 R:2  SIZE: 5*4
//        rowLimit =  -4;
//        colLimit = -5;
//    }
    
    u_int32_t rowRange = (u_int32_t)(10 - rowLimit);
    u_int32_t colRange = (u_int32_t)(10 - colLimit);
    
    NSInteger rowRandom = arc4random_uniform(rowRange);
    NSInteger colRandom = arc4random_uniform(colRange);
    
    //try add plane to this point . if can not add , re gen a new plane /
    return [self addPlaneToLevel:plane row:rowRandom col:colRandom isPertest:YES];
}

-(void)makeRandomLevel
{
    //init level
    for (NSInteger i = 0; i < 10; i++) {
        
        for (NSInteger j = 0; j < 10; j++) {
            //
            _level[i][j] = 0;
            
        }
    }
    
    NSInteger planeNumber  = 3;
    
    for (NSInteger i = 0; i < planeNumber; i++) {
        //
        BOOL isSuccess =     NO ;
        
        NSInteger tryNumber = 0;
        while (isSuccess == NO  ) {
        
            isSuccess = [self genRandomPlaneTryAddToLevel];
            //continue;
            tryNumber++;
            //if try number > 100 redoit
            if (tryNumber > 100) {
                NSLog(@"try nuber >100... reset level.");
                [self makeRandomLevel];
                break;
            }
        }
        
        NSLog(@"ADD PLANE OK!");
    }
    
    
}

-(void)showLevel
{
    //
    for (NSInteger j = 0; j < 10; j++) {
        for (NSInteger i = 0; i< 10; i++) {
            //
            NSInteger val = _level[j][i];
            
            PGCell *cell = _levelMap[j][i];
            
            switch (val) {
                case 0:
                    cell.view.backgroundColor  = [UIColor whiteColor];
                    break;
                    
                case 1:
                    cell.view.backgroundColor  = kColorBlue;
                    break;
                    
                case 2:
                    cell.view.backgroundColor  = kColorRed ;
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}


- (NSSet *)createInitialCell {
    NSMutableSet *set = [NSMutableSet set];
    
    // 1
    for (NSInteger row = 0; row < 10; row++) {
        for (NSInteger column = 0; column < 10; column++) {
            
            // 2
            NSUInteger cellType = 0;
            
            // 3
            PGCell *cell= [self createCellAtColumn:column row:row withType:cellType];
            
            // 4
            [set addObject:cell];
        }
    }
    return set;
}


- (PGCell *)createCellAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cellType {
    PGCell *cell = [[PGCell alloc] init];
    //cookie.cookieType = cookieType;
    cell.cellType = cellType;
    cell.column = column;
    cell.row = row;
    
    _levelMap[column][row] =  cell;
    
    return cell;
 
}

-(void)cellTap:(id)sender
{
    
    //is game  over
    if (self.hp - 1*self.planesNum - _updateHpPoints <= 0) {
        // game over
        [self gameOver];
    }else{
    
    UITapGestureRecognizer *uSender = (UITapGestureRecognizer*)sender;
    SpiritView *spiritView = (SpiritView *)uSender.view;
    NSDictionary *userInfo = spiritView.userInfo;
    //NSLog(@"%@",userInfo);
    
    NSInteger cellRow = [[userInfo objectForKey:@"row"] integerValue];
    NSInteger cellColumn = [[userInfo objectForKey:@"column"] integerValue];
    
    //CHECK TISH CELL TO LEVEL IS WAHT?!
    [self checkCellAtRow:cellRow column:cellColumn];
    }
}

-(void)updateHpAnima:(NSInteger)points
{
    [_hpTimer invalidate];
    _updateHpPoints += points;
    
    NSTimeInterval interval = 0.3/points;
    
    _hpTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hpUpdate) userInfo:Nil repeats:YES];
}

-(void)hpUpdate{
    self.hp--;
    _updateHpPoints--;
    
    //update coin label
   [self updateHp];
    
    if(_updateHpPoints <= 0){
        //when reach the coin value,invalidate the timer
        [_hpTimer invalidate];
    }
}

-(void)updateHp
{
    //
    
    self.hpLabel.text = [NSString stringWithFormat:@"HP: %ld",(long)self.hp];
    
}



-(void)gameOver
{
    [[OALSimpleAudio sharedInstance]playEffect:kSoundGameOver];
    
    [_hpTimer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateHpAnima:) object:nil];
    //self.score += self.hp*100;
    self.hp = 0;
    [self updateHp];

    self.life -=1;
    [self updateLifeLabel];
    
    //
    [self updateBestScore];
    
    
    UIView *screenView = [[UIView alloc] initWithFrame:self.view.frame];
    
    screenView.tag = kWinScreenTag;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2- kBarHeight/2, self.view.frame.size.width, kBarHeight)];
    
    barView.backgroundColor  = kColorYellow;
    
    barView.alpha = 0.7;
    
    CGFloat barBottomLine  = barView.frame.origin.y + barView.frame.size.height;
    
    //add title
    //NSInteger titleWidth =200;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-kTitleWidth/2, barView.frame.origin.y, kTitleWidth ,kTitleHeight)];
    
    titleLabel.text = @"Game Over";
    titleLabel.textColor  = [UIColor blackColor] ;
 
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont fontWithName:kGameFontBold size:kAppFontHuge];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, barView.frame.origin.y+ barView.frame.size.height/2 - kMsgLabelHeight , kTitleWidth, kMsgLabelHeight )];
    msgLabel.textColor =  kColorBlue4;
    
    msgLabel.textAlignment  = NSTextAlignmentCenter;
    msgLabel.font = [UIFont fontWithName:kGameFont size:kAppFontNormal];
    
    //titleLabel.backgroundColor = [UIColor purpleColor];
    [screenView addSubview:barView];
    [screenView addSubview:titleLabel];
    [screenView addSubview:msgLabel];
    
    //[gameWinView addSubview:titleLabel];
    
    NSString *msg = [NSString stringWithFormat:@"Score: %ld", (long)self.score];
    msgLabel.text = msg;
    
    
    
    //btn next
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    CGRect frame = CGRectMake(self.view.frame.size.width/2 - kButtonWidth/2 , barBottomLine - kButtonHeight - kBarGap ,kButtonWidth  ,kButtonHeight); // set values as per your requirement
    
    button.backgroundColor = kColorBlue ;
    button.titleLabel.font = [UIFont fontWithName:kGameFont size:kAppFontBig ];
    
    button.layer.cornerRadius = 4;
    
    button.clipsToBounds = YES;
    
    NSString *btnStr =@"Try again";
    
    if (self.life <= 0) {
        btnStr =@"New game";
    }
    [button setTitle:btnStr forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
    
    
    button.frame = frame;
    
    NSLog(@"game over!");
    
    [screenView addSubview:button];
    
    
    //btn share
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    shareButton.backgroundColor  = kColorBlue1;
    
    shareButton.frame = CGRectMake(self.view.frame.size.width/2 - kButtonWidth/2 , button.frame.origin.y -kBarGap-kButtonHeight ,kButtonWidth  ,kButtonHeight);
    
    [shareButton setTitle:@"Share" forState:UIControlStateNormal ];
    
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton.titleLabel.font = [UIFont fontWithName:kGameFont size:kAppFontBig];
    
    shareButton.layer.cornerRadius = 4;
    shareButton.clipsToBounds = YES;
    
    [screenView addSubview:shareButton];
    
    [self.view addSubview:screenView];

    
}

-(void)tryAgain
{
    //self.life -=1;
    
    
    
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    
    //
    NSLog(@"next...");
    UIView *winView  = [self.view viewWithTag:kWinScreenTag];
    
    [winView removeFromSuperview];
    
    if (self.life <= 0) {
        //reset game
        self.score =0;
        [self updateScore];
        
        self.currentLevel = 0;
        self.currentStage = 0;
        self.life =3;
        [self updateLifeLabel];
        
    }
    
    [self resetLevel:self.currentLevel stage:self.currentStage];
}
-(NSString *)bombPlayer {
    //NSInteger remainPlaneNumer = [self remainPlanes];
    //self.hp =self.hp - 1*self.planesNum;

    
    [self updateHpAnima:1*self.planesNum];
    

    NSString *bombString = [NSString stringWithFormat: NSLocalizedString( @"%ld planes bombed you! you lost %ld point HP!",nil),(long)self.planesNum,(long)self.planesNum];
    //[self flashText:bombString];
    if (self.planesNum ==0) {
        bombString = @"";
    }
    return bombString;
    
    //NSLog(@"BOMB PLAYER * %ld",(long)self.planesNum);
}



-(void)playerMiss:(NSInteger)row column:(NSInteger)column
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundHitMiss];
    self.missStep++;
    //change cell to hit color
    PGCell *cell = (PGCell *)_levelMap[column][row];
    

    
    cell.view.backgroundColor = kCellColorMiss ;
    
    NSString *flashMsg = [NSString stringWithFormat: NSLocalizedString(@"Miss!\n%@", nil) ,[self bombPlayer]];
    [self flashText:flashMsg];
 
    
}

-(void)playerHitBody:(NSInteger)row column:(NSInteger)column
{
    //change cell to hit color
    [[OALSimpleAudio sharedInstance] playEffect:kSoundHitbody];
    PGCell *cell = (PGCell *)_levelMap[column][row];

    self.gameWinPoint += 1;
    
    cell.view.backgroundColor = kCellColorHit ;
    NSString *flashMsg = [NSString stringWithFormat:NSLocalizedString(@"You hit an plane's body!\n%@",nil),[self bombPlayer]];
    [self flashText:flashMsg];
 
    
}

-(void)playerHitHead:(NSInteger)row column:(NSInteger)column
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundHitHead];
    self.gameWinPoint += 2;
    //change cell to hit color

    PGCell *cell = (PGCell *)_levelMap[column][row];
    
    cell.view.backgroundColor = kCellColorHitHead;
    
    
    //PLANE DESTRY
    //
    self.planesNum --;
    
    switch (self.planesNum) {
        case 2:
            [self.iconPlane1 setHidden:YES];
            break;
        
        case 1:
            [self.iconPlane2 setHidden:YES];
            break;
            
        case 0:
            [self.iconPlane3 setHidden:YES];
            
        default:
            break;
    }
    
    if (self.planesNum > 0) {
        
        NSString *flashMsg = [NSString stringWithFormat:NSLocalizedString( @"You destroyed an airplane!\n%@",nil ),[self bombPlayer]];
        [self flashText:flashMsg ];
        
        //PLANe BOMB PLAER
        //[self performSelector:@selector(bombPlayer) withObject:nil afterDelay:kFlashTextTime];
    }
    
}

-(void)playerWin
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundWin];
    
    self.score += self.hp*100 - self.missStep *100;
    UIView *screenView = [[UIView alloc] initWithFrame:self.view.frame];
    
    screenView.tag = kWinScreenTag;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2- kBarHeight/2, self.view.frame.size.width, kBarHeight)];
    
    barView.backgroundColor  = kColorYellow;
    
    barView.alpha = 0.7;
    
    CGFloat barBottomLine  = barView.frame.origin.y + barView.frame.size.height;
    
    //add title
    //NSInteger titleWidth =200;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-kTitleWidth/2, barView.frame.origin.y, kTitleWidth ,kTitleHeight)];
    
    titleLabel.text = @"You win!";
    titleLabel.textColor  = kColorRed ;
    //titleLabel.backgroundColor  = [UIColor purpleColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont fontWithName:kGameFontBold size:kAppFontHuge];

    NSInteger msgWidth = 106;
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.view.frame.size.width/2 - msgWidth/2 , barView.frame.origin.y+ barView.frame.size.height/2 - kMsgLabelHeight/2 , msgWidth, kMsgLabelHeight )];
    
    msgLabel.textColor =  kColorBlue4;
    
    msgLabel.textAlignment  = NSTextAlignmentLeft;
    msgLabel.font = [UIFont fontWithName:kGameFontBold size:kAppFontNormal];
    msgLabel.numberOfLines = 0;
    //[msgLabel sizeToFit];
    NSString *msg = @"HP:\nMiss:\nScore:";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [msg  length])];
    
    msgLabel.attributedText  = attributedString;
    
    //titleLabel.backgroundColor = [UIColor purpleColor];
    [screenView addSubview:barView];
    [screenView addSubview:titleLabel];
    [screenView addSubview:msgLabel];
    
    //[gameWinView addSubview:titleLabel];
    
    
    //msgLabel.text = msg;
 
    //msgLabel.backgroundColor = [UIColor grayColor];
    
    //msg label r
    UILabel *msgLabelR = [[UILabel alloc] initWithFrame:CGRectMake( self.view.frame.size.width/2 - msgWidth/2 , barView.frame.origin.y+ barView.frame.size.height/2 - kMsgLabelHeight/2 , msgWidth, kMsgLabelHeight )];
    
    msgLabelR.textColor =  kColorBlue4;
    
    msgLabelR.textAlignment  = NSTextAlignmentRight;
    msgLabelR.font = [UIFont fontWithName:kGameFont size:kAppFontNormal];
    msgLabelR.numberOfLines = 0;
    msgLabelR.text = [NSString stringWithFormat:@"+ %ld × 100\n- %ld × 100\n%ld", (long)self.hp,(long)self.missStep,(long)self.score];
    
    [screenView addSubview:msgLabelR];
    
    if (self.score > self.best ) {
        //new best label
        UILabel *newBestLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgLabel.frame.origin.x, msgLabel.frame.origin.y-14-kBarGap, 62, 18)];
        
        newBestLabel.backgroundColor = kColorRed;
        newBestLabel.textColor =kColorYellow;
        newBestLabel.textAlignment =NSTextAlignmentCenter;
        
        newBestLabel.text = @"NEW BEST";
        
        newBestLabel.font  =[UIFont fontWithName:kGameFont size:11];
        
        newBestLabel.layer.cornerRadius = 4;
        
        newBestLabel.clipsToBounds = YES;
        
        [screenView addSubview:newBestLabel] ;
        
        [[GCHelper defaultHelper] reportScore:self.score forLeaderboardID:kLeaderBoardIdentifier];
        
        //[[GCHelper defaultHelper] reportScore:self.score forLeaderboardID:kLeaderBoardIdentifier];
    }

    
    
    //btn next
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    CGRect frame = CGRectMake(self.view.frame.size.width/2 - kButtonWidth/2 , barBottomLine - kButtonHeight - kBarGap ,kButtonWidth  ,kButtonHeight); // set values as per your requirement
    
    button.backgroundColor = kColorBlue ;
    button.titleLabel.font = [UIFont fontWithName:kGameFont size:kAppFontBig ];
    
    button.layer.cornerRadius = 4;
    
    button.clipsToBounds = YES;
    [button setTitle:@"Next" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    button.frame = frame;
    
    NSLog(@"player win!");
    
    [screenView addSubview:button];
    
    
    //btn share
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    shareButton.backgroundColor  = kColorBlue1;
    
    shareButton.frame = CGRectMake(self.view.frame.size.width/2 - kButtonWidth/2 , button.frame.origin.y -kBarGap-kButtonHeight ,kButtonWidth  ,kButtonHeight);
    
    [shareButton setTitle:@"Share" forState:UIControlStateNormal ];
    
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton.titleLabel.font = [UIFont fontWithName:kGameFont size:kAppFontBig];
    
    shareButton.layer.cornerRadius = 4;
    shareButton.clipsToBounds = YES;
    
    [screenView addSubview:shareButton];
    
    [self.view addSubview:screenView];
    //[self.view addSubview:button];
    //alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    //[alertView show];
    [self updateScore];
    [self updateBestScore];
    
}
//
//- (IBAction)shareButton:(id)sender {
//    [self shareContent];
//}
//
//- (IBAction)FacebookShare:(id)sender {
//    [self targetedShare:SLServiceTypeFacebook];
//}
//
//- (IBAction)TwitterShare:(id)sender {
//    [self targetedShare:SLServiceTypeTwitter];
//}
//
//
//- (IBAction)SinaShare:(id)sender {
//    [self targetedShare:SLServiceTypeSinaWeibo];
//}
//
//-(void)targetedShare:(NSString *)serviceType {
//    if([SLComposeViewController isAvailableForServiceType:serviceType]){
//        SLComposeViewController *shareView = [SLComposeViewController composeViewControllerForServiceType:serviceType];
//        
//        [shareView setInitialText:@"My too cool Son"];
//        [shareView addImage:[UIImage imageNamed:@"boyOnBeach"]];
//        [self presentViewController:shareView animated:YES completion:nil];
//        
//    } else {
//        
//        UIAlertView *alert;
//        alert = [[UIAlertView alloc]
//                 initWithTitle:@"You do not have this service"
//                 message:nil
//                 delegate:self
//                 cancelButtonTitle:@"OK"
//                 otherButtonTitles:nil];
//        
//        [alert show];
//    }
//    
//}

-(void)shareAction
{
    NSLog(@"share action...")   ;
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    
    UIImage *image = [self takeSnapshot];
    

    NSString * message = [NSString stringWithFormat:NSLocalizedString(@"WOW! I got %ld points of this game: %@ ", nil )  ,(long)self.score,kAppStoreURL];
    
    NSArray * shareItems = @[message, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    
}
-(void)nextAction
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    NSLog(@"next...");
    UIView *winView  = [self.view viewWithTag:kWinScreenTag];
    
    [winView removeFromSuperview];
    
    [self nextStage];
    
}
-(void)checkCellAtRow:(NSInteger ) row column:(NSInteger)column
{
    //is taped?
    if ( _tapedCell[column][row] == 1) {
       //is taped
        NSLog(@"this cell is taped!");
    }else{
        
        _tapedCell[column][row] = 1;
        
 
        NSInteger val = _level[column][row];
        
        switch (val) {
            case 0:
                //user miss
                [self playerMiss:row column:column];
                break;
                
            case 1:
                //user hit body
                [self playerHitBody:row column:column];
                break;
                
            case 2:
                //user hit body
                [self playerHitHead:row column:column];
                break;
                
            default:
                break;
        }
    
    //is game Win?
    if (self.gameWinPoint == kGameWinPoint) {
        [self playerWin];
        
    }
    }
}


- (void)addViewForCells:(NSSet *)cells {

    
    for (PGCell *cell  in cells) {
 
        SpiritView *view = [[SpiritView alloc] init];
        
        if (cell.cellType == 0) {
            view.backgroundColor = [UIColor colorWithHexString:@"#FD9B2A"];
            
        }
        
        //ADD TAP EVENT
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(cellTap:)];
        
        [view addGestureRecognizer:singleFingerTap ];
        
        view.userInfo = @{@"row":[NSNumber numberWithInteger:cell.row],@"column":[NSNumber numberWithInteger:cell.column]};
        
        view.layer.cornerRadius = 14;
        view.frame  = [self frameForColumn:cell.column row:cell.row];
        
        [self.mapView addSubview:view];
        cell.view = view  ;
    }
}

- (CGRect)frameForColumn:(NSInteger)column row:(NSInteger)row {
    
    CGFloat mapWidth = self.view.frame.size.width ;
    
    CGFloat cellSize = mapWidth/10;
    
    CGFloat circleSize = 28;
    
    CGRect cellFrame = CGRectMake((cellSize-circleSize)/2 +  row*cellSize, (cellSize-circleSize)/2 +  column*cellSize, circleSize, circleSize);
    return cellFrame;
    
}

-(BOOL)checkUserWin
{
    BOOL result = NO;
    
    if (self.gameWinPoint >= kGameWinPoint) {
        result =    YES;
    }
    
    return result;
    
}

-(void)makeMap
{
    //make a map view
    
    // make a 10*10 map
    UIView *oldMapView = [self.view viewWithTag:kMapViewTag];
    
    if (oldMapView) {
        [oldMapView removeFromSuperview];
        
    }
    
    CGFloat mapWidth = self.view.frame.size.width ;
    CGFloat mapHeigth = mapWidth;
    
    UIView *mapView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - mapHeigth/2 , mapWidth, mapHeigth)];
    mapView_.tag = kMapViewTag  ;
    
    //mapView.backgroundColor  = [UIColor yellowColor]    ;
    self.mapView  = mapView_;
    
   //CREATE CELL
    NSSet *initCell = [self createInitialCell];
    
    // ADD TO MAP VIEW
    [self addViewForCells:initCell];
    
    // SHOW
    [self.view addSubview:self.mapView];
 
}

-(void)hideFlashText
{
    self.flashLabel.text =@"";
}

-(void)flashText:(NSString *)text
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFlashText) object:nil];
    self.flashLabel.text = text;
    
    [self performSelector:@selector(hideFlashText) withObject:nil afterDelay:kFlashTextTime ];
}

-(void)resetLevel:(NSInteger)level stage:(NSInteger)stage
{
    //reset taped cell
    for (NSInteger i = 0; i < 10; i++) {
        
        for (NSInteger j = 0; j < 10; j++) {
            //
            _tapedCell[i][j] = 0;
            
        }
    }
    //update best score
    
    self.currentLevel = level;
    
    self.currentStage = stage ;
    _updateHpPoints = 0;
    
    self.missStep = 0;
    
    self.planesNum   =3;
    
    self.hp = 100 - self.currentLevel *10;
    [self updateHp];
    
    [self updateLevelLabel];
    
    self.gameWinPoint    =0;
    
    self.iconPlane1.hidden = NO;
    self.iconPlane2.hidden = NO;
    self.iconPlane3.hidden = NO;
    
    
    [self makeMap];
    
    
    [self makeRandomLevel];
    
}


-(void)gameEnd
{
    NSLog(@"game is totel end!");
    
}

-(void)updateLevelLabel
{
    self.levelLabel.text = [NSString stringWithFormat:@"Level: %ld-%ld",
                            (long)self.currentLevel+1,(long)self.currentStage+1];
}
-(void)nextStage
{

    
    self.currentStage ++;
    
    if (self.currentStage >= kStageCount) {
        
        self.currentLevel ++;
        self.currentStage =0;
        
        if (self.currentLevel >= kLevelCount ) {
            //game totel over
            [self gameEnd];
        }
    }
    
    [self resetLevel:self.currentLevel stage:self.currentStage];
    
}

-(NSInteger)bestScore
{
    NSInteger result = 0;
    
    NSNumber *bestScore = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyBestScore];
    
    if (bestScore) {
        result  = [bestScore integerValue];
    }
    
    return result;
    
}
-(void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE: %ld",(long)self.score ];
}
-(void)updateBestScore
{
    if (self.score > self.best) {
        
        self.best  = self.score;
         //
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.best] forKey:kKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    self.bestLabel.text =  [NSString stringWithFormat:@"BEST: %ld",(long)self.best];
}

-(void)soundBTNAction
{
    NSLog(@"sound on...");
    if ([OALSimpleAudio sharedInstance].muted == YES) {
        [self.soundBTN setImage:[UIImage imageNamed:@"btn-sound-on"] forState:UIControlStateNormal];
        [[OALSimpleAudio sharedInstance] setMuted:   NO];
    }else{
        [[OALSimpleAudio sharedInstance] setMuted:YES];
        [self.soundBTN setImage:[UIImage imageNamed:@"btn-sound-off"] forState:UIControlStateNormal];
    }
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    
}
-(void)addSoundBTN
{
    UIView *mapView = [self.view viewWithTag:kMapViewTag];
    
    UIButton *soundBTN = [UIButton buttonWithType:UIButtonTypeCustom];

    soundBTN.frame  = CGRectMake(8, mapView.frame.origin.y+ mapView.frame.size.height + 8,
                                 28, 28);
    
    [soundBTN setImage:[UIImage imageNamed:@"btn-sound-on"] forState:UIControlStateNormal];
    
    [soundBTN addTarget:self action:@selector(soundBTNAction) forControlEvents:UIControlEventTouchUpInside];
    self.soundBTN    = soundBTN ;
    
    [self.view addSubview:soundBTN];
    
}
-(void)updateLifeLabel
{
    self.lifeLabel.text =[NSString stringWithFormat:@"Life: %ld",(long)self.life];
    
}
-(void)addLifeLable
{
    UIView *mapView = [self.view viewWithTag:kMapViewTag];
    
    UILabel *lifeLable = [[UILabel alloc]init ];
    
    //UIButton *soundBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    
    lifeLable.frame  = CGRectMake(self.view.frame.size.width/2- 64/2, mapView.frame.origin.y+ mapView.frame.size.height + 8,
                                 64, 28);
    
    //[soundBTN setImage:[UIImage imageNamed:@"btn-sound-on"] forState:UIControlStateNormal];
    
    //[soundBTN addTarget:self action:@selector(soundBTNAction) forControlEvents:UIControlEventTouchUpInside];
    self.lifeLabel   = lifeLable;
    self.lifeLabel.font = [UIFont fontWithName:kGameFontBold size:kAppFontNormal ];
    self.lifeLabel.text = @"Life: 3";
    self.lifeLabel.textAlignment =NSTextAlignmentCenter;
    self.lifeLabel.textColor = kColorBlue;
    
    [self.view addSubview:lifeLable];
    
}

-(void)helpBTNAction
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    
    [self performSegueWithIdentifier:@"to_help" sender:nil];
    
}
-(void)addHelpBTN
{
    UIView *mapView = [self.view viewWithTag:kMapViewTag];
    
    UIButton *helpBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    
    helpBTN.frame  = CGRectMake(self.view.frame.size.width - (8+28), mapView.frame.origin.y+ mapView.frame.size.height + 8,
                                 28, 28);
    
    [helpBTN setImage:[UIImage imageNamed:@"btn-help"] forState:UIControlStateNormal];
    
    [helpBTN addTarget:self action:@selector(helpBTNAction) forControlEvents:UIControlEventTouchUpInside];
    //self.soundBTN    = soundBTN ;
    
    [self.view addSubview:helpBTN];
    
}
-(void)leaderboardBTNAction
{
    [[OALSimpleAudio sharedInstance] playEffect:kSoundDi];
    NSLog(@"leaderboard btn...");
    [[GCHelper defaultHelper]showLeaderboardOnViewController: self ];
    
    
}
-(void)addLeaderboardBTN
{
    UIView *mapView = [self.view viewWithTag:kMapViewTag];
    
    UIButton *leaderboardBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leaderboardBTN.frame  = CGRectMake(self.view.frame.size.width - (8+28)*2, mapView.frame.origin.y+ mapView.frame.size.height + 8,
                                28, 28);
    
    [leaderboardBTN setImage:[UIImage imageNamed:@"btn-leaderboard"] forState:UIControlStateNormal];
    
    [leaderboardBTN addTarget:self action:@selector(leaderboardBTNAction) forControlEvents:UIControlEventTouchUpInside];
    //self.soundBTN    = soundBTN ;
    
    [self.view addSubview:leaderboardBTN];
}

- (UIImage *)takeSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.hpLabel.font  = [UIFont fontWithName:kGameFontBold size:24];
    self.levelLabel.font = [UIFont fontWithName:kGameFontBold size:14];
    self.bestLabel.font = [UIFont fontWithName:kGameFontBold size:14];
    self.scoreLabel.font =[UIFont fontWithName:kGameFontBold size:14];
    self.flashLabel.font = [UIFont fontWithName:kGameFont size:12];
    self.flashLabel.text =@"";
    self.flashLabel.textColor = [UIColor colorWithHexString:@"#F4293C"];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4EDD5"];
    
 
    self.currentLevel  = 0;
    self.currentStage  = 0;
    self.score =0;
    self.life =3;
    
    self.best  =[ self bestScore];
    //self.best = 1200000;
    [self updateBestScore];
    
    self.missStep = 0;
    
    
    [self resetLevel:self.currentLevel stage:self.currentStage  ];
 
    
    //[self playerWin];
    [self addSoundBTN];
    [self addHelpBTN];
    [self addLeaderboardBTN];
    [self addLifeLable];
    
    //[self showLevel];
    //NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    //audio
    [OALSimpleAudio sharedInstance].allowIpod = NO;
    
    // Mute all audio if the silent switch is turned on.
    [OALSimpleAudio sharedInstance].honorSilentSwitch = YES;
     [[OALSimpleAudio sharedInstance] preloadEffect:kSoundDi];
     [[OALSimpleAudio sharedInstance] preloadEffect:kSoundExplosion];
     [[OALSimpleAudio sharedInstance] preloadEffect:kSoundHitbody];
     [[OALSimpleAudio sharedInstance] preloadEffect:kSoundHitHead];
     [[OALSimpleAudio sharedInstance] preloadEffect:kSoundHitMiss];
    [[OALSimpleAudio sharedInstance] preloadEffect:kSoundWin];
    
    
    
    //ads
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"ca-app-pub-8958462311896337/9026913607";
    self.bannerView.rootViewController = self;
    
    self.bannerView.layer.zPosition =99;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
    [self.bannerView loadRequest:request];
    
    //[self playerWin];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //game center
    //AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
 
    [[GCHelper defaultHelper] authenticateLocalUserOnViewController:self setCallbackObject:nil  withPauseSelector:nil ];
    //[[GCHelper defaultHelper] registerListener:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
