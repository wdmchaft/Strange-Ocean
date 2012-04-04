//
//  Abyssal_FishAppDelegate.m
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

#import "GameConfig.h"

#import "PauseGameScene.h"
#import "Strange_OceanAppDelegate.h"
#import "StartGameScene.h"
#import "RootViewController.h"

@implementation Strange_OceanAppDelegate

@synthesize window;

- (void) removeStartupFlicker
{

#if GAME_AUTOROTATION == kGameAutorotationUIViewController

	CC_ENABLE_DEFAULT_GL_STATES();
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director winSize];
	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	sprite.position = ccp(size.width/2, size.height/2);
	sprite.rotation = -90;
	[sprite visit];
	[[director openGLView] swapBuffers];
	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];

	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;

	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	
								   depthFormat:0						
						];
	
	[director setOpenGLView:glView];
    [glView setMultipleTouchEnabled:YES];
	
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

    
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];

	
	[director enableRetinaDisplay:YES];	
	[viewController setView:glView];
	
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	[self removeStartupFlicker];
	
	[[CCDirector sharedDirector] runWithScene: [StartGame SGScene]];
	
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"isGameOn"]) {			
        [defaults setBool:NO forKey:@"isGameOn"];
        
        [[CCDirector sharedDirector] pushScene:[PauseGame PaGScene]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {	
	[[CCDirector sharedDirector] stopAnimation];
	
    defaults = [NSUserDefaults standardUserDefaults];
   
    if ([defaults boolForKey:@"isGameOn"]) {			
        [defaults setBool:NO forKey:@"isGameOn"];
        
        [[CCDirector sharedDirector] pushScene:[PauseGame PaGScene]]; // The game is paused when the user quite the game.
        
        // What a nice multitasking !
    }
	
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
