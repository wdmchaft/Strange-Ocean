//
//  PauseGameScene.m
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

#import "PauseGameScene.h"
#import "SceneController.h"
#import "PlayGameScene.h"

#import "SimpleAudioEngine.h"


@implementation PauseGame

+(id) PaGScene
{
	CCScene *PaGScene = [CCScene node];	
	PauseGame *layer = [PauseGame node];	
	[PaGScene addChild: layer];	
	return PaGScene;
}

// I believe that everything can be re-invented concerning the pause of this game. Good Luck if you try.

-(id) init
{
	if( (self=[super init] )) {
        defaults = [NSUserDefaults standardUserDefaults];

		SceneController *sceneController = [SceneController node];
		[self addChild:sceneController];		
		
		CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:0];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
		titleSprite.position = ccp(240, 275);
        [self addChild:titleSprite];
        
        CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"pauseTitle.png"];
        pauseTitleSprite.position = ccp(240, 225);
        [self addChild:pauseTitleSprite];

		// menu pause
		menuResume = [CCMenuItemImage itemFromNormalImage:@"resumeButton.png"		 
															  selectedImage: @"resumeButtonHover.png"		 
																	 target:sceneController		 
																   selector:@selector(doPopPaGScene:)];
		 
		menuRestart = [CCMenuItemImage itemFromNormalImage:@"restartButton.png"		 
															   selectedImage: @"restartButtonHover.png"		 
																	  target:sceneController		 
																	selector:@selector(replacePGScene:)];
        
		replayMenu = [CCMenu menuWithItems:menuResume, menuRestart, nil];
		replayMenu.position = ccp(240,160);
		[replayMenu alignItemsVerticallyWithPadding:10];
		[self addChild:replayMenu];
        
		CCMenuItemImage * menuMenu = [CCMenuItemImage itemFromNormalImage:@"menuButton.png"		 
															selectedImage: @"menuButtonHover.png"		 
																   target:sceneController
																 selector:@selector(replaceSGScene:)];
        
        pauseMenu = [CCMenu menuWithItems:menuMenu, nil];
		pauseMenu.position = ccp(240,99);
		[pauseMenu alignItemsVertically];
		[self addChild:pauseMenu];
		/////////////
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            soundButton = [CCMenuItemImage itemFromNormalImage:@"soundButton1.png"
                                                 selectedImage:@"soundButton1.png"
                                                        target:self
                                                      selector:@selector(activateSound:)]; 
        }
        else {
            soundButton = [CCMenuItemImage itemFromNormalImage:@"soundButton2.png"
                                                 selectedImage:@"soundButton2.png"
                                                        target:self
                                                      selector:@selector(activateSound:)]; 
        }
	
        soundMenu = [CCMenu menuWithItems:soundButton, nil];
        soundMenu.position = ccp(40,50);
        [self addChild:soundMenu];
        
        
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        
        if (sae.backgroundMusicVolume == 1) {
            bgMusicButton = [CCMenuItemImage itemFromNormalImage:@"musicButton1.png"
                                                   selectedImage:@"musicButton1.png"
                                                          target:self
                                                        selector:@selector(activateBgMusic:)];
        }
        else {
            bgMusicButton = [CCMenuItemImage itemFromNormalImage:@"musicButton2.png"
                                                   selectedImage:@"musicButton2.png"
                                                          target:self
                                                        selector:@selector(activateBgMusic:)];
        }
        
        bgMusicMenu = [CCMenu menuWithItems:bgMusicButton, nil];
        bgMusicMenu.position = ccp(78,50);
        [self addChild:bgMusicMenu];
        
        _gameMode = [defaults integerForKey:@"gameMode"];
        
        if (_gameMode == 1) {
            gmButton = [CCMenuItemImage itemFromNormalImage:@"setiPhone.png"
                                              selectedImage:@"setiPhone.png"
                                                     target:self
                                                   selector:@selector(changeGameMode:)];
        }
        else {
            gmButton = [CCMenuItemImage itemFromNormalImage:@"setFinger.png"
                                              selectedImage:@"setFinger.png"
                                                     target:self
                                                   selector:@selector(changeGameMode:)];
            
        }
        
        gmMenu = [CCMenu menuWithItems:gmButton, nil];
        gmMenu.position = ccp(116, 50);
        [self addChild:gmMenu];
    }
	return self;
}

- (void) dealloc
{
	
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];
}

- (void) onEnter
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StrangeOcean.mp3" loop:YES];
    [defaults setBool:NO forKey:@"isGameOn"];
    
    [defaults setBool:NO forKey:@"enableSounds"];

    self.isAccelerometerEnabled = YES;
    [super onEnter];
}

- (void) showAlertWithTitleInclinaison:(id)sender
{
    [self showAlertWithTitle:@"Inclinaison" message:@"L'iPhone ne doit pas être trop incliné."];
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{		
    float accelY = [acceleration x];    
    _accelY = [NSNumber numberWithFloat:accelY];
    
    static bool inclinaisonIsOK = YES;
    
    _gameMode = [defaults integerForKey:@"gameMode"];
    
    if (inclinaisonIsOK && _gameMode == 1) {
        if (accelY > 0.5 || accelY < -0.5) {
            [self removeChild:replayMenu cleanup:YES];
            menuResume = [CCMenuItemImage itemFromNormalImage:@"resumeButton.png"		 
                                                selectedImage: @"resumeButtonHover.png"		 
                                                       target:self		 
                                                     selector:@selector(showAlertWithTitleInclinaison:)];
            
            menuRestart = [CCMenuItemImage itemFromNormalImage:@"restartButton.png"		 
                                                 selectedImage: @"restartButtonHover.png"		 
                                                        target:self		 
                                                      selector:@selector(showAlertWithTitleInclinaison:)];
            
            replayMenu = [CCMenu menuWithItems:menuResume, menuRestart, nil];
            [replayMenu setOpacity:100];
            replayMenu.position = ccp(240,160);
            [replayMenu alignItemsVerticallyWithPadding:10];
            [self addChild:replayMenu];
            
            inclinaisonIsOK = NO;
        }
    }
    
    if (inclinaisonIsOK == NO) {
        if (accelY > -0.5 && accelY < 0.5) {
            SceneController *sceneController = [SceneController node];
            [self addChild:sceneController];
            [self removeChild:replayMenu cleanup:YES];
            menuResume = [CCMenuItemImage itemFromNormalImage:@"resumeButton.png"		 
                                                selectedImage: @"resumeButtonHover.png"		 
                                                       target:sceneController		 
                                                     selector:@selector(doPopPaGScene:)];
            
            menuRestart = [CCMenuItemImage itemFromNormalImage:@"restartButton.png"		 
                                                 selectedImage: @"restartButtonHover.png"		 
                                                        target:sceneController		 
                                                      selector:@selector(replacePGScene:)];
            
            replayMenu = [CCMenu menuWithItems:menuResume, menuRestart, nil];
            replayMenu.position = ccp(240,160);
            [replayMenu alignItemsVerticallyWithPadding:10];
            [self addChild:replayMenu];
            inclinaisonIsOK = YES;
        }
        
    }
    
    
    [defaults setObject:_accelY forKey:@"YAcceleration"];
}

- (void)activateSound:(id)sender
{
    [self removeChild:soundMenu cleanup:YES];

    if ([defaults boolForKey:@"soundIsEnable"]) {
        soundButton = [CCMenuItemImage itemFromNormalImage:@"soundButton2.png"
                                             selectedImage:@"soundButton2.png"
                                                    target:self
                                                  selector:@selector(activateSound:)]; 
        [defaults setBool:NO forKey:@"soundIsEnable"];
    }
    
    else {
        soundButton = [CCMenuItemImage itemFromNormalImage:@"soundButton1.png"
                                             selectedImage:@"soundButton1.png"
                                                    target:self
                                                  selector:@selector(activateSound:)]; 
        [defaults setBool:YES forKey:@"soundIsEnable"];
    }

    
    soundMenu = [CCMenu menuWithItems:soundButton, nil];
    soundMenu.position = ccp(40,50);
    [self addChild:soundMenu];
}

- (void)activateBgMusic:(id)sender
{
    SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
    
    [self removeChild:bgMusicMenu cleanup:YES];
    
    if (sae.backgroundMusicVolume == 1) {
        bgMusicButton = [CCMenuItemImage itemFromNormalImage:@"musicButton2.png"
                                               selectedImage:@"musicButton2.png"
                                                      target:self
                                                    selector:@selector(activateBgMusic:)]; 
        sae.backgroundMusicVolume = 0;
    }
    else {
        bgMusicButton = [CCMenuItemImage itemFromNormalImage:@"musicButton1.png"
                                               selectedImage:@"musicButton1.png"
                                                      target:self
                                                    selector:@selector(activateBgMusic:)]; 
        sae.backgroundMusicVolume = 1;
    }
    
    
    bgMusicMenu = [CCMenu menuWithItems:bgMusicButton, nil];
    bgMusicMenu.position = ccp(78,50);
    [self addChild:bgMusicMenu];
}

- (void) changeGameMode:(id)sender
{
    [self removeChild:gmMenu cleanup:YES];
    
    _gameMode = [defaults integerForKey:@"gameMode"];
    
    
    if (_gameMode == 1) {
        gmButton = [CCMenuItemImage itemFromNormalImage:@"setFinger.png"
                                          selectedImage:@"setFinger.png"
                                                 target:self
                                               selector:@selector(changeGameMode:)];
        [defaults setInteger:0 forKey:@"gameMode"];
    }
    
    else {
        gmButton = [CCMenuItemImage itemFromNormalImage:@"setiPhone.png"
                                          selectedImage:@"setiPhone.png"
                                                 target:self
                                               selector:@selector(changeGameMode:)];
        [defaults setInteger:1 forKey:@"gameMode"];
        
    }
    
    gmMenu = [CCMenu menuWithItems:gmButton, nil];
    gmMenu.position = ccp(116,50);
    [self addChild:gmMenu];
}

@end
