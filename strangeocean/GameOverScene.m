//
//  LookHelpScene.m
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

#import "GameOverScene.h"
#import "SceneController.h"

#import "PlayGameScene.h"
#import "StartGameScene.h"
#import "LookTutoScene.h"

#import "SHK.h"
#import "SHKItem.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"

#import "SimpleAudioEngine.h"

@implementation GameOver

@synthesize gameCenterManager;

@synthesize lastScore;
@synthesize score1, score2, score3, score4, score5;

@synthesize score;
@synthesize playerScores, playerDurations;

+(id) GOScene
{
	CCScene *GOScene = [CCScene node];	
	GameOver *layer = [GameOver node];	
	[GOScene addChild: layer];	
	return GOScene;
}

// 'cause we are all losers !

-(id) init
{

	if( (self=[super init] )) {
        defaults = [NSUserDefaults standardUserDefaults];
        _gameMode = [defaults integerForKey:@"gameMode"];
                
        gameCenterManager= [[[GameCenterManager alloc] init] autorelease];

		restartButton = [CCMenuItemImage itemFromNormalImage:@"goRestartButton.png"		 
                                               selectedImage: @"goRestartButton.png"		 
                                                      target:self		 
                                                    selector:@selector(replacePGScene:)];
        
        restartMenu = [CCMenu menuWithItems:restartButton, nil];
		restartMenu.position = ccp(113,184);
		[restartMenu alignItemsVertically];
		[self addChild:restartMenu z:2];
		
		CCMenuItemImage *menuMenu = [CCMenuItemImage itemFromNormalImage:@"goMenuButton.png"		 
															selectedImage: @"goMenuButton.png"		 
																   target:self
																 selector:@selector(replaceSGScene:)];	
		
		CCMenu *GOMenu = [CCMenu menuWithItems: menuMenu, nil];
		GOMenu.position = ccp(189,184);
		[GOMenu alignItemsVertically];
		[self addChild:GOMenu z:2];
		/////////////////
		
		CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:0];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
		titleSprite.position = ccp(240, 275);
        [self addChild:titleSprite];
        
        CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"gameoverTitle.png"];
        pauseTitleSprite.position = ccp(240, 225);
        [self addChild:pauseTitleSprite];
		
		finalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"SCORE : 0"]
											 fontName:@"BebasNeue.otf"
											 fontSize:15];
		finalScoreLabel.position = ccp(385,184);
		[self addChild:finalScoreLabel z:2];
		finalScoreLabel.color = ccc3(144,85,25);
        
        CCSprite *scoreCadre = [CCSprite spriteWithFile:@"goScore.png"];
        scoreCadre.position = ccp(388,184);
        [self addChild:scoreCadre];
		
		finalDurationLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"GAME TIME : 00:00:00"]
											 fontName:@"BebasNeue.otf"
											 fontSize:15];
		finalDurationLabel.position = ccp(279,184);
		[self addChild:finalDurationLabel z:2];
		finalDurationLabel.color = ccc3(144, 85, 25);
        
        CCSprite *gameTime = [CCSprite spriteWithFile:@"goGameTime.png"];
        gameTime.position = ccp(282, 184);
        [self addChild:gameTime];
        
        
        CCLabelTTF *shareLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"SHARE YOUR SCORE ON:"]
                                        fontName:@"BebasNeue.otf"
                                        fontSize:15];
		shareLabel.position = ccp(132,146);
		[self addChild:shareLabel z:2];
		shareLabel.color = ccc3(249,203,126);
        
		// ---------------------Durations------------------------		
 		playerDurations = [[NSMutableArray alloc] initWithContentsOfFile:[self playerDurationsAccess]];
		NSNumber *finalGameDuration = [playerDurations objectAtIndex:0];
		
		int inputSeconds = [finalGameDuration intValue];
		int hours =  inputSeconds / 3600;
		int minutes = ( inputSeconds - hours * 3600 ) / 60; 
		int seconds = inputSeconds - hours * 3600 - minutes * 60; 
		
		normalGameDuration = [NSString stringWithFormat:@"GAME TIME : %.2d:%.2d:%.2d", hours, minutes, seconds];
		
		durationMessage = [[NSString alloc]
									 initWithFormat: @"%@", normalGameDuration];
		[finalDurationLabel setString:(NSString *)durationMessage];
        
        totalGameDuration = [playerDurations objectAtIndex:1];
        int _totalGameDuration = [totalGameDuration intValue];
        int _finalGameDuration = [finalGameDuration intValue];
        _totalGameDuration = _totalGameDuration + _finalGameDuration;
        totalGameDuration = [[NSNumber alloc] initWithInt:_totalGameDuration];
        [playerDurations replaceObjectAtIndex:1 withObject:totalGameDuration];
		
		[playerDurations writeToFile:[self playerDurationsAccess] atomically:YES];

		// -----------------------Scores--------------------------
		playerScores = [[NSMutableArray alloc] initWithContentsOfFile:[self playerScoresAccess]];

		lastScore = [playerScores objectAtIndex:0];
		int _lastScore = [lastScore intValue];
        score = [lastScore intValue];
        
		scoreMessage = [[NSString alloc]
                        initWithFormat: @"SCORE : %d", _lastScore];
		[finalScoreLabel setString:(NSString *)scoreMessage];
        
		
        static int z;
        
        for (z = 1 ; z < 6 ; z++) {
            NSNumber *bestScore = [playerScores objectAtIndex:z];
            int _bestScore = [bestScore intValue];
            if (_lastScore >= _bestScore){
                [playerScores insertObject:lastScore atIndex:z];
                [playerScores removeLastObject];
                z = 6;
            }
        }
        [playerScores writeToFile:[self playerScoresAccess] atomically:YES];
		
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
       
        if(score > 0 && [gameCenterManager isGameCenterAvailable] && localPlayer.authenticated)
        {
            [gameCenterManager reportScore:score];
        }
        
        
        if (_lastScore <= 20) {
            
            howToButton = [CCMenuItemImage itemFromNormalImage:@"howToButton.png"
                                                 selectedImage:@"howToButton.png"
                                                        target:self 
                                                      selector:@selector(startTuto:)];
            
            howToMenu = [CCMenu menuWithItems:howToButton, nil];
            [howToMenu setPosition:ccp(112, 63)];
            [howToMenu alignItemsVertically];
            [self addChild:howToMenu z:2];
        }
        
        // Social Networks
        /* 
        
        Look at the ShareKit documentation to know more about the share on twitter, facebook and other services
         
        */
        ////////
        /*
        CCMenuItemImage *postTwitter = [CCMenuItemImage itemFromNormalImage:@"twitterButton.png"		 
                                                           selectedImage: @"twitterButton.png"		 
                                                                  target:self
                                                                   selector:@selector(shareOnTwitter:)];
        
        CCMenuItemImage *postFb = [CCMenuItemImage itemFromNormalImage:@"fbButton.png"		 
                                                           selectedImage: @"fbButton.png"		 
                                                                  target:self
                                                                selector:@selector(shareOnFacebook:)];
		
		CCMenu *shareMenu = [CCMenu menuWithItems: postFb, postTwitter, nil];
		shareMenu.position = ccp(106, 110);
		[shareMenu alignItemsHorizontally];
		[self addChild:shareMenu z:3];
         
        */
    }
    
	return self;
}

- (void) shareOnTwitter:(id)sender
{    
    SHKItem *twitterItem = [SHKItem text:[NSString stringWithFormat:@"I scored %i in #StrangeOcean ! via @GielveApps", score]];
    [SHKTwitter shareItem:twitterItem];
}

- (void) shareOnFacebook:(id)sender
{    
    SHKItem *fbItem = [SHKItem text:[NSString stringWithFormat:@"I scored %i in StrangeOcean ! via http://www.facebook.com/Gielve", score]];
    [SHKFacebook shareItem:fbItem];
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

- (void) dealloc
{
    [durationMessage release];
    durationMessage = nil;
    [scoreMessage release];
    scoreMessage = nil;
    
	[super dealloc];
}

- (void) onEnter
{    
    if ([gameCenterManager isGameCenterAvailable]) {
        [gameCenterManager setDelegate: self];
        [gameCenterManager authenticateLocalUser];
    }
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StrangeOcean.mp3" loop:YES];
    
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
    if (_gameMode == 1) {
    float accelY = [acceleration x];    
    _accelY = [NSNumber numberWithFloat:accelY];
    
    static bool inclinaisonIsOK = YES;
    
    if (inclinaisonIsOK) {
        if (accelY > 0.5 || accelY < -0.5) {
            [self removeChild:restartMenu cleanup:YES];
            restartButton = [CCMenuItemImage itemFromNormalImage:@"goRestartButton.png"		 
                                                   selectedImage: @"goRestartButton.png"		 
                                                          target:self		 
                                                        selector:@selector(showAlertWithTitleInclinaison:)];
            restartMenu = [CCMenu menuWithItems:restartButton, nil];
            restartMenu.position = ccp(113,184);
            [restartMenu setOpacity:100];
            [restartMenu alignItemsVertically];
            [self addChild:restartMenu z:2];            
            inclinaisonIsOK = NO;
        }
    }
    
    if (inclinaisonIsOK == NO) {
        if (accelY > -0.5 && accelY < 0.5) {
            [self removeChild:restartMenu cleanup:YES];
            SceneController *sceneController = [SceneController node];
            [self addChild:sceneController];
            
            restartButton = [CCMenuItemImage itemFromNormalImage:@"goRestartButton.png"		 
                                                   selectedImage: @"goRestartButton.png"		 
                                                          target:self		 
                                                        selector:@selector(replacePGScene:)];
            
            restartMenu = [CCMenu menuWithItems:restartButton, nil];
            restartMenu.position = ccp(113,184);
            [restartMenu alignItemsVertically];
            [self addChild:restartMenu z:2];
            inclinaisonIsOK = YES;
        }        
    }
    
   [defaults setObject:_accelY forKey:@"YAcceleration"];
        
    }
}

- (void) replaceSGScene: (CCMenuItem  *) menuItem
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isGameOn"];
    
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] replaceScene:[StartGame SGScene]];
}

- (void) replacePGScene: (CCMenuItem  *) menuItem
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isGameOn"];
    
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] replaceScene:[PlayGame PGScene]];
}

- (IBAction)startTuto:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LookTuto LTScene]];
}

@end
