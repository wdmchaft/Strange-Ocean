//
//  PauseGameScene.h
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

#import "cocos2d.h"

#import "Strange_OceanAppDelegate.h"

@interface PauseGame : CCLayer
{
    NSUserDefaults *defaults;
    NSNumber *_accelY;
    
    NSDate *startPause;
    
    CCMenuItemImage *soundButton, *menuResume, *menuRestart, *bgMusicButton, *gmButton;
    CCMenu *soundMenu, *pauseMenu, *replayMenu, *bgMusicMenu, *gmMenu;
    
    int _gameMode;
}

+(id) PaGScene;

- (void) onEnter;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) activateSound:(id)sender;

- (void) activateBgMusic:(id)sender;

- (void) showAlertWithTitleInclinaison:(id)sender;

- (void) showAlertWithTitle: (NSString*)title message: (NSString*) essage;

- (void) changeGameMode:(id)sender;

@end

