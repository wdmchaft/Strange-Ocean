//
//  LookCreditsScene.m
//  Strange Ocean
//
//  Created by Hugo CAILLARD on 08/08/11.
//  
//  Please read "ReadMe.txt".
//  This document is available under the Creative Commons Licence : BY-NC-SA.
//  http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//  Thank you.
//

#import "LookCreditsScene.h"

#import "SceneController.h"

@implementation LookCredits


+(CCScene *) LCScene
{
	CCScene *LCScene = [CCScene node];	
	LookCredits *layer = [LookCredits node];	
	[LCScene addChild: layer];	
	return LCScene;
}


- (id)init
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
        
        CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"creditsTitle.png"];
        pauseTitleSprite.position = ccp(240, 225);
        [self addChild:pauseTitleSprite];
        
        CCMenuItemImage *menuBack = [CCMenuItemImage itemFromNormalImage:@"backButton.png"		 
                                                           selectedImage: @"backButton.png"		 
                                                                  target:sceneController		 
                                                                selector:@selector(doPopScene:)];			
		CCMenu *goBackMenu = [CCMenu menuWithItems:menuBack, nil];		
		goBackMenu.position = ccp(50,56);
		[goBackMenu alignItemsVertically];		
		[self addChild:goBackMenu z:2];
        
        int creditsFontSize = 16;
        int creditsPadding = 0;
        
        
        
        CCMenuItemLabel *dev = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"- Developer -" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openDev:)];
        dev.color = ccc3(249,203,126);
        
        CCMenuItemLabel *devLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Hugo Caillard" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openDev:)];
        devLabel.color = ccc3(249,203,126);
        
        CCMenu *devMenu = [CCMenu menuWithItems:dev, devLabel, nil];
        devMenu.position = ccp(240,190);
        [devMenu alignItemsVerticallyWithPadding:creditsPadding];
        [self addChild:devMenu];
        
        
        
        CCMenuItemLabel *graph = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"- Game Design -" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openGraph:)];
        graph.color = ccc3(249,203,126);
        
        CCMenuItemLabel *graphLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Jonathan Noble" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openGraph:)];
        graphLabel.color = ccc3(249,203,126);
        
        CCMenu *graphMenu = [CCMenu menuWithItems:graph, graphLabel, nil];
        graphMenu.position = ccp(240,144);
        [graphMenu alignItemsVerticallyWithPadding:creditsPadding];
        [self addChild:graphMenu];

        
        CCMenuItemLabel *zik = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"- Music Theme -" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openZik:)];
        zik.color = ccc3(249,203,126);
        
        CCMenuItemLabel *zikLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Quentin Moquay" fontName:@"Helvetica" fontSize:creditsFontSize] target:self selector:@selector(openZik:)];
        zikLabel.color = ccc3(249,203,126);
        
        CCMenu *zikMenu = [CCMenu menuWithItems:zik, zikLabel, nil];
        zikMenu.position = ccp(240,98);
        [zikMenu alignItemsVerticallyWithPadding:creditsPadding];
        [self addChild:zikMenu];
        
        CCMenuItemImage *gielve = [CCMenuItemImage itemFromNormalImage:@"gielveButton.png"
                                                         selectedImage:@"gielveButton.png"
                                                                target:self
                                                              selector:@selector(openDev:)];
        
        CCMenu *gielveMenu = [CCMenu menuWithItems:gielve, nil];
        gielveMenu.position = ccp(350,48);
        [self addChild:gielveMenu z:3];
        
        CCMenuItemImage *moreApps = [CCMenuItemImage itemFromNormalImage:@"moreApps.png"
                                                         selectedImage:@"moreApps.png"
                                                                target:self
                                                              selector:@selector(openDev:)];
        
        CCMenu *moreAppsMenu = [CCMenu menuWithItems:moreApps, nil];
        moreAppsMenu.position = ccp(130,56);
        [self addChild:moreAppsMenu z:3];
        
    }
    
    return self;
}

- (IBAction)openDev:(id)sender
{	
    NSURL *siteURL = [NSURL URLWithString:@"http://gielve.com?ref=app_so"];
	[[UIApplication sharedApplication] openURL:siteURL];
}

- (IBAction)openGraph:(id)sender;
{
    NSURL *siteURL = [NSURL URLWithString:@"http://clocktweets.com"];
	[[UIApplication sharedApplication] openURL:siteURL];
}

- (IBAction)openZik:(id)sender;
{
    NSURL *siteURL = [NSURL URLWithString:@"http://colorharmonymusic.fr.mu"];
	[[UIApplication sharedApplication] openURL:siteURL];
}

@end
