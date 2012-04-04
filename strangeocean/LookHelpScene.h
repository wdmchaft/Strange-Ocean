//
//  LookHelpScene.h
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

#import <UIKit/UIKit.h>

#import "cocos2d.h"


@interface LookHelp : CCLayer
{
    NSUserDefaults *defaults;
    
    int whichImage, whichLanguage;
    BOOL addTutoButton;
    

    CCSprite *creditsLayer, *help1Layer, *help2Layer, *help3Layer;
    
    CCMenuItemImage *flecheRight;
    CCMenu *flecheRightMenu;
    CCMenuItemImage *flecheLeft;
    CCMenu *flecheLeftMenu;
    
    CCMenuItemImage *frenchLanguage;
    CCMenuItemImage *englishLanguage;
    CCMenu *languageMenu;
    
    CCMenuItemImage *tutoButton;
    
    CCMenuItemLabel *labelReadTuto;
    CCMenu *tutoMenu, *goBackMenu, *menuReadTuto;
}

+(id) LHScene;

- (void) onEnter;

- (IBAction)previousImage:(id)sender;

- (IBAction)nextImage:(id)sender;

- (IBAction)startTuto:(id)sender;

- (void) addStartLayer;

- (void) addHelp1Layer;

- (void) addHelp2Layer;

- (void) addHelp3Layer;

- (void) selectFrench:(id)sender;

- (void) selectEnglish:(id)sender;

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void) showAlertWithTitleInclinaison:(id)sender;

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message;

@end
