//
//  PlayGameScene.h
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
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>
#import "GameCenterManager.h"

#import "Strange_OceanAppDelegate.h"


@interface PlayGame : CCLayer <UIActionSheetDelegate, GameCenterManagerDelegate>
{
    NSUserDefaults *defaults;

    GameCenterManager* gameCenterManager;
    
    int score, life, spriteFrameIndex, poison, calamariMultiple, numberCalamari, startTouch;
    bool fishCanMove;
	float 	destinationX, destinationY, startYAccel, gameDuration;
    
    int _gameMode;
    
    CGPoint firstTouch;
    
	CCLabelTTF *scoreLabel, *lifeLabel;

	NSDate *restartGameDate, *gameOverDate, *firstAddLifeBonusDate, *firstAddPoisonBonusDate, *firstAddEnemyRedDate, *firstAddEnemyGreenDate;
    NSDate *firstAddCalamari, *inkSendDate;
   
	NSMutableArray *_enemyRed, *_enemyGreen, *_lifeFiole, *_poisonFiole, *_calamariSprite, *_inkSprite;
	NSMutableArray *enemyRedToDelete, *lifeFioleToDelete, *poisonFioleToDelete, *enemyGreenToDelete, *calamariSpriteToDelete;
	NSMutableArray *enemyRedAction, *enemyGreenAction;
    NSMutableArray *badPique, *badPiqueToDelete, *badPiqueMoving;
    NSMutableArray *playerDurations, *playerScores;
    
    NSMutableArray *_pique, *piqueToDelete;
    
	CCSprite *fishSprite;
	CCSprite *pique;
	CCSprite *enemyRed, *enemyGreen, *calamariSprite, *inkSprite;
    CCSpriteBatchNode *enemyRedSpriteSheet, *enemyGreenSpriteSheet;
    
    CCSprite *moveRound;
}

@property (nonatomic, retain) NSDate *firstAddEnemyRedDate;
@property (nonatomic, retain) NSDate *firstAddEnemyGreenDate;
@property (nonatomic, retain) NSDate *firstAddCalamari;
@property (nonatomic, retain) NSDate *firstAddLifeBonusDate;
@property (nonatomic, retain) NSDate *firstAddPoisonBonusDate;


+(id) PGScene;

- (void) onEnter;

- (void) onExit;

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

- (void) tirePique:(CGPoint)location :(CGPoint)convertedLocation;

- (void) timerEnemy:(ccTime)dt;

- (void) enemyRedAppear;

- (void) enemyGreenAppear;

- (void) calamariAppears;

- (void) update:(ccTime)dt;

- (NSString *) playerScoresAccess;

- (NSString *) playerDurationsAccess;

- (void) deleteSprites:(ccTime)dt;

- (float) calculDistance:(CGPoint)point1 :(CGPoint)point2;

- (void) addBonus:(ccTime)dt;

- (void) autorise:(ccTime)dt;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) sendInk;

- (void) updateScoreLabel:(int)currentScore;

- (void) updateLifeLabel:(int) currentLife;

@end

