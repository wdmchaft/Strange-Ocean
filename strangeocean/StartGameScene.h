//
//  StartGameScene.h
//  Strange Ocean
//
//  Created by Hugo CAILLARD (Cohars) on 30/01/11.
//  
//  Please read "ReadMe.txt".
//  This document is available under the Creative Commons License : BY-NC-SA.
//  http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//  Thank you.
//

#define FichierScoresDatas @"player_scores.plist"
#define FichierDurationsDatas @"player_durations.plist"

#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "GameCenterManager.h"

@interface StartGame : CCLayer <UIActionSheetDelegate, GameCenterManagerDelegate>
{
    
    GameCenterManager* gameCenterManager;
    
    NSMutableArray *playerScores, *playerDurations;
    
    CCMenuItemImage *playButton;
    CCMenu *menuPlay;
    
    CCMenuItemImage *soundButton, *bgMusicButton, *gmButton;
    CCMenu *soundMenu, *bgMusicMenu, *gmMenu;
    
    NSUserDefaults *defaults;
    NSNumber *_accelY;
    
    BOOL inclinaisonIsOK;
    
    int _gameMode;
}

+(CCScene *) SGScene;

// All the scenes of Strange Ocean are organized like this :
// • xxxxScene.h (header)
// • xxxxScene.m
// Read the header to have a quick look of the architecture of the functions.

- (void) onEnter;

- (IBAction) startTuto: (id)sender;

- (BOOL) isGameCenterAPIAvailable;       

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message;

- (void) showAlertWithTitleInclinaison:(id)sender;

- (NSString *) playerScoresAccess;

- (NSString *) playerDurationsAccess;

- (void) activateSound:(id)sender;

- (void) activateBgMusic:(id) sender;

- (void) changeGameMode:(id)sender;

@end

