//
//  GCHelper.h
//  SpaceInvadersGameCenter
//
//  Created by Alvin Stanescu on 21.09.13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

@import Foundation;
@import GameKit;

#define kLeaderBoardIdentifier @"theplanesgame.world.leaderboard" 

@interface GCHelper : NSObject<GKGameCenterControllerDelegate, GKChallengeListener> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, strong) NSArray* leaderboards;
@property (nonatomic, strong) NSMutableDictionary *achievementsDictionary;

+ (GCHelper*)defaultHelper;
- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector;

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier;
- (void)showLeaderboardOnViewController:(UIViewController*)viewController;

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier;
- (void)resetAchievements;
- (void)completeMultipleAchievements:(NSArray*)achievements;
- (void)registerListener:(id<GKLocalPlayerListener>)listener;

@end
