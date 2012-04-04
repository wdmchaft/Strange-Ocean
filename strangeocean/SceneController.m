//
//  SceneController.m
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

#import "SceneController.h"
#import "StartGameScene.h"
#import "PlayGameScene.h"
#import "PauseGameScene.h"
#import "LookScoresScene.h"
#import "LookHelpScene.h"
#import "LookCreditsScene.h"


@implementation SceneController

// The following functions manage the changement of view/scenes.

- (void) replaceSGScene: (CCMenuItem  *) menuItem
{
    [[CCDirector sharedDirector] resume];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isGameOn"];
    
    [[CCDirector sharedDirector] replaceScene:[StartGame SGScene]];
}

- (void) replacePGScene: (CCMenuItem  *) menuItem
{
    [[CCDirector sharedDirector] resume];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isGameOn"];
    
	[[CCDirector sharedDirector] replaceScene:[PlayGame PGScene]];
}

- (void) pushLSScene: (CCMenuItem  *) menuItem
{
	[[CCDirector sharedDirector] pushScene:[LookScores LSScene]];
}

- (void) pushLHScene: (CCMenuItem  *) menuItem
{
	[[CCDirector sharedDirector] pushScene:[LookHelp LHScene]];
}

- (void) pushLCScene:(CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] pushScene:[LookCredits LCScene]];
}

- (void) doPopScene: (CCMenuItem *) menuItem
{
	[[CCDirector sharedDirector] popScene];
}

- (void) pushPaGScene: (CCMenuItem  *) menuItem
{    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isGameOn"];
    
    [[CCDirector sharedDirector] pushScene:[PauseGame PaGScene]];
    [[CCDirector sharedDirector] pause];
}

- (void) doPopPaGScene: (CCMenuItem *) menuItem
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isGameOn"];
    
	[[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] resume];
}

@end
