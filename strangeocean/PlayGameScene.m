//
//  PlayGameScene.m
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

#import "PlayGameScene.h"
#import "GameOverScene.h"
#import "SceneController.h"

#import "PauseGameScene.h"


#define SIGNE(x) ((x < 0.0f) ? -1.0f : 1.0f)

@implementation PlayGame

@synthesize firstAddEnemyRedDate;
@synthesize firstAddEnemyGreenDate;
@synthesize firstAddCalamari;
@synthesize firstAddLifeBonusDate;
@synthesize firstAddPoisonBonusDate;

//  WTF ? Everything concerning the game is in the file. It's pretty unreadable...
//  Of course it's easier if you start by reading the header (PlayGameScene.h),
//  so you can quickly see all functions.

// I guess that the hard part of this file is all the variables that you have to "learn".

+(id) PGScene
{
	CCScene *PGScene = [CCScene node];	
	PlayGame *layer = [PlayGame node];	
	[PGScene addChild: layer];	
	return PGScene;
}

-(id) init
{
	if( (self=[super init] )) {
        _pique = [[NSMutableArray alloc] init]; // all lances (pique = lance)
        _enemyRed = [[NSMutableArray alloc] init]; // all red enemies
        _enemyGreen = [[NSMutableArray alloc]init]; // all green enemies
        _lifeFiole = [[NSMutableArray alloc] init]; // all blue vials
        _poisonFiole = [[NSMutableArray alloc] init]; // all red vials
        piqueToDelete = [[NSMutableArray alloc] init]; // lances which as to be deleted
        enemyRedAction = [[NSMutableArray alloc] init]; 
        enemyGreenAction = [[NSMutableArray alloc] init];
        lifeFioleToDelete = [[NSMutableArray alloc] init];
        poisonFioleToDelete = [[NSMutableArray alloc] init];
        badPique = [[NSMutableArray alloc] init]; // lances that touched a green enemy - they go back to center and hurt the yellow fish
        badPiqueMoving = [[NSMutableArray alloc] init];
        badPiqueToDelete = [[NSMutableArray alloc] init];
        _calamariSprite = [[NSMutableArray alloc] init];
        _inkSprite = [[NSMutableArray alloc] init];
        enemyRedToDelete = [[NSMutableArray alloc] init];
        enemyGreenToDelete = [[NSMutableArray alloc] init];
        
        // Nice introduction to all the sprites of the game and how the are organized !
        
        self.isAccelerometerEnabled = YES;
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
        
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:0 forKey:@"totalGameTime"];
        startYAccel = [defaults floatForKey:@"YAcceleration"];
        
		
		score = 20, life = 10, poison = 0, numberCalamari = 0;
        
        
        // Everything about the time.
		firstAddLifeBonusDate = [[NSDate alloc] init];
		firstAddPoisonBonusDate = [[NSDate alloc] init];
        firstAddEnemyRedDate = [[NSDate alloc] init];
        [firstAddEnemyRedDate retain];
        firstAddEnemyGreenDate = [[NSDate alloc] init];
        [firstAddEnemyGreenDate retain];
        firstAddCalamari = [[NSDate alloc] init];
        [firstAddCalamari retain];
        
        
        // The red and green fishes are especial 'cause they're animated
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyRed.plist"];
        enemyRedSpriteSheet = [CCSpriteBatchNode 
                               batchNodeWithFile:@"enemyRed.png"];
        [self addChild:enemyRedSpriteSheet];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyGreen.plist"];
        enemyGreenSpriteSheet = [CCSpriteBatchNode 
                               batchNodeWithFile:@"enemyGreen.png"];
        [self addChild:enemyGreenSpriteSheet];
		
		SceneController *sceneController = [SceneController node];
		[self addChild:sceneController];
		
        // bouton pause
		CCMenuItem * pauseButton = [CCMenuItemImage itemFromNormalImage:@"pauseButton.png"
                                                          selectedImage:@"pauseButton.png"
                                                                 target:sceneController
                                                               selector:@selector(pushPaGScene:)];
		
		CCMenu *gamePause = [CCMenu menuWithItems:pauseButton, nil];
		gamePause.position = ccp (455,25);		
		[self addChild:gamePause z:9];
		
		CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground2.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:0];
        
        CCSprite *seaSprite2 = [CCSprite spriteWithFile:@"sea2.png"];
        seaSprite2.position = ccp(240, 160);
        [self addChild:seaSprite2 z:8];
        
        inkSprite = [CCSprite spriteWithFile:@"inkSprite.png"];
		
		scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"0"] fontName:@"Marker Felt" fontSize:18];
		[scoreLabel setAnchorPoint:ccp(1, 1)];
		[scoreLabel setPosition:ccp(475, 315)];
		[self addChild:scoreLabel z:9];
		scoreLabel.color = ccc3(47, 47, 47);
		
		lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"100"] fontName:@"Marker Felt" fontSize:18];
		[lifeLabel setAnchorPoint:ccp(0, 1)];
		[lifeLabel setPosition:ccp(5, 315)];
		[self addChild:lifeLabel z:9];
		lifeLabel.color = ccc3(47, 47, 47);
		
		fishSprite = [CCSprite spriteWithFile:@"fish.png"];
		fishSprite.position = ccp(240,160);
		[self addChild:fishSprite z:7];	
        
		[fishSprite retain];
	}
	return self;
}

- (void) dealloc
{	
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
	[scoreLabel release];
    scoreLabel = nil;
    [lifeLabel release];
    lifeLabel = nil;
    
    [restartGameDate release];
    [firstAddLifeBonusDate release];
    [firstAddPoisonBonusDate release];
    [firstAddEnemyRedDate release];
    [firstAddEnemyGreenDate release];
    [firstAddCalamari release];
    
    [inkSendDate release];
	
    [_pique release];    
	_pique = nil;
	[_enemyRed release];
	_enemyRed = nil;
    [_enemyGreen release];
	_enemyGreen = nil;
	[enemyRedAction release];
	enemyRedAction = nil;
    [enemyGreenAction release];
	enemyGreenAction = nil;
	[piqueToDelete release];
    piqueToDelete = nil;
    [_calamariSprite release];
    _calamariSprite = nil;
    [_inkSprite release];
    _inkSprite = nil;
    
    [enemyGreenToDelete release];
    enemyGreenToDelete = nil;
    [enemyRedToDelete release];
    enemyRedToDelete = nil;
    [badPiqueToDelete release];
    badPiqueToDelete = nil;
    
    [badPique release];
    badPique = nil;
    [badPiqueMoving release];
    badPiqueMoving = nil;
    
	[lifeFioleToDelete release];
    lifeFioleToDelete = nil;
    [poisonFioleToDelete release];
    poisonFioleToDelete = nil;
    [_lifeFiole release];
    _lifeFiole = nil;
    [_poisonFiole release];
    _poisonFiole = nil;
    
    [playerDurations release];
    playerDurations = nil;
    [playerScores release];
    playerScores = nil;
    
    // |^| Hum, was it really useful. I can't remember. (>.>)
	
	[super dealloc];
}

- (void) onEnter
{    
    [defaults setBool:YES forKey:@"isGameOn"];
    [defaults setBool:YES forKey:@"enableSounds"];
    [defaults setBool:YES forKey:@"tirePiqueEnable"]; // Without it, the user can launch lances in the pause menu. So...
    
    restartGameDate = [[NSDate alloc] init];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    int whichMusic = arc4random() % 2;
    
    if (whichMusic == 1) {    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Underwater.mp3" loop:YES];
    }
    
    if (whichMusic ==0) {    
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Oceanus.mp3" loop:YES];
    }
    
    self.isAccelerometerEnabled = YES;
    
    _gameMode =  [defaults integerForKey:@"gameMode"];
    
    if (_gameMode == 1) {
        moveRound = [CCSprite spriteWithFile:@"canMoveButton.png"];
        moveRound.position = ccp(9,9);
        [self addChild:moveRound z:8]; 
        // the "MoveRound" is the little green or red round in bottom left hand corner. Which indicate if the player can move or not.
        // Look at the "autorise" function.
    }
    
    if (_gameMode == 0 && moveRound != nil) {
        [self removeChild:moveRound cleanup:YES];
    }
    
    bool isGameOn = [defaults boolForKey:@"isGameOn"];
    if (isGameOn == YES) {
        [self schedule:@selector(update:)];
        [self schedule:@selector(deleteSprites:)];
        [self schedule:@selector(timerEnemy:)];
        [self schedule:@selector(addBonus:)];
        
        // all these functions are called regularly
        // It's not the best way to do it, right ?
        
        if (_gameMode == 1)
        {
            [self schedule:@selector(autorise:) interval:0.03];
        }
    }
    [super onEnter];
}

- (void) onExit
{
    [defaults setBool:NO forKey:@"enableSounds"];
    [defaults setBool:NO forKey:@"tirePiqueEnable"];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    NSTimeInterval _partGameTime = -([restartGameDate timeIntervalSinceNow]);
    float _totalGameTime = [defaults floatForKey:@"totalGameTime"] + _partGameTime;
    [defaults setFloat:_totalGameTime forKey:@"totalGameTime"];
    
    [super onExit];
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

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{	
	
    if (_gameMode == 1) {
        float angleX = -[acceleration y];
        float angleY = [acceleration x] - startYAccel;
        destinationX = -[acceleration y];
        destinationY = [acceleration x] - startYAccel;
        
        float distanceX = fabsf(240 - fishSprite.position.x);
        float distanceY = fabsf(160 - fishSprite.position.y);
        float distance = sqrtf((distanceX*distanceX)+(distanceY*distanceY));
        CGPoint center = ccp (240, 160);
        
        // Here we set all the possible destinations of the fish by tilting the device.
        // It's quite repetitive.
        
        if ((destinationX*destinationX)+(destinationY*destinationY) > 0.15 && distance > 0) {
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        
        // destination1
        if (angleX < -0.17 && angleY < -0.22 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination1 = ccp (90, 70);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination1];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-120];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:55];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination2
        else if (angleX < -0.3 && angleY < 0.25 && angleY > -0.25 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination2 = ccp (90, 160);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination2];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-90];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:-270];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination3
        else if (angleX < -0.17 && angleY > 0.22 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination3 = ccp (90, 250);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination3];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-60];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:110];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination4
        else if (angleX > -0.3 && angleX < 0.25 && angleY > 0.25 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination4 = ccp (240, 260);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination4];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-0];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:-180];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination5
        else if (angleX > 0.17 && angleY > 0.22 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination5 = ccp (390, 250);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination5];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:60];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:-110];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination6
        else if (angleX > 0.3 && angleY > -0.25 && angleY < 0.25 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination6 = ccp (390, 160);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination6];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:90];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:-90];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination7
        else if (angleX > 0.17 && angleY < -0.22 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination7 = ccp (390, 70);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination7];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:120];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:-55];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];
            fishCanMove = 0;
        }
        // destination8
        else if (angleX > -0.3 && angleX < 0.25 && angleY < -0.25 && fishCanMove == 1) {
            [fishSprite stopAllActions];
            CGPoint destination8 = ccp (240, 70);
            id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination8];
            id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
            [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
            id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-180];
            id usualRotate = [CCRotateTo actionWithDuration:10 angle:0];
            [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
            
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canNotMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8]; 
            fishCanMove = 0;
        }
        
        else {}
    }
    
    /*
     Yes I know...
    */
}

- (void) autorise:(ccTime)dt // autorise => enable
{    
	// The fish has to go back in center and the device has to get back at its initial position.
    // So the fish can move again.
    
    // Set "fishCanMove == 1" all the time to see what it does.
    
    if (fishSprite.position.x == 240 && fishSprite.position.y == 160 && (destinationX*destinationX) < 0.04 && (destinationY*destinationY) < 0.04 ) {
        if (fishCanMove != 1) {
            [self removeChild:moveRound cleanup:YES];
            moveRound = [CCSprite spriteWithFile:@"canMoveButton.png"];
            moveRound.position = ccp(9,9);
            [self addChild:moveRound z:8];            
            fishCanMove = 1;
        }

	}
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    firstTouch = convertedLocation;
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint center = ccp (240, 160);
    
    BOOL touchInCenter = NO;
    
    // Here we set the destinations of the fish when the game mode is "with finger".
    
    if (firstTouch.x > 200 && firstTouch.x < 280 && firstTouch.y > 120 && firstTouch.y < 200)
    {
        touchInCenter = YES; // If the finger starts from the middle of the screen.
        // The fish can move.
    }
  
    // destination1
	if (touchInCenter && convertedLocation.x < 90 && convertedLocation.y < 100 && _gameMode == 0) {
        // The user's finger started from the center && it ended at the good place && the game mode is "with finger"
		[fishSprite stopAllActions];
		CGPoint destination1 = ccp (90, 70);
        id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination1];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-120];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:55]; // THIS, is quite useless.
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination2
	else if (touchInCenter && convertedLocation.x < 100 && convertedLocation.y > 115 && convertedLocation.y < 205 && _gameMode == 0) {
		[fishSprite stopAllActions];
		CGPoint destination2 = ccp (90, 160);
        id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination2];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-90];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:-270];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination3
	else if (touchInCenter && convertedLocation.x < 90 && convertedLocation.y > 220 && _gameMode == 0) {
		[fishSprite stopAllActions];
		CGPoint destination3 = ccp (90, 250);
        id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination3];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-60];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:110];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination4
	else if (touchInCenter && convertedLocation.x > 210 && convertedLocation.x < 270 && convertedLocation.y > 220 && _gameMode == 0) {
        [fishSprite stopAllActions];
		CGPoint destination4 = ccp (240, 260);
		id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination4];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-0];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:-180];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}

	}
	// destination5
	else if (touchInCenter && convertedLocation.x > 390 && convertedLocation.y > 220 && _gameMode == 0) {
		[fishSprite stopAllActions];
		CGPoint destination5 = ccp (390, 250);
		id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination5];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:60];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:-110];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination6
	else if (touchInCenter && convertedLocation.x > 380 && convertedLocation.y > 115 && convertedLocation.y < 205 && _gameMode == 0) {
		[fishSprite stopAllActions];
		CGPoint destination6 = ccp (390, 160);
		id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination6];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:90];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:-90];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination7
	else if (touchInCenter && convertedLocation.x > 390 && convertedLocation.y < 100 && _gameMode == 0) {
		[fishSprite stopAllActions];
		CGPoint destination7 = ccp (390, 70);
		id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination7];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:120];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:-55];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}
	}
	// destination8
	else if (touchInCenter && convertedLocation.x > 210 && convertedLocation.x < 270 && convertedLocation.y < 100 && _gameMode == 0) {
        [fishSprite stopAllActions];
		CGPoint destination8 = ccp (240, 70);
		id moveToDest = [CCMoveTo actionWithDuration:0.1 position:destination8];
        id goBackToCenter = [CCMoveTo actionWithDuration:0.05 position:center];
        [fishSprite runAction:[CCSequence actions:moveToDest, goBackToCenter, nil]];
        id rotateSprite = [CCRotateTo actionWithDuration:0.05 angle:-180];
        id usualRotate = [CCRotateTo actionWithDuration:10 angle:0];
        [fishSprite runAction:[CCSequence actions:rotateSprite, usualRotate, nil]];
        
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fishMotion.caf"];}    }
    
    else if ([defaults boolForKey:@"tirePiqueEnable"]) {
	[self tirePique:(CGPoint)location :(CGPoint)convertedLocation];
    }
    
    else {}
    
    /*
     No comment please ;)
    */

}

- (void) tirePique:(CGPoint)location :(CGPoint)convertedLocation // The name of the function is pretty awesome...
{
	static int piqueVelocity = 200;		
	static float pi = (3.14159265); //You should learn it :-°
	
    // This function is about the lances. ("pique" means "lance" or maybe "pike" ?)
    
	// tire
	// à droite 
    // RIGHT
	if (convertedLocation.x > 240){
        
        // I want comment it, it just simple mathematics. Ready ?
        
		float ratio = (convertedLocation.x - 240) / 240;
		float hauteur = (convertedLocation.y - 160) / ratio;
		
		float piqueLength = sqrtf((hauteur*hauteur)+(240*240)); // Thank you Pythagore
		
		float piqueMoveDuration = piqueLength/piqueVelocity;
		CGPoint realDest = ccp(510, hauteur + 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:3];
		
		[pique runAction:[CCMoveTo actionWithDuration:piqueMoveDuration position:realDest]];
		
		// rotation
		if (convertedLocation.y <= 160) {
			float rapportOppAdj = fabsf(convertedLocation.y - 160)/fabsf(convertedLocation.x - 240);
			float angle = (atan(rapportOppAdj))*180/pi + 90;
			[pique runAction:[CCRotateBy actionWithDuration:0 angle:angle]];
		}
		
		if (convertedLocation.y > 160) {
			float rapportOppAdj = fabsf(convertedLocation.y - 160)/(fabsf(convertedLocation.x - 240));
			float angle = (atan(rapportOppAdj))*180/pi - 90;
			[pique runAction:[CCRotateBy actionWithDuration:0 angle:-angle]];
		}		
		[_pique addObject:pique];
	}	
	
	// tire
	// à gauche	
    // LEFT
	if (convertedLocation.x < 240){
		float ratio = (240 - convertedLocation.x) / 240;
		float hauteur = (convertedLocation.y - 160) / ratio;
		
		float piqueLength = sqrtf((hauteur*hauteur)+(240*240));
		
		float piqueMoveDuration = piqueLength/piqueVelocity;
		CGPoint realDest = ccp(-30, hauteur + 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:3];
		
		[pique runAction:[CCMoveTo actionWithDuration:piqueMoveDuration position:realDest]];
		
		// rotation
		if (convertedLocation.y <= 160) {
			float rapportOppAdj = fabsf(convertedLocation.y - 160)/(fabsf(convertedLocation.x - 240));
			float angle = (atan(rapportOppAdj))*180/pi + 90;
			[pique runAction:[CCRotateBy actionWithDuration:0 angle:-angle]];
		}
		
		if (convertedLocation.y > 160) {
			float rapportOppAdj = fabsf(convertedLocation.y - 160)/(fabsf(convertedLocation.x - 240));
			float angle = (atan(rapportOppAdj))*180/pi - 90;
			[pique runAction:[CCRotateBy actionWithDuration:0 angle:angle]];
		}
		
		[_pique addObject:pique];
	}	
	
    
    // If the user touches on the vertical where y = 160 (the middle) :
    
	// tire 
	//en haut
	// TOP
	if (convertedLocation.x == 240 && location.y > 160) {
		float piqueMoveDuration = 160/piqueVelocity; 
		CGPoint realDest = ccp(510, 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:3];
		
		[pique runAction:[CCMoveTo actionWithDuration:piqueMoveDuration position:realDest]];
		[_pique addObject:pique];
	}
	
	// tire
	//en bas
    // BOTTOM
	if (convertedLocation.x == 240 && location.y < 160) {
		float piqueMoveDuration = 160/piqueVelocity; 
		CGPoint realDest = ccp(-30, 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:3];
		
		[pique runAction:[CCMoveTo actionWithDuration:piqueMoveDuration position:realDest]];
		[_pique addObject:pique];		
	}
    
    if ([defaults boolForKey:@"isGameOn"]) {
        if ([defaults boolForKey:@"soundIsEnable"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"tirePique.caf"];}
    }
    
    // I'm sure you can find a way to reduce this code. Don't you ?
}

- (void) addBonus:(ccTime)dt
{	
    id fioleAppear = [CCScaleBy actionWithDuration:0.4 scale:10];
    
    // This function is actually two functions.
    // It manages the apparition of the red and blue vials.

	//--------------------------poison--------------------------red vial - decrease the number of ennemies
	CCSprite *poisonFiole;
    static bool defineTimeToAddPoison = 1;
    static float timeToAddPoison;
    if (defineTimeToAddPoison == 1)
    {
        timeToAddPoison = (arc4random() %30) + 80;
        defineTimeToAddPoison = 0;
    }
    
	NSTimeInterval addPoisonBonus = -([firstAddPoisonBonusDate timeIntervalSinceNow]);	
	
	if (addPoisonBonus > timeToAddPoison) {
        [firstAddPoisonBonusDate dealloc];
        firstAddPoisonBonusDate = [[NSDate alloc] init];
		poisonFiole = [CCSprite spriteWithFile:@"poisonFiole.png"];
		poisonFiole.position = ccp(arc4random() % 400 + 40, arc4random() % 240 + 40);
        
        [poisonFiole setScale:0.1];
        [poisonFiole runAction:fioleAppear];

        [self addChild:poisonFiole z:7];
        [_poisonFiole addObject:poisonFiole];
		addPoisonBonus = -([firstAddPoisonBonusDate timeIntervalSinceNow]);
        defineTimeToAddPoison = 1;
	}
	

	
	for (poisonFiole in _poisonFiole) {
		CGPoint poisonFioleCenter = ccp (poisonFiole.position.x, poisonFiole.position.y);
		static int  poisonFiolePoint = 3;
		
        if (addPoisonBonus > 4 ) {			
			[poisonFioleToDelete addObject:poisonFiole];
            poisonFiolePoint = 3;
		}
        
		for (pique in _pique){
			CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);			
			float distance_pCpFC = [self calculDistance:(CGPoint)piqueCenter :(CGPoint)poisonFioleCenter];
			
			if (distance_pCpFC < 17) {
				poisonFiolePoint --;
				[piqueToDelete addObject:pique];				
			}
			
			if (poisonFiolePoint == 0) {
				[poisonFioleToDelete addObject:poisonFiole];
				poisonFiolePoint = 3;
				poison += 5;
                
                if ([defaults boolForKey:@"soundIsEnable"]) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"takeBonus.caf"];}
			}			
		}
		
		for (pique in piqueToDelete) {
			[_pique removeObject:pique];
			[self removeChild:pique cleanup:YES];									
		}		
	}
	
	for (poisonFiole in poisonFioleToDelete) {
		[_poisonFiole removeObject:poisonFiole];
		[self removeChild:poisonFiole cleanup:YES];
	}
	
    
	
	//--------------------------life-------------------------- blue vial - give ten life points.
	CCSprite *lifeFiole;
    static bool defineTimeToAddLife = 1;
	static float timeToAddLife; 
    if (defineTimeToAddLife == 1){
        timeToAddLife = arc4random() % 20 + 60;
        defineTimeToAddLife = 0;
    }
    
	NSTimeInterval addLifeBonus = -([firstAddLifeBonusDate timeIntervalSinceNow]);
    
	
	if (addLifeBonus > timeToAddLife) {
        [firstAddLifeBonusDate dealloc];
		firstAddLifeBonusDate = [[NSDate alloc] init];
		lifeFiole = [CCSprite spriteWithFile:@"lifeFiole.png"];
		lifeFiole.position = ccp(arc4random() % 400 + 40, arc4random() % 240 + 40);
        
        [lifeFiole setScale:0.1];
        [lifeFiole runAction:fioleAppear];
        
		[self addChild:lifeFiole z:7];
		[_lifeFiole addObject:lifeFiole];
		addLifeBonus = -([firstAddLifeBonusDate timeIntervalSinceNow]);
        defineTimeToAddLife = 1;
	}
    
	for (lifeFiole in _lifeFiole) {
		CGPoint lifeFioleCenter = ccp (lifeFiole.position.x, lifeFiole.position.y);
		static int  fiolePoint = 5;
		
        if (addLifeBonus > 5 ) {
			[lifeFioleToDelete addObject:lifeFiole];
            fiolePoint = 5;
		}
        
		for (pique in _pique){
			CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);			
			float distance_pClFC = [self calculDistance:(CGPoint)piqueCenter :(CGPoint)lifeFioleCenter];
			
			if (distance_pClFC < 17) {
				fiolePoint --;
				[piqueToDelete addObject:pique];
			}
			
			if (fiolePoint == 0) {
				[lifeFioleToDelete addObject:lifeFiole];
				fiolePoint = 5;
				if (life <= 95) {
                    life += 5;
                    if ([defaults boolForKey:@"soundIsEnable"]) {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"takeBonus.caf"];}
                }                
                [self updateLifeLabel:(int)life];
			}	
		}
		
		for (pique in piqueToDelete) {
			[_pique removeObject:pique];
			[self removeChild:pique cleanup:YES];									
		}
	}
	
	for (lifeFiole in lifeFioleToDelete) {
		[_lifeFiole removeObject:lifeFiole];
		[self removeChild:lifeFiole cleanup:YES];
	}
}

- (void) timerEnemy:(ccTime)dt
{
    // This function manges the ennemies. When will they appear ?
    
    //**** enemyRed ****
    NSTimeInterval addEnemyRed = -([firstAddEnemyRedDate timeIntervalSinceNow]);
    
    static float timerEnemyRed;
	if (score >= 0) {
        
		float multipleScore = score * 0.00004 + gameDuration * 0.002 - poison*0.001;
        if (multipleScore > 1.1)
            multipleScore = 1.1;
        
		timerEnemyRed = (arc4random() % 2) + 1.6;
        
		if (addEnemyRed > timerEnemyRed - multipleScore) {
            [self enemyRedAppear];
            [firstAddEnemyRedDate dealloc];
            firstAddEnemyRedDate = [[NSDate alloc] init];
        }
	}
	
	if (score < 0) {
		timerEnemyRed = arc4random() % 1;
        if (addEnemyRed > timerEnemyRed + 3) {
            [self enemyRedAppear];
            [firstAddEnemyRedDate dealloc];
            firstAddEnemyRedDate = [[NSDate alloc] init];
        }
	}
    
    //**** enemyGreen ****
    NSTimeInterval addEnemyGreen = -([firstAddEnemyGreenDate timeIntervalSinceNow]);
    
    static float timerEnemyGreen;
	if (score >= 0) {
		float multipleScore = score * 0.00002 + gameDuration * 0.0005 - poison*0.001;
        if (multipleScore > 3)
            multipleScore = 3;
        
		timerEnemyGreen = (arc4random() % 7) + 4;
        
		if (addEnemyGreen > timerEnemyGreen - multipleScore) {
            [self enemyGreenAppear];
            [firstAddEnemyGreenDate dealloc];
            firstAddEnemyGreenDate = [[NSDate alloc] init];
        }
	}
	
	else {
		timerEnemyGreen = arc4random() % 2 + 5;
        if (addEnemyGreen > timerEnemyGreen) {
            [self enemyGreenAppear];
            [firstAddEnemyGreenDate dealloc];
            firstAddEnemyGreenDate = [[NSDate alloc] init];
        }
	}
    
    //**** calamari ****
    NSTimeInterval addCalamari = -([firstAddCalamari timeIntervalSinceNow]);
    
    static float timerCalamari;
    
	if (score >= 0) {
		timerCalamari = (arc4random() % 30) + 50 + calamariMultiple;
        
		if (addCalamari > timerCalamari) {
            [self calamariAppears];
            [firstAddCalamari dealloc];
            firstAddCalamari = [[NSDate alloc] init];
        }
	}
}

- (void) enemyRedAppear
{
    
    NSMutableArray *nageoiresEnemyRedAnimArray = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [nageoiresEnemyRedAnimArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"enemyRed%d.png", i]]];
    }

    int addTwo;
    
    if (numberCalamari <= 2) {
        addTwo = arc4random() % 1;
    }
    
    if (numberCalamari == 3 || numberCalamari == 4 || numberCalamari == 5) {
        addTwo = arc4random() % 2;
    }
    
    if (numberCalamari > 5) {
        addTwo = arc4random() % 3;
    }    
    
    int z = 0;
	
	CGPoint center = ccp(240, 160);
    
    while (z <= addTwo ){
        z++;       
        int border = arc4random() % 6;
        int xLocation = arc4random() % 550 - 50;
        int yLocation = arc4random() % 360 - 40;
        int realX = center.x - enemyRed.position.x;
        int realY = center.y - enemyRed.position.y;
        int velocity; 
        
        switch (border) {
            case 0:
                enemyRed= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
                enemyRed.position = ccp (-20, yLocation);

                [self addChild:enemyRed z:4];
                [enemyRedAction addObject:enemyRed];
                [_enemyRed addObject:enemyRed];
                break;
            case 1:
                enemyRed= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
                enemyRed.position = ccp (500, yLocation);

                [self addChild:enemyRed z:4];
                [enemyRedAction addObject:enemyRed];
                [_enemyRed addObject:enemyRed];
                break;
            case 2:
                enemyRed= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
                enemyRed.position = ccp (xLocation, -40);

                [self addChild:enemyRed z:4];
                [enemyRedAction addObject:enemyRed];
                [_enemyRed addObject:enemyRed];
                break;
            case 3:
                enemyRed= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
                enemyRed.position = ccp (xLocation, 360);

                [self addChild:enemyRed z:4];
                [enemyRedAction addObject:enemyRed];
                [_enemyRed addObject:enemyRed];
                break;
            default:
                break;
        }
        
        CCAction *swimAction;        
        float multipleScore = 1 + score*0.1 + gameDuration * 0.003 - poison*0.001;
        if (multipleScore > 90)
            multipleScore = 90;
        velocity = arc4random() % 100 + 75 + multipleScore;
        float length = sqrtf((realX*realX)+(realY*realY));
        float realMoveDuration = length/velocity;
        
        for (enemyRed in enemyRedAction){
            float pi = (3.14159265);
            float rapportOppAdj = fabsf(enemyRed.position.y - 160)/fabsf(enemyRed.position.x - 240);
            if (enemyRed.position.x <=240 && enemyRed.position.y <=160) {
                float angle = -((atan(rapportOppAdj))*180/pi - 90);
                [enemyRed  runAction:[CCRotateBy actionWithDuration:0 angle:angle]];}
            if (enemyRed.position.x < 240 && enemyRed.position.y > 160) {
                float angle = (atan(rapportOppAdj))*180/pi + 90;
                [enemyRed  runAction:[CCRotateBy actionWithDuration:0 angle:angle]];}
            if (enemyRed.position.x >=240 && enemyRed.position.y <=160) {
                float angle = (atan(rapportOppAdj))*180/pi - 90;
                [enemyRed  runAction:[CCRotateBy actionWithDuration:0 angle:angle]];}
            if (enemyRed.position.x > 240 && enemyRed.position.y > 160) {
                float angle = -((atan(rapportOppAdj))*180/pi + 90);
                [enemyRed  runAction:[CCRotateBy actionWithDuration:0 angle:angle]];}
            if (enemyRed.position.x == 240 && enemyRed.position.y > 160) {
                [enemyRed  runAction:[CCRotateBy actionWithDuration:0 angle:180]];}
            
            CCAnimation *enemyRedSwim = [CCAnimation 
                                         animationWithFrames:nageoiresEnemyRedAnimArray delay:(0.15 - (velocity/3000))];
            swimAction = [CCRepeatForever actionWithAction:
                          [CCAnimate actionWithAnimation:enemyRedSwim restoreOriginalFrame:NO]];
            [enemyRed runAction:swimAction];
            
            [enemyRed runAction:[CCMoveTo actionWithDuration:realMoveDuration position:center]];
            [enemyRedAction removeObject:enemyRed];
        }
	}
}

- (void) enemyGreenAppear 
{
    NSMutableArray *nageoiresEnemyGreenAnimArray = [NSMutableArray array];
    for(int j = 1; j <= 4; ++j) {
        [nageoiresEnemyGreenAnimArray addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"enemyGreen%d.png", j]]];
    }
  	
    CGPoint center = ccp (240, 160);
    static int border = 10;
	
    int proba = arc4random() % 10;
    
    if (proba < 8) {
        if (numberCalamari == 0) {
            border = arc4random() % 2;
        }
        
        if (numberCalamari == 1 || numberCalamari == 2) {
            border = arc4random() % 3;
        }
        
        if (numberCalamari == 3 || numberCalamari == 4) {
            border = arc4random() % 4;            
        }
        
        if ( numberCalamari > 4) {
            border = arc4random() % 8;
        }      
    }
    
	int velocity;
	
	switch (border) {
		case 0:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
			enemyGreen.position = ccp (-30, 160);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:90]];
			break;
		case 1:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
			enemyGreen.position = ccp (510, 160);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:-90]];
			break;
		case 2:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (240, 350);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:180]];
			break;
		case 3:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (240, -30);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:0]];
			break;
		case 4:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (-30, 350);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:120]];
			break;
		case 5:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (510, 350);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:-120]];
			break;
		case 6:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (-30, -30);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:60]];
			break;
		case 7:
			enemyGreen= [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
			enemyGreen.position = ccp (510, -30);
			[self addChild:enemyGreen z:4];
            [enemyGreenAction addObject:enemyGreen];
            [_enemyGreen addObject:enemyGreen];
            [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:-60]];
			break;
		default:
			break;
	}
    
    CCAction *swimAction;    
    for (enemyGreen in enemyGreenAction){
        int realX = center.x - enemyGreen.position.x;
        int realY = center.y - enemyGreen.position.y;
        
        float multipleScore = 1 + score*0.06 + gameDuration * 0.001 - poison*0.001;
        if (multipleScore > 100)
            multipleScore = 100;
        
        velocity = arc4random() % 90 + 60 + multipleScore;
        
        float length = sqrtf((realX*realX)+(realY*realY));
        float realMoveDuration = length/velocity;
        
        CCAnimation *enemyGreenSwim = [CCAnimation 
                                     animationWithFrames:nageoiresEnemyGreenAnimArray delay:(0.15 - (velocity/3000))];
        swimAction = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:enemyGreenSwim restoreOriginalFrame:NO]];
        [enemyGreen runAction:swimAction];
        

        [enemyGreen runAction:[CCMoveTo actionWithDuration:realMoveDuration position:center]];        
        [enemyGreenAction removeObject:enemyGreen];
    }
}

- (void) calamariAppears
{
    int border = arc4random() % 4;
    id rotate, moveToPoint;
    CGPoint destPoint;
    
    // The calamari always take the same path. Randomly on the top left/right corners and bottom left/right corners
    
    switch (border) {
        case 0:
            destPoint = ccp (170, -40); // where it goes
            calamariSprite = [CCSprite spriteWithFile:@"calamariSprite.png"];
            calamariSprite.position = ccp(-39, 120); // where it appeas
            [self addChild:calamariSprite z:4];
            [_calamariSprite addObject:calamariSprite]; // it appears
            rotate = [CCRotateBy actionWithDuration:0.0 angle:127.5]; // the good orientation to move
            moveToPoint = [CCMoveTo actionWithDuration:4 position:destPoint]; // gettin' ready to move
            [calamariSprite runAction:[CCSequence actions:rotate, moveToPoint, nil]]; // ACTION !
            break;
        case 1:
            destPoint = ccp (170, 360);
            calamariSprite = [CCSprite spriteWithFile:@"calamariSprite.png"];
            calamariSprite.position = ccp(-39, 200);
            [self addChild:calamariSprite z:4];
            [_calamariSprite addObject:calamariSprite];
            rotate = [CCRotateBy actionWithDuration:0.0 angle:52.5];
            moveToPoint = [CCMoveTo actionWithDuration:4 position:destPoint];
            [calamariSprite runAction:[CCSequence actions:rotate, moveToPoint, nil]];
            break;
        case 2:
            destPoint = ccp (310, 360);
            calamariSprite = [CCSprite spriteWithFile:@"calamariSprite.png"];
            calamariSprite.position = ccp(519, 200);
            [self addChild:calamariSprite z:4];
            [_calamariSprite addObject:calamariSprite];
            rotate = [CCRotateBy actionWithDuration:0.0 angle:-52.5];
            moveToPoint = [CCMoveTo actionWithDuration:4 position:destPoint];
            [calamariSprite runAction:[CCSequence actions:rotate, moveToPoint, nil]];
            break;
        case 3:
            destPoint = ccp (310, -40);
            calamariSprite = [CCSprite spriteWithFile:@"calamariSprite.png"];
            calamariSprite.position = ccp(519, 120);
            [self addChild:calamariSprite z:4];
            [_calamariSprite addObject:calamariSprite];
            rotate = [CCRotateBy actionWithDuration:0.0 angle:-127.5];
            moveToPoint = [CCMoveTo actionWithDuration:4 position:destPoint];
            [calamariSprite runAction:[CCSequence actions:rotate, moveToPoint, nil]];
            break;
        default:
            break;
    }
    
    // Well, it's quite repetitive, isn't it ?
    
}

- (void) sendInk
{
    inkSendDate = [[NSDate alloc] init];
    
    inkSprite = [CCSprite spriteWithFile:@"inkSprite.png"];
    inkSprite.position = ccp(240,160);
    [inkSprite setOpacity:0.1];
    [inkSprite runAction:[CCFadeIn actionWithDuration:1]];

    [self addChild:inkSprite z:6];
    
    [_inkSprite addObject:inkSprite];
}

// I guess that all the functions concerning the deletion of sprites is badly done.
// (But it works :-° )

- (void) update:(ccTime)dt
{       
    
    NSTimeInterval currentDuration = -([restartGameDate timeIntervalSinceNow]);
    
    gameDuration = [defaults floatForKey:@"totalGameTime"] + currentDuration;
    
    for (inkSprite in _inkSprite){
        NSTimeInterval timeInk = -([inkSendDate timeIntervalSinceNow]);
        if (timeInk > (4 + (numberCalamari/2))) {
            numberCalamari ++;
            [inkSprite runAction:[CCFadeOut actionWithDuration:2]];
            [_inkSprite removeObject:inkSprite];            
            [self removeChild:inkSprite cleanup:YES];
        }
    }
    
	for (pique in _pique) {
		if (pique.position.x < 20 || pique.position.x > 489 || pique.position.y < -9 || pique.position.y > 329){
			score -=1; // The lance (pique) is out of the screen.
            [self updateScoreLabel:score];
			[piqueToDelete addObject:pique];
		}

    }
    
    for (pique in piqueToDelete) {
        [_pique removeObject:pique];
        [self removeChild:pique cleanup:YES];
    }
     
    if (piqueToDelete !=nil){
        [piqueToDelete removeAllObjects];        
    }
    
	for (calamariSprite in _calamariSprite) {
        calamariSpriteToDelete = [[NSMutableArray alloc] init];
		if (calamariSprite.position.y == - 40 || calamariSprite.position.y == 360){
			[calamariSpriteToDelete addObject:calamariSprite];
            [self sendInk];
		}
		
		for (calamariSprite in calamariSpriteToDelete) {
			[_calamariSprite removeObject:calamariSprite];
			[self removeChild:calamariSprite cleanup:YES];									
		}[calamariSpriteToDelete release];
    }		
    
	if (life <= 0) {
        [defaults setBool:NO forKey:@"isGameOn"];
        
		// ---------------------Durations------------------------
        NSNumber *finalGameDuration = [[NSNumber alloc] initWithInt:gameDuration];
		playerDurations = [[[NSMutableArray alloc] initWithContentsOfFile:[self playerDurationsAccess]]autorelease];

        [playerDurations replaceObjectAtIndex:0 withObject:finalGameDuration];

        
		[playerDurations writeToFile:[self playerDurationsAccess] atomically:YES];
        
        [finalGameDuration release];
		
		
		// -----------------------Scores--------------------------
		NSNumber *finalScore = [[NSNumber alloc] initWithInt:score];
        
		playerScores = [[[NSMutableArray alloc] initWithContentsOfFile:[self playerScoresAccess]]autorelease];
				
        [playerScores replaceObjectAtIndex:0 withObject:finalScore];
		
		[playerScores writeToFile:[self playerScoresAccess] atomically:YES];
        
        [finalScore release];
        
		[[CCDirector sharedDirector] replaceScene:[GameOver GOScene]];
	}
}

- (void) deleteSprites:(ccTime)dt
{
    CGPoint centerPoint = ccp(240, 160);
    CGPoint fishSpriteCenter = ccp(fishSprite.position.x, fishSprite.position.y);
    
    for (enemyRed in _enemyRed){
		CGPoint enemyRedCenter = ccp (enemyRed.position.x, enemyRed.position.y);
		
		for (pique in _pique){
			CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);			
			float distance_pCeRC = [self calculDistance:(CGPoint)enemyRedCenter :(CGPoint)piqueCenter ];
			
			if (distance_pCeRC < 16) {
				score += 2;
                [self updateScoreLabel:(int)score];
				[enemyRedToDelete addObject:enemyRed];
				[piqueToDelete addObject:pique];
                if ([defaults boolForKey:@"soundIsEnable"]) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"piqueRedEnemy.caf"];}
			}
		}
		
		float distance_eRCfSC = [self calculDistance:(CGPoint)enemyRedCenter :(CGPoint)fishSpriteCenter];
        
		
		if (distance_eRCfSC < 26){
			life -= 10;
            [self updateLifeLabel:(int)life];
			[enemyRedToDelete addObject:enemyRed];
            [fishSprite stopAllActions];
            [fishSprite runAction:[CCMoveTo actionWithDuration:0.1 position:centerPoint]];
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishHit.caf"];}
		}
	}
    
    for (enemyRed in enemyRedToDelete) {
        [_enemyRed removeObject:enemyRed];
        [self removeChild:enemyRed cleanup:YES];									
    }
    
    for (enemyGreen in _enemyGreen) {
        CGPoint enemyGreenCenter = ccp (enemyGreen.position.x, enemyGreen.position.y);
        
        float distance_eGCfSC = [self calculDistance:(CGPoint)enemyGreenCenter :(CGPoint)fishSpriteCenter];
        
        if (distance_eGCfSC < 22) {
            score += 3;
            [self updateScoreLabel:(int)score];
            [fishSprite stopAllActions];
            [fishSprite runAction:[CCMoveTo actionWithDuration:0.1 position:centerPoint]];
            [enemyGreenToDelete addObject:enemyGreen];            
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishGreenEnemy.caf"];}
            [_enemyGreen removeObject:enemyGreen];
            
        }
        
        float distance_eGCcP = [self calculDistance:(CGPoint)enemyGreenCenter :(CGPoint)centerPoint];
        
        if (distance_eGCcP < 35) {
            life -=10;
            [self updateLifeLabel:(int)life];
            [fishSprite stopAllActions];
            [fishSprite runAction:[CCMoveTo actionWithDuration:0.1 position:centerPoint]];
            [enemyGreenToDelete addObject:enemyGreen];
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishHit.caf"];}
            
            [_enemyGreen removeObject:enemyGreen];
        }
        
        for (pique in _pique){
			CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);			
			float distance_pCeGC = [self calculDistance:(CGPoint)enemyGreenCenter :(CGPoint)piqueCenter ];
			
			if (distance_pCeGC < 16) {
				[badPique addObject:pique];
			}
		}

    }   
    
    
    for (pique in badPique) {
        [_pique removeObject:pique];
        [pique runAction:[CCMoveTo actionWithDuration:0.5 position:centerPoint]];
        [badPiqueMoving addObject:pique];
        [badPique removeObject:pique];

    }
    
    for (pique in badPiqueMoving) {
        CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);			
        float distance_fSCeGC = [self calculDistance:(CGPoint)fishSpriteCenter :(CGPoint)piqueCenter ];
        
        if (distance_fSCeGC < 25) {            
            life -= 5;
            [self updateLifeLabel:(int)life];
            if ([defaults boolForKey:@"soundIsEnable"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"fishHit.caf"];}

            [badPiqueToDelete addObject:pique];
        }  
    }   
    
    for (pique in badPiqueToDelete) {
        [badPiqueMoving removeObject:pique];
        [self removeChild:pique cleanup:YES];
    }    
    
    for (enemyGreen in enemyGreenToDelete) {
        [self removeChild:enemyGreen cleanup:YES];
    }
}

- (float) calculDistance:(CGPoint)point1 :(CGPoint)point2
{
	float distance = sqrtf((point1.x - point2.x)*(point1.x - point2.x)+(point1.y - point2.y)*(point1.y - point2.y));
	
	return distance;
}

// The two last functions are called to update the display of the score and the one of the life.

- (void) updateScoreLabel:(int)currentScore
{    
    NSString *scoreMessage = [[NSString alloc]
                              initWithFormat: @"%d", currentScore];
    [scoreLabel setString:(NSString *)scoreMessage];
    [scoreMessage release];    
}

- (void) updateLifeLabel:(int)currentLife
{
    NSString *lifeMessage = [[NSString alloc]
                             initWithFormat: @"%d", currentLife];
	[lifeLabel setString:(NSString *)lifeMessage];
    [lifeMessage release];
}

@end




