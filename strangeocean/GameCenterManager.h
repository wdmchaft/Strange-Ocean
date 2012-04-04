//
//  GameCenterManager.h
//  Strange Ocean
//
//  
//  Please read "ReadMe.txt".
//  This document is available under the Creative Commons Licence : BY-NC-SA.
//  http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//  Thank you.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class GKLeaderboard,  GKPlayer;



@protocol GameCenterManagerDelegate <NSObject>
@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface GameCenterManager : NSObject
{
	id <GameCenterManagerDelegate, NSObject> delegate;
}

@property (nonatomic, assign)  id <GameCenterManagerDelegate> delegate;

- (BOOL) isGameCenterAvailable;

- (void) authenticateLocalUser;

- (void) reportScore: (int64_t) score;
- (void) reloadHighScoresForCategory: (NSString*) category;

- (void) mapPlayerIDtoPlayer: (NSString*) playerID;
@end

