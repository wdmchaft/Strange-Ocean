//
//  StartGameScene.m
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

#import "SimpleAudioEngine.h"

#import "StartGameScene.h"
#import "PlayGameScene.h"
#import "LookTutoScene.h"
#import "SceneController.h"


@implementation StartGame


+(CCScene *) SGScene
{
	CCScene *SGScene = [CCScene node];	
	StartGame *layer = [StartGame node];	
	[SGScene addChild: layer];	
	return SGScene;
}

-(id) init
{
	if( (self=[super init] )) {
        
        if ([self isGameCenterAPIAvailable]) {
        gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
        
        if ([gameCenterManager isGameCenterAvailable]) {
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
        }
        }
                
        defaults = [NSUserDefaults standardUserDefaults];
        inclinaisonIsOK = YES;
                
        NSNumber *_zero = [NSNumber numberWithFloat:0];
        NSNumber *_intZero = [NSNumber numberWithInt:0];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:_zero, @"YAcceleration",_zero, @"isGameOn", _zero, @"totalGameTime", _zero, @"enableSounds", _zero, @"tirePiqueEnable", [NSNumber numberWithBool:YES], @"soundIsEnable", _intZero, @"gameMode", nil]];
        
        SceneController *sceneController = [SceneController node];
		[self addChild:sceneController];		
		
		CCSprite *backGroundSprite = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
		backGroundSprite.position = ccp(240,160);
		[self addChild:backGroundSprite];
    
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
		titleSprite.position = ccp(240, 275);
        [self addChild:titleSprite];
        
        playerScores = [[[NSMutableArray alloc] initWithContentsOfFile:[self playerScoresAccess]]autorelease];
        
        
        if (playerScores == nil) { // If the user plays for the first time.
            [self removeChild:menuPlay cleanup:YES];
            playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                selectedImage: @"selectedPlayButton.png"
                                                       target:self
                                                     selector:@selector(startTuto:)];
            // The user is redirected to the tutorial
            
            menuPlay = [CCMenu menuWithItems:playButton, nil];
            menuPlay.position = ccp(240,165);
            [menuPlay alignItemsVertically];		
            [self addChild:menuPlay z:4];
            
            NSNumber *currentScore = [[[NSNumber alloc] initWithInt:0]autorelease];
			NSNumber *score1 = [[[NSNumber alloc] initWithInt:0]autorelease];
			NSNumber *score2 = [[[NSNumber alloc] initWithInt:0]autorelease];
			NSNumber *score3 = [[[NSNumber alloc] initWithInt:0]autorelease];
			NSNumber *score4 = [[[NSNumber alloc] initWithInt:0]autorelease];
			NSNumber *score5 = [[[NSNumber alloc] initWithInt:0]autorelease];
			playerScores = [NSMutableArray arrayWithObjects:currentScore, score1, score2, score3, score4, score5, nil];
            
			[playerScores writeToFile:[self playerScoresAccess] atomically:YES];
            // The scores file is created
        }
        
        else {
            int score1 = [[playerScores objectAtIndex:1] integerValue];
            
            if (score1 <= 10) {
                [self removeChild:menuPlay cleanup:YES];
                playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                    selectedImage: @"selectedPlayButton.png"
                                                           target:self
                                                         selector:@selector(startTuto:)];		
                // If the best score of the player is less than 10, he's redirected to the tutorial.
                
                menuPlay = [CCMenu menuWithItems:playButton, nil];
                menuPlay.position = ccp(240,165);
                [menuPlay alignItemsVertically];		
                [self addChild:menuPlay z:4];
            }
        }       
     
        // We set the button for foleys.
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
        
        // We set the button for musics.
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
        
        // We set button for game mode, which can be with the finger or by tilting the device.
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

        playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                            selectedImage: @"selectedPlayButton.png"
                                                   target:sceneController
                                                 selector:@selector(replacePGScene:)];		
        
        menuPlay = [CCMenu menuWithItems:playButton, nil];
        menuPlay.position = ccp(240,165);
        [menuPlay alignItemsVertically];		
        [self addChild:menuPlay z:3];

        
        playerDurations = [[[NSMutableArray alloc] initWithContentsOfFile:[self playerDurationsAccess]]autorelease];
        
		if (playerDurations == nil){
            NSNumber *currentDuration = [[[NSNumber alloc] initWithInt:0]autorelease];
            NSNumber *totalDuration = [[[NSNumber alloc] initWithInt:0]autorelease];
            playerDurations = [NSMutableArray arrayWithObjects:currentDuration, totalDuration, nil];
            
            [playerDurations writeToFile:[self playerDurationsAccess] atomically:YES];
        }
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
    SceneController *sceneController = [SceneController node];
    [self addChild:sceneController];
    
    CCMenuItemImage *helpButton = [CCMenuItemImage itemFromNormalImage:@"helpButton.png"
                                                         selectedImage: @"helpButtonSelected.png"
                                                                target:sceneController
                                                              selector:@selector(pushLHScene:)];		
    
    CCMenu *menuHelp = [CCMenu menuWithItems:helpButton, nil];
    menuHelp.position = ccp(364,80);
    [menuHelp alignItemsVertically];		
    [self addChild:menuHelp z:3];
    
    CCMenuItemImage *scoresButton = [CCMenuItemImage itemFromNormalImage:@"scoresButton.png"
                                                           selectedImage: @"scoresButtonSelected.png"
                                                                  target:sceneController
                                                                selector:@selector(pushLSScene:)];		
    
    CCMenu *menuScores = [CCMenu menuWithItems:scoresButton, nil];
    menuScores.position = ccp(298,80);
    [menuScores alignItemsVertically];		
    [self addChild:menuScores z:3];
    
    CCMenuItemImage *creditButton = [CCMenuItemImage itemFromNormalImage:@"creditButton.png"
                                                           selectedImage: @"creditButton.png"
                                                                  target:sceneController
                                                                selector:@selector(pushLCScene:)];		
    
    CCMenu *creditMenu = [CCMenu menuWithItems:creditButton, nil];
    creditMenu.position = ccp(430,80);
    [creditMenu alignItemsVertically];		
    [self addChild:creditMenu z:3];
    
    // All sounds and musics are preloaded to shorten the loading time when the user press play.
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"tirePique.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fishMotion.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fishGreenEnemy.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"piqueRedEnemy.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fishHit.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"takeBonus.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Oceanus.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Underwater.mp3"];

    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StrangeOcean.mp3" loop:YES];


    self.isAccelerometerEnabled = YES;
    [super onEnter];
}


- (BOOL) isGameCenterAPIAvailable
{
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
    
    NSString *reqSysVer = @"4.1";            
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];            
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);            
    
    return (localPlayerClassAvailable && osVersionSupported);
}

- (void) showAlertWithTitleInclinaison:(id)sender
{
    // We can't detect the angle of the device if it is vertically, so we say to the user that
    // he have to place is iPhone quite horizontally.
    [self showAlertWithTitle:@"Inclinaison" message:@"L'iPhone ne doit pas être trop incliné."];
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
}

- (NSString *) playerScoresAccess
{ 
	NSArray *chemins = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dossierDocuments = [chemins objectAtIndex:0];
	return [dossierDocuments stringByAppendingPathComponent:FichierScoresDatas];
}

- (NSString *) playerDurationsAccess
{ 
	NSArray *chemins = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dossierDocuments = [chemins objectAtIndex:0];
	return [dossierDocuments stringByAppendingPathComponent:FichierDurationsDatas];
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
    gmMenu.position = ccp(116, 50);
    [self addChild:gmMenu];
}
   
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float accelY = [acceleration x];    
    _accelY = [NSNumber numberWithFloat:accelY];
    
    _gameMode = [defaults integerForKey:@"gameMode"];

    
    // We unactivate the Play button if the device isn't placed horizontally enough and the game mode is "with finger".
    
    if (inclinaisonIsOK && _gameMode ==1) {
        if (accelY > 0.5 || accelY < -0.5) {
            [self removeChild:menuPlay cleanup:YES];
            playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                selectedImage: @"selectedPlayButton.png"
                                                       target:self
                                                     selector:@selector(showAlertWithTitleInclinaison:)];		
            
            menuPlay = [CCMenu menuWithItems:playButton, nil];
            [menuPlay setOpacity:100];
            menuPlay.position = ccp(240,165);
            [menuPlay alignItemsVertically];		
            [self addChild:menuPlay z:4];
            inclinaisonIsOK = NO;
        }
    }
    
    if (inclinaisonIsOK == NO) {        
        SceneController *sceneController = [SceneController node];
        [self addChild:sceneController];

        
        if (accelY > -0.5 && accelY < 0.5) {
            if (playerScores == nil) {            
                [self removeChild:menuPlay cleanup:YES];
                playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                    selectedImage: @"selectedPlayButton.png"
                                                           target:self
                                                         selector:@selector(startTuto:)];		
                
                menuPlay = [CCMenu menuWithItems:playButton, nil];
                menuPlay.position = ccp(240,165);
                [menuPlay alignItemsVertically];		
                [self addChild:menuPlay z:4];
            }
            
            else {
                playerScores = [[[NSMutableArray alloc] initWithContentsOfFile:[self playerScoresAccess]]autorelease];
                int score1 = [[playerScores objectAtIndex:1] integerValue];                
                if (score1 <= 10) {
                    [self removeChild:menuPlay cleanup:YES];
                    playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                        selectedImage: @"selectedPlayButton.png"
                                                               target:self
                                                             selector:@selector(startTuto:)];		
                    
                    menuPlay = [CCMenu menuWithItems:playButton, nil];
                    menuPlay.position = ccp(240,165);
                    [menuPlay alignItemsVertically];		
                    [self addChild:menuPlay z:4];
                }
                
                if (score1 > 10) {
                    [self removeChild:menuPlay cleanup:YES];
                    playButton = [CCMenuItemImage itemFromNormalImage:@"playButton.png"
                                                        selectedImage: @"selectedPlayButton.png"
                                                               target:sceneController
                                                             selector:@selector(replacePGScene:)];				
                    
                    menuPlay = [CCMenu menuWithItems:playButton, nil];
                    menuPlay.position = ccp(240,165);
                    [menuPlay alignItemsVertically];		
                    [self addChild:menuPlay z:4];
                }
            }
        inclinaisonIsOK = YES;
        }

    }
    
    [defaults setObject:_accelY forKey:@"YAcceleration"];
}

- (IBAction)startTuto:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LookTuto LTScene]];
}

@end
