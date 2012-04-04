//
//  LookTutoScene.h
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

@interface LookTuto : CCLayer
{
    NSUserDefaults *defaults;
    CCDirector *director;
    
    CCSprite *fishSprite, *pique, *enemyRed, *enemyGreen, *poisonFiole, *lifeFiole, *marqueDoigt;
    CCSprite *pauseBackGround;
    
    CCSprite *image_tuto;

	float 	destinationX, destinationY;
    int whichLanguage, whichText;
    
    int pointsPotionLife, pointsPotionPoison;
    
    NSMutableArray *_pique, *piqueToDelete;

    CGPoint firstTouch;
    
    CCMenu *languageMenu, *okMenu;
    CCMenuItemImage *okButton;
    CCLabelTTF *selectLanguage, *introText;
}

+(id) LTScene;

- (void) onEnter;

- (void) onExit;

- (void) pauseMenu: (CCMenuItem *) menuItem;

- (void) removePauseMenu: (CCMenuItem *) menuItem;

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;	

- (void) tirePique:(CGPoint)location :(CGPoint)convertedLocation;

- (void) update:(ccTime)dt;

- (float) calculDistance:(CGPoint)point1 :(CGPoint)point2;

- (void) selectFrench:(id)sender;

- (void) selectEnglish:(id)sender;

- (void) selectLanguageFunction;

- (void) introFunction;

- (void) nextIntro: (CCMenuItem *) menuItem;

- (void) nextRedText: (CCMenuItem *) menuItem;

- (void) nextKillingEnemyRed;

- (void) nextGreenText: (CCMenuItem *) menuItem;

- (void) nextKillingEnemyGreen;

- (void) nextAstuceText: (CCMenuItem *) menuItem;

- (void) nextPotionsText: (CCMenuItem *) menuItem;

- (void) nextFioles;

@end