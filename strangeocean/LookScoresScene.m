//
//  LookScoresScene.m
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

#import "LookScoresScene.h"
#import "SceneController.h"

@implementation LookScores

+(id) LSScene
{
	CCScene *LSScene = [CCScene node];	
	LookScores *layer = [LookScores node];	
	[LSScene addChild: layer];	
	return LSScene;
}

-(id) init
{
	if( (self=[super init] )) {
        SceneController *sceneController = [SceneController node];
		[self addChild:sceneController];
        
        CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:0];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
		titleSprite.position = ccp(240, 275);
        [self addChild:titleSprite];
        
        CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"scoresTitle.png"];
        pauseTitleSprite.position = ccp(240, 225);
        [self addChild:pauseTitleSprite];

		
		CCMenuItemImage *menuBack = [CCMenuItemImage itemFromNormalImage:@"backButton.png"		 
															selectedImage: @"backButton.png"		 
																   target:sceneController		 
																 selector:@selector(doPopScene:)];			
		CCMenu *goBackMenu = [CCMenu menuWithItems:menuBack, nil];		
		goBackMenu.position = ccp(110,184);
		[goBackMenu alignItemsVertically];		
		[self addChild:goBackMenu z:2];
		
		CCMenuItemImage *twitterButton = [CCMenuItemImage itemFromNormalImage:@"twitterButton.png"		 
														   selectedImage: @"twitterButton.png"		 
																  target:self		 
																selector:@selector(openTwitter:)];
        
        CCMenuItemImage *fbButton = [CCMenuItemImage itemFromNormalImage:@"fbButton.png"
                                                             selectedImage:@"fbButton.png"
                                                                    target:self 
                                                                  selector:@selector(openFb:)];
        
        CCMenuItemImage *mailButton = [CCMenuItemImage itemFromNormalImage:@"mailButton.png"			 
                                                             selectedImage: @"mailButton.png"		 
                                                                    target:self		 
                                                                  selector:@selector(sendMail:)];
        
        CCMenuItemImage *siteButton = [CCMenuItemImage itemFromNormalImage:@"stButton.png"
                                                             selectedImage:@"stButton.png"
                                                                    target:self 
                                                                  selector:@selector(openWebSite:)];
        
		CCMenu *twitterMenu = [CCMenu menuWithItems:siteButton, twitterButton, fbButton, mailButton, nil];		
		twitterMenu.position = ccp(340,54);		
		[twitterMenu alignItemsHorizontally];		
		[self addChild:twitterMenu z:3];
        
        CCMenuItem *menuItemLeaderBoard = [CCMenuItemImage itemFromNormalImage:@"leaderboardButton.png"			 
                                                                 selectedImage: @"leaderboardButton.png"
                                                                        target:self 
                                                                      selector:@selector(menuItemLeaderBoardClicked:)];
        
        CCMenuItem *menuItemLeaderBoard2 = [CCMenuItemImage itemFromNormalImage:@"leaderboardButton2.png"			 
                                                                 selectedImage: @"leaderboardButton2.png"
                                                                        target:self 
                                                                      selector:@selector(menuItemLeaderBoardClicked:)];
        
        CCMenu *GCmenu = [CCMenu menuWithItems:menuItemLeaderBoard2, menuItemLeaderBoard, nil];
		GCmenu.position = ccp(206, 184);
        [GCmenu alignItemsHorizontallyWithPadding:-14];		
		[self addChild:GCmenu z:3];
        
		// ---------------------Durations-------------------------
        CCSprite *cadreDurations = [CCSprite spriteWithFile:@"times.png"];
        cadreDurations.position = ccp(340,184);
        [self addChild:cadreDurations];
        
        CCLabelTTF *durationLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"Total Game Time : 00:00:00"] fontName:@"BebasNeue.otf" fontSize:15];
        durationLabel.position = ccp(340, 184);
        [self addChild:durationLabel z:2];
        durationLabel.color = ccc3(144,85,25);

		

        playerDurations = [[NSMutableArray alloc] initWithContentsOfFile:[self playerDurationsAccess]];
        int j = [playerDurations count];
        
        if (j == 2){
            NSNumber *totalGameDuration = [playerDurations objectAtIndex:1];
            
            int inputSeconds = [totalGameDuration intValue];
            int hours =  inputSeconds / 3600;
            int minutes = ( inputSeconds - hours * 3600 ) / 60; 
            int seconds = inputSeconds - hours * 3600 - minutes * 60; 
            
            NSString *normalGameDuration = [NSString stringWithFormat:@"Total Game Time :  %.2d:%.2d:%.2d", hours, minutes, seconds];
            
            
			NSString *durationMessage = [[NSString alloc]
										 initWithFormat: @"%@", normalGameDuration];
			[durationLabel setString:(NSString *)durationMessage];
            
            [durationMessage release];
        }
            
        // -----------------------Scores--------------------------
        CCLabelTTF *highscoresLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"Highscores :"] fontName:@"BebasNeue.otf" fontSize:18];		
        [highscoresLabel setAnchorPoint:ccp(0, 1)];		
        [highscoresLabel setPosition:ccp(82, 154)];
        [self addChild:highscoresLabel z:2];
        highscoresLabel.color = ccc3(249,203,126);
        
		CCLabelTTF *score1Label = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"0"] fontName:@"BebasNeue.otf" fontSize:18];
		[score1Label setAnchorPoint:ccp(0, 1)];		
		[score1Label setPosition:ccp(82, 128)];
		[self addChild:score1Label z:2];
		
		CCLabelTTF *score2Label = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"0"] fontName:@"BebasNeue.otf" fontSize:18];
		[score2Label setAnchorPoint:ccp(0, 1)];
		[score2Label setPosition:ccp(82, 108)];
		[self addChild:score2Label z:2];
		
		CCLabelTTF *score3Label = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"0"] fontName:@"BebasNeue.otf" fontSize:18];
		[score3Label setAnchorPoint:ccp(0, 1)];
		[score3Label setPosition:ccp(82, 88)];
		[self addChild:score3Label z:2];
		
		CCLabelTTF *score4Label = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"0"] fontName:@"BebasNeue.otf" fontSize:18];
		[score4Label setAnchorPoint:ccp(0, 1)];
		[score4Label setPosition:ccp(82, 68)];
		[self addChild:score4Label z:2];
		
		score1Label.color = ccc3(249,203,126);
		score2Label.color = ccc3(249,203,126);
		score3Label.color = ccc3(249,203,126);
		score4Label.color = ccc3(249,203,126);
		
		playerScores = [[NSMutableArray alloc] initWithContentsOfFile:[self playerScoresAccess]];

        int i = [playerScores count];		
		if (i>1) {
			int _score1 = [[playerScores objectAtIndex:1] integerValue];
			score1Message = [[NSString alloc] initWithFormat: @"%d", _score1];			 
			[score1Label setString:(NSString *)score1Message];
            
			int _score2 = [[playerScores objectAtIndex:2] integerValue];
			score2Message = [[NSString alloc] initWithFormat: @"%d", _score2];			 
			[score2Label setString:(NSString *)score2Message];
            
			int _score3 = [[playerScores objectAtIndex:3] integerValue];
			score3Message = [[NSString alloc] initWithFormat: @"%d", _score3];			 
			[score3Label setString:(NSString *)score3Message];

			int _score4 = [[playerScores objectAtIndex:4] integerValue];
			score4Message = [[NSString alloc] initWithFormat: @"%d", _score4];			 
			[score4Label setString:(NSString *)score4Message];
        }
        
        

	}
	return self;
}

- (void) dealloc
{
    [playerDurations release];
    playerDurations = nil;
    [playerScores release];
    playerScores = nil;
   
    [score1Message release];
    score1Message = nil;
    [score2Message release];
    score2Message = nil;
    [score3Message release];
    score3Message = nil;
    [score4Message release];
    score4Message = nil;
    

	[super dealloc];
}

- (void) menuItemLeaderBoardClicked:(id)sender
{
	tempVC = [[UIViewController alloc] init];
    
	GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
    
	if (leaderboardController != nil)
	{
        leaderboardController.leaderboardDelegate = self;
		[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
		[tempVC presentModalViewController:leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[tempVC dismissModalViewControllerAnimated:YES];
	[tempVC.view removeFromSuperview];
	[[CCDirector sharedDirector] replaceScene:[LookScores LSScene]];
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

- (IBAction)openTwitter:(id)sender
{
	NSURL *twitterURL = [NSURL URLWithString:@"http://mobile.twitter.com/gielveapps"];
	[[UIApplication sharedApplication] openURL:twitterURL];
}

- (IBAction)openFb:(id)Sender
{
   	NSURL *fbURL = [NSURL URLWithString:@"http://www.facebook.com/Gielve"];
	[[UIApplication sharedApplication] openURL:fbURL]; 
}

- (IBAction) sendMail:(id)sender
{
	NSURL *twitterURL = [NSURL URLWithString:@"mailto:hugo.caillard@gielve.com"];
	[[UIApplication sharedApplication] openURL:twitterURL];
}

- (IBAction) openWebSite:(id)sender
{
	NSURL *siteURL = [NSURL URLWithString:@"www.gielve.com?ref=app_so"];
	[[UIApplication sharedApplication] openURL:siteURL];
}

- (IBAction) openGp:(id)sender
{
	NSURL *gpURL = [NSURL URLWithString:@"https://plus.google.com/111629215803021522753/posts"];
	[[UIApplication sharedApplication] openURL:gpURL];
}


@end

