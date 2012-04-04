//
//  LookScoreScene.h
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

#define FichierScoresDatas @"player_scores.plist"
#define FichierDurationsDatas @"player_durations.plist"


#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

#import "cocos2d.h"
#import "SceneController.h"
#import "GameCenterManager.h"

@interface LookScores : CCLayer <UIActionSheetDelegate, 

GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *playerDurations, *playerScores;    
    NSString *score1Message, *score2Message, *score3Message, *score4Message;

    UIViewController *tempVC;
}

+(id) LSScene;

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

- (NSString *) playerScoresAccess;

- (NSString *) playerDurationsAccess;

- (IBAction)openTwitter:(id)sender;

- (IBAction)openFb:(id)Sender;

- (IBAction)sendMail:(id)sender;

- (IBAction)openWebSite:(id)sender;

- (IBAction)openGp:(id)sender;


@end
