//
//  SceneController.h
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

#import "LookScoresScene.h"

@interface SceneController : CCScene {
    NSUserDefaults *defaults;
}

- (void) replaceSGScene: (CCMenuItem  *) menuItem;

- (void) replacePGScene: (CCMenuItem  *) menuItem;

- (void) pushLSScene: (CCMenuItem  *) menuItem;

- (void) pushLHScene: (CCMenuItem  *) menuItem;

- (void) pushLCScene: (CCMenuItem *) menuItem;

- (void) pushPaGScene: (CCMenuItem  *) menuItem;

- (void) doPopScene: (CCMenuItem *) menuItem;

- (void) doPopPaGScene: (CCMenuItem *) menuItem;


@end
