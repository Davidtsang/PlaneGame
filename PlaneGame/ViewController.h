//
//  ViewController.h
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HexString.h"
#import "ObjectAL.h"
@import GameKit;
@import GoogleMobileAds;

#define kAppFontHuge 32
#define kAppFontLarge 24
#define kAppFontBig 18
#define kAppFontNormal 14
#define kAppFontSmall 12
#define kAppStoreURL @"https://itunes.apple.com/app/id975959162&mt=8"


#define kColorYellow  [UIColor colorWithHexString:@"FDD22A"]
#define kColorRed  [UIColor colorWithHexString:@"F4293C"]

#define kColorRed4  [UIColor colorWithHexString:@"B80012"]

#define kColorBlue  [UIColor colorWithHexString:@"2177A0"]
#define kColorBlue1  [UIColor colorWithHexString:@"88949A"]
#define kColorBlue4  [UIColor colorWithHexString:@"015279"]

#define kGameFont @"DroidSansFallback"
#define kGameFontBold @"DroidSans-Bold"
#define kFlashTextTime 2.0f
// SCORE = TIME 100s = 100 hp 1s = 200 ponit / HP 1hp = 1000 point
#define kGameWinPoint 33

#define kCellColorMiss  [UIColor whiteColor]
#define kCellColorHit  kColorBlue
#define kCellColorHitHead kColorRed

#define kLevelCount 7
#define kStageCount 7

//screen view
#define kBarHeight 240
#define kTitleWidth 200
#define kTitleHeight 44
#define kButtonWidth 106
#define kButtonHeight 32
#define kMsgLabelHeight 58
#define kBarGap 8

//
#define kKeyBestScore @"best_score"


#define kSoundDi @"di.caf"
#define kSoundHitMiss @"hit-miss.caf"
#define kSoundHitHead @"hit-head.caf"
#define kSoundHitbody @"hit-body.caf"
#define kSoundExplosion @"explosion.caf"
#define kSoundWin @"win.caf"
#define kSoundGameOver @"gameover.caf"


@interface ViewController : UIViewController
<GKLocalPlayerListener>

@property(nonatomic,assign)NSInteger currentLevel; // 1-7

@property(nonatomic,assign)NSInteger currentStage; //1-10

@property(nonatomic,assign)NSInteger missStep;

@property(nonatomic,assign)NSInteger gameWinPoint;

@property(nonatomic,strong)UIButton *soundBTN;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (nonatomic,assign)NSInteger life;

@property(nonatomic,strong)UILabel *lifeLabel;

@end

