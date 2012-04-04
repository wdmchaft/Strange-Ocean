//
//  LookHelpScene.h
//  Strange Ocean
//
//  Created by Hugo CAILLARD (Cohars) on 30/01/11.
//  
//  Please read "ReadMe.txt".
//  This document is available under the Creative Commons Licence : BY-NC-SA.
//  http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//  Thank you.
//

#define FichierScoresDatas @"player_scores.plist"
#define FichierDurationsDatas @"player_durations.plist"

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameCenterManager.h"

@class GKPlayer;

@interface GameOver: CCLayer <GameCenterManagerDelegate>
{
    NSUserDefaults *defaults;
    NSNumber *_accelY, *totalGameDuration;
    
    NSNumber *lastScore, *score1, *score2, *score3, * score4, *score5;
    
    NSMutableArray *playerScores, *playerDurations;
    NSString *durationMessage, *normalGameDuration, *scoreMessage;
    
	CCLabelTTF *finalScoreLabel, *finalDurationLabel;
    
    GameCenterManager* gameCenterManager;   
    int64_t score;
    
    int _gameMode;
    
    CCMenuItemImage *restartButton, *howToButton; 
    CCMenu *restartMenu, *howToMenu;
}
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

@property (nonatomic, retain) NSNumber *lastScore;
@property (nonatomic, retain) NSNumber *score1;
@property (nonatomic, retain) NSNumber *score2;
@property (nonatomic, retain) NSNumber *score3;
@property (nonatomic, retain) NSNumber *score4;
@property (nonatomic, retain) NSNumber *score5;

@property (nonatomic, assign) int64_t score;
@property (nonatomic, retain) NSMutableArray *playerScores;
@property (nonatomic, retain) NSMutableArray *playerDurations;

+(id) GOScene;

- (void) shareOnTwitter:(id)sender;

- (void) shareOnFacebook:(id)sender;

- (NSString *) playerScoresAccess;

- (NSString *) playerDurationsAccess;

- (void) onEnter;

- (IBAction)startTuto:(id)sender;

- (void) showAlertWithTitleInclinaison:(id)sender;

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) replaceSGScene: (CCMenuItem  *) menuItem;

- (void) replacePGScene: (CCMenuItem  *) menuItem;

@end