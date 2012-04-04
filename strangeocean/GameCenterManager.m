//
//  GameCenterManager.m
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

#import "GameCenterManager.h"

@implementation GameCenterManager

@synthesize delegate;

- (id) init
{
	self = [super init];
	if(self!= NULL)
	{
	}
	return self;
}

- (void) dealloc
{
[super dealloc];
}

- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
    if([delegate respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[delegate performSelector: selector withObject: arg withObject: err];
		}
		else
		{
			[delegate performSelector: selector withObject: err];
		}
	}
	else
	{
		NSLog(@"Missed Method");
	}
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self callDelegate: selector withArg: arg error: err];
                   });
}

- (BOOL) isGameCenterAvailable
{
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}


- (void) authenticateLocalUser
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.authenticated == NO)
    {
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {            
                NSLog(@"GC - Couldn't authenticate local User.");            
            }  
        }];
    }
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
     {
         [self callDelegateOnMainThread: @selector(reloadScoresComplete:error:) withArg: leaderBoard error: error];
     }];
}


- (void) reportScore:(int64_t)score
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.authenticated == YES)
    {
        GKScore *scoreReporter = [[[GKScore alloc] init] autorelease];
        scoreReporter.value = score;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {        
            if (error != nil)
            {            
                NSLog(@"Error on reporting score");            
            }        
        }];
    }
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID
{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         GKPlayer* player= NULL;
         for (GKPlayer* tempPlayer in playerArray)
         {
             if([tempPlayer.playerID isEqualToString: playerID])
             {
                 player= tempPlayer;
                 break;
             }
         }
         [self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
     }];
	
}
@end

