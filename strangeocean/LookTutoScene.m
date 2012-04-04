//
//  LookTutoScene.m
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

#import "LookTutoScene.h"
#import "SceneController.h"
#import "SimpleAudioEngine.h"


// Well, maybe I could have find a better solution than a simple copy/paste of PlaGameScene to create the tutorial.

@implementation LookTuto

+(id) LTScene
{
	CCScene *LTScene = [CCScene node];	
	LookTuto *layer = [LookTuto node];	
	[LTScene addChild: layer];	
	return LTScene;
}

-(id) init
{
	if( (self=[super init] )) {
        director = [CCDirector sharedDirector];

        _pique = [[NSMutableArray alloc] init];
        piqueToDelete = [[NSMutableArray alloc] init];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        whichLanguage = 1;
        whichText = 0;
        
        pointsPotionLife = 5;   
        
        pointsPotionPoison = 3; 
                
        enemyRed = nil;
        enemyGreen = nil;
        poisonFiole = nil;
        lifeFiole = nil;
        
        CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground2.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:-5];
        
        CCSprite *seaSprite2 = [CCSprite spriteWithFile:@"sea2.png"];
        seaSprite2.position = ccp(240, 160);
        [self addChild:seaSprite2 z:5];
        
        // bouton pause
        CCMenuItem *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pauseButton.png"
                                                          selectedImage:@"pauseButton.png"
                                                                target:self
                                                              selector:@selector(pauseMenu:)];
		
		CCMenu *gamePause = [CCMenu menuWithItems:pauseButton, nil];
		gamePause.position = ccp (455,25);		
		[self addChild:gamePause z:9];
        
        fishSprite = [CCSprite spriteWithFile:@"fish.png"];
		fishSprite.position = ccp(240,160);
		[self addChild:fishSprite z:-2];
        
        [fishSprite retain];

        
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"score"] fontName:@"Marker Felt" fontSize:18];
		[scoreLabel setAnchorPoint:ccp(1, 1)];
		[scoreLabel setPosition:ccp(475, 315)];
		[self addChild:scoreLabel z:-1];
		scoreLabel.color = ccc3(47, 47, 47);
		
		CCLabelTTF *lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"life"] fontName:@"Marker Felt" fontSize:18];
		[lifeLabel setAnchorPoint:ccp(0, 1)];
		[lifeLabel setPosition:ccp(5, 315)];
		[self addChild:lifeLabel z:-1];
		lifeLabel.color = ccc3(47, 47, 47);
        
        [self schedule:@selector(update:)];
  
        [self selectLanguageFunction];
    }
	return self;
}

- (void) onEnter
{   
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
    
    [defaults setBool:YES forKey:@"tirePiqueEnable"];
    [super onEnter];
}

- (void) onExit
{
    [defaults setBool:NO forKey:@"tirePiqueEnable"];
    [super onExit];
}

- (void) pauseMenu: (CCMenuItem *) menuItem
{
    [defaults setBool:NO forKey:@"tirePiqueEnable"];

    pauseBackGround = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
    pauseBackGround.position = ccp(240,160);
    [self addChild:pauseBackGround z:10];
    
    CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
    titleSprite.position = ccp(240, 275);
    [pauseBackGround addChild:titleSprite];
    
    CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"pauseTitle.png"];
    pauseTitleSprite.position = ccp(240, 225);
    [pauseBackGround addChild:pauseTitleSprite];
        
    SceneController *sceneController = [SceneController node];
    [self addChild:sceneController];
    
    CCMenuItemImage *menuRestart = [CCMenuItemImage itemFromNormalImage:@"resumeButton.png"		 
                                                          selectedImage:@"resumeButton.png"		 
                                                                 target:self		 
                                                               selector:@selector(removePauseMenu:)];
    
    CCMenuItemImage *menuMenu = [CCMenuItemImage itemFromNormalImage:@"menuButton.png"		 
                                                       selectedImage:@"menuButton.png"		 
                                                              target:sceneController
                                                            selector:@selector(replaceSGScene:)];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:menuRestart, menuMenu, nil];
    pauseMenu.position = ccp(240,160);
    [pauseMenu alignItemsVertically];
    [pauseBackGround addChild:pauseMenu z:2];
}

- (void) removePauseMenu:(CCMenuItem *)menuItem
{
    [defaults setBool:YES forKey:@"tirePiqueEnable"];
    [self removeChild:pauseBackGround cleanup:YES];
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
    
    if (firstTouch.x > 200 && firstTouch.x < 280 && firstTouch.y > 120 && firstTouch.y < 200)
    {
        touchInCenter = YES;
    }
    
    // destination1
	if (touchInCenter && convertedLocation.x < 90 && convertedLocation.y < 100) {
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
	}
	// destination2
	else if (touchInCenter && convertedLocation.x < 100 && convertedLocation.y > 130 && convertedLocation.y < 190) {
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
	else if (touchInCenter && convertedLocation.x < 90 && convertedLocation.y > 220) {
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
	else if (touchInCenter && convertedLocation.x > 210 && convertedLocation.x < 270 && convertedLocation.y > 220) {
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
	else if (touchInCenter && convertedLocation.x > 390 && convertedLocation.y > 220) {
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
	else if (touchInCenter && convertedLocation.x > 380 && convertedLocation.y > 130 && convertedLocation.y < 190) {
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
	else if (touchInCenter && convertedLocation.x > 390 && convertedLocation.y < 100) {
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
	else if (touchInCenter && convertedLocation.x > 210 && convertedLocation.x < 270 && convertedLocation.y < 100) {
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
    
}
	
- (void) tirePique:(CGPoint)location :(CGPoint)convertedLocation
{
	static int piqueVelocity = 200;		
	static float pi = (3.14159265);
	
	// tire
	// à droite
	if (convertedLocation.x > 240){
		float ratio = (convertedLocation.x - 240) / 240;
		float hauteur = (convertedLocation.y - 160) / ratio;
		
		float piqueLength = sqrtf((hauteur*hauteur)+(240*240));
		
		float piqueMoveDuration = piqueLength/piqueVelocity;
		CGPoint realDest = ccp(510, hauteur + 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:-3];
		
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
	if (convertedLocation.x < 240){
		float ratio = (240 - convertedLocation.x) / 240;
		float hauteur = (convertedLocation.y - 160) / ratio;
		
		float piqueLength = sqrtf((hauteur*hauteur)+(240*240));
		
		float piqueMoveDuration = piqueLength/piqueVelocity;
		CGPoint realDest = ccp(-30, hauteur + 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:-3];
		
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
	
	// tire 
	//en haut	
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
	if (convertedLocation.x == 240 && location.y < 160) {
		float piqueMoveDuration = 160/piqueVelocity; 
		CGPoint realDest = ccp(-30, 160);
		
		pique = [CCSprite spriteWithFile:@"pique.png"];
		pique.position = ccp(240, 160);
		
		[self addChild:pique z:-18];
		
		[pique runAction:[CCMoveTo actionWithDuration:piqueMoveDuration position:realDest]];
		[_pique addObject:pique];		
	}

    [[SimpleAudioEngine sharedEngine] playEffect:@"tirePique.caf"];
}

 - (void) update:(ccTime)dt
{
    for (pique in _pique) {
        CGPoint piqueCenter = ccp (pique.position.x, pique.position.y);
        if (enemyRed != nil){
            CGPoint enemyRedCenter = ccp (enemyRed.position.x, enemyRed.position.y);
            
            
            float distance_pCeRC = [self calculDistance:(CGPoint)enemyRedCenter :(CGPoint)piqueCenter ];
            
            if (distance_pCeRC < 16) {
                //distance_pCeRC = 40;
                [self removeChild:enemyRed cleanup:YES];
                [piqueToDelete addObject:pique];
                [[SimpleAudioEngine sharedEngine] playEffect:@"piqueRedEnemy.caf"];
                [self nextKillingEnemyRed];
                enemyRed = nil;
            }
            
        }
        
        if (lifeFiole != nil) {
            CGPoint lifeFioleCenter = ccp(lifeFiole.position.x, lifeFiole.position.y);         
            float distance_pClFC = [self calculDistance:(CGPoint)piqueCenter :(CGPoint)lifeFioleCenter];
			
			if (distance_pClFC < 17) {
				pointsPotionLife --;
				[piqueToDelete addObject:pique];
			}
            
            if (pointsPotionLife < 1) {
                [self removeChild:lifeFiole cleanup:YES];                
                
                poisonFiole = [CCSprite spriteWithFile:@"poisonFiole.png"];
                poisonFiole.position = ccp(345, 50);
                [poisonFiole setScale:0.1];
                [poisonFiole runAction:[CCScaleBy actionWithDuration:0.4 scale:10]];
                [self addChild:poisonFiole z:-4];
                
                lifeFiole = nil;
            }           
        }
        
        if (poisonFiole != nil) {
            CGPoint poisonFioleCenter = ccp(poisonFiole.position.x, poisonFiole.position.y);           
            float distance_pCpFC = [self calculDistance:(CGPoint)piqueCenter :(CGPoint)poisonFioleCenter];
			
			if (distance_pCpFC < 17) {
				pointsPotionPoison --;
				[piqueToDelete addObject:pique];
			}
            
            if (pointsPotionPoison < 1) {
                [self removeChild:poisonFiole cleanup:YES];                
              
                poisonFiole = nil;
                [self nextFioles];
            }           
        }
    
        
		if (pique.position.x < -9 || pique.position.x > 489 || pique.position.y < -9 || pique.position.y > 329){
			[piqueToDelete addObject:pique];
		}
    }
    
    for (pique in piqueToDelete) {
        [_pique removeObject:pique];
        [self removeChild:pique cleanup:YES];									
    }
    
    if (enemyGreen != nil) {
        CGPoint enemyGreenCenter = ccp (enemyGreen.position.x, enemyGreen.position.y);
        CGPoint fishSpriteCenter = ccp(fishSprite.position.x, fishSprite.position.y);
        
        float distance_eGCfSC = [self calculDistance:(CGPoint)enemyGreenCenter :(CGPoint)fishSpriteCenter];
        
        if (distance_eGCfSC < 22) {
            [self removeChild:enemyGreen cleanup:YES];
             [fishSprite stopAllActions];
             [fishSprite runAction:[CCMoveTo actionWithDuration:0.1 position:ccp(240,160)]];
             
             [[SimpleAudioEngine sharedEngine] playEffect:@"fishGreenEnemy.caf"];
            enemyGreen = nil;
            [self nextKillingEnemyGreen];
        }
    }
}

- (void) selectLanguageFunction
{
    image_tuto = [CCSprite spriteWithFile:@"select_language.png"];
    image_tuto.position = ccp(240, 250);
    [self addChild:image_tuto z:6];

    
    CCMenuItemImage *frenchLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauFrance.png"		 
                                                             selectedImage: @"drapeauFranceGrey.png"		 
                                                                    target:self		 
                                                                  selector:@selector(selectFrench:)];
    
    CCMenuItemImage *englishLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauAngleterre.png"		 
                                                              selectedImage: @"drapeauAngleterreGrey.png"		 
                                                                     target:self		 
                                                                   selector:@selector(selectEnglish:)];
    
    languageMenu = [CCMenu menuWithItems:frenchLanguage, englishLanguage, nil];
    languageMenu.position = ccp(240, 245);
    [languageMenu alignItemsHorizontally];
    [self addChild:languageMenu z:7];
}

- (void) selectFrench:(id)sender
{
    whichLanguage = 1;
    
    [self introFunction];
}

- (void) selectEnglish:(id)sender
{
    whichLanguage = 2;
    
    [self introFunction];    
}

- (void) introFunction
{    
    [self removeChild:image_tuto cleanup:YES];
    [self removeChild:languageMenu cleanup:YES];
    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"FR_poissonjaune.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"EN_poissonjaune.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    okButton = [CCMenuItemImage itemFromNormalImage:@"bouton_ok.png"
                                      selectedImage:@"bouton_ok.png"
                                             target:self 
                                           selector:@selector(nextIntro:)];
    
    okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(315,35);
    [image_tuto addChild:okMenu z:7];
}

- (void) nextIntro:(CCMenuItem *)menuItem
{    
    [self removeChild:image_tuto cleanup:YES];
    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"FR_ennemisrouges.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"EN_ennemisrouges.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    okButton = [CCMenuItemImage itemFromNormalImage:@"bouton_ok.png"
                                      selectedImage:@"bouton_ok.png"
                                             target:self 
                                           selector:@selector(nextRedText:)];
    
    okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(315,35);
    [image_tuto addChild:okMenu z:7];
}

- (void) nextRedText:(CCMenuItem *)menuItem
{
    [self removeChild:image_tuto cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyRed.plist"];
    CCSpriteBatchNode *enemyRedSpriteSheet = [CCSpriteBatchNode 
                                              batchNodeWithFile:@"enemyRed.png"];
    [self addChild:enemyRedSpriteSheet];
    
    enemyRed = [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
    enemyRed.position = ccp(-30,160);
    [self addChild:enemyRed z :-4];
    
    [enemyRed runAction:[CCRotateBy actionWithDuration:0 angle:90]];
    [enemyRed runAction:[CCMoveTo actionWithDuration:1 position:ccp(100,160)]];

}

- (void) nextKillingEnemyRed
{    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"FR_ennemisverts.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"EN_ennemisverts.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    okButton = [CCMenuItemImage itemFromNormalImage:@"bouton_ok.png"
                                      selectedImage:@"bouton_ok.png"
                                             target:self 
                                           selector:@selector(nextGreenText:)];
    
    okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(315,35);    
    [image_tuto addChild:okMenu z:7];
}

- (void) nextGreenText:(CCMenuItem *)menuItem
{
    [self removeChild:image_tuto cleanup:YES];

    [self removeChild:okMenu cleanup:YES];
    [self removeChild:introText cleanup:YES];    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyGreen.plist"];
    CCSpriteBatchNode *enemyRedSpriteSheet = [CCSpriteBatchNode 
                                              batchNodeWithFile:@"enemyGreen.png"];
    [self addChild:enemyRedSpriteSheet];
    
    enemyGreen = [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
    enemyGreen.position = ccp(510,160);
    [self addChild:enemyGreen z :-4];
    
    [enemyGreen runAction:[CCRotateBy actionWithDuration:0 angle:-90]];
    [enemyGreen runAction:[CCMoveTo actionWithDuration:1 position:ccp(340,160)]];
    
    marqueDoigt = [CCSprite spriteWithFile:@"marqueDoigt.png"];
    marqueDoigt.position = ccp(240,160);
    [self addChild:marqueDoigt z:-2];
    
    id action1 = [CCMoveTo actionWithDuration:1 position:ccp(400,160)];
    id action2 = [CCMoveTo actionWithDuration:0  position: ccp(240,160)];
    [marqueDoigt runAction:[CCRepeatForever actionWithAction:[CCSequence actions:action1, action2, nil]]];

}

- (void)nextKillingEnemyGreen
{
    [self removeChild:marqueDoigt cleanup:YES];
    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"FR_astuce.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"EN_astuce.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    CCSprite *exBouton1 = [CCSprite spriteWithFile:@"setFinger.png"];
    exBouton1.position = ccp(75, 46);
    [image_tuto addChild:exBouton1];
    
    CCSprite *exBouton2 = [CCSprite spriteWithFile:@"setiPhone.png"];
    exBouton2.position = ccp(115, 46);
    [image_tuto addChild:exBouton2];
    
    okButton = [CCMenuItemImage itemFromNormalImage:@"bouton_ok.png"
                                      selectedImage:@"bouton_ok.png"
                                             target:self 
                                           selector:@selector(nextAstuceText:)];
    
    okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(315,35);
    [image_tuto addChild:okMenu z:7];
}

- (void) nextAstuceText:(CCMenuItem *)menuItem {
    [self removeChild:image_tuto cleanup:YES];
    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"FR_potions.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"EN_potions.png"];
        image_tuto.position = ccp(240, 210);
        [self addChild:image_tuto z:6];
    }
    
    okButton = [CCMenuItemImage itemFromNormalImage:@"bouton_ok.png"
                                      selectedImage:@"bouton_ok.png"
                                             target:self 
                                           selector:@selector(nextPotionsText:)];
    
    okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(315,35);
    [image_tuto addChild:okMenu z:7];
}

- (void) nextPotionsText:(CCMenuItem *)menuItem
{
    [self removeChild:image_tuto cleanup:YES];

    lifeFiole = [CCSprite spriteWithFile:@"lifeFiole.png"];
    lifeFiole.position = ccp(100, 200);    
    [lifeFiole setScale:0.1];
    [lifeFiole runAction:[CCScaleBy actionWithDuration:0.4 scale:10]];    
    [self addChild:lifeFiole z:-4];
}

- (void) nextFioles
{
    
    if (whichLanguage == 1)
    {        
        image_tuto = [CCSprite spriteWithFile:@"pret.png"];
        image_tuto.position = ccp(240, 260);
        [self addChild:image_tuto z:6];
    }
    
    else
    {
        image_tuto = [CCSprite spriteWithFile:@"ready.png"];
        image_tuto.position = ccp(240, 260);
        [self addChild:image_tuto z:6];
    }
    
    SceneController *sceneController = [SceneController node];
    [self addChild:sceneController];
    // menu pause
    CCMenuItemImage *menuPlay = [CCMenuItemImage itemFromNormalImage:@"playButton.png"		 
                                        selectedImage: @"playButton.png"		 
                                               target:sceneController		 
                                             selector:@selector(replacePGScene:)];
    
    CCMenuItemImage *menuMenu = [CCMenuItemImage itemFromNormalImage:@"menuButton.png"		 
                                         selectedImage: @"menuButton.png"		 
                                                target:sceneController		 
                                              selector:@selector(replaceSGScene:)];
    
    CCMenu *startMenu = [CCMenu menuWithItems:menuPlay, menuMenu, nil];
    startMenu.position = ccp(240,160);
    [startMenu alignItemsVerticallyWithPadding:20];
    [self addChild:startMenu z:7];
}

- (float) calculDistance:(CGPoint)point1 :(CGPoint)point2
{
	float distance = sqrtf((point1.x - point2.x)*(point1.x - point2.x)+(point1.y - point2.y)*(point1.y - point2.y));
	
	return distance;
}

@end