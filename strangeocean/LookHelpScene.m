//
//  LookHelpScene.m
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

#import "LookHelpScene.h"
#import "SceneController.h"

#import "LookTutoScene.h"

@implementation LookHelp

+(id) LHScene
{
	CCScene *LHScene = [CCScene node];	
	LookHelp *layer = [LookHelp node];	
	[LHScene addChild: layer];	
	return LHScene;
}

// I did it myself. Actually google translate tolds me that "bricolage" (French) can be translated with "DIY"...

-(id) init
{
	if( (self=[super init] )) {
        whichImage = 1; 
        whichLanguage = 1;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        CCSprite *backGround = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
		backGround.position = ccp(240,160);
		[self addChild:backGround z:0];
                
        SceneController *sceneController = [SceneController node];
		[self addChild:sceneController];
        
		CCMenuItemImage *menuBack = [CCMenuItemImage itemFromNormalImage:@"backButton.png"		 
															selectedImage: @"backButton.png"		 
																   target:sceneController		 
																 selector:@selector(doPopScene:)];		
				
		goBackMenu = [CCMenu menuWithItems:menuBack, nil];		
		goBackMenu.position = ccp(130,184);		
		[goBackMenu alignItemsVertically];		
		[self addChild:goBackMenu z:9];
        
        flecheRight = [CCMenuItemImage itemFromNormalImage:@"flecheRight.png"		 
                                                              selectedImage: @"flecheRight.png"		 
                                                                     target:self		 
                                                                   selector:@selector(nextImage:)];
        flecheRightMenu = [CCMenu menuWithItems:flecheRight, nil];		
        flecheRightMenu.position = ccp(306,114);		
		[flecheRightMenu alignItemsVertically];		
		[self addChild:flecheRightMenu z:9];
        
        flecheLeft = [CCMenuItemImage itemFromNormalImage:@"flecheLeft.png"		 
                                                              selectedImage: @"flecheLeft.png"		 
                                                                     target:self		 
                                                                   selector:@selector(previousImage:)];
        flecheLeftMenu = [CCMenu menuWithItems:flecheLeft, nil];		
		flecheLeftMenu.position = ccp(30,160);		
		[flecheLeftMenu alignItemsVertically];		
		[self addChild:flecheLeftMenu z:9];
        
        [self addStartLayer];      
    }
	return self;
}

- (void) onEnter
{
    self.isAccelerometerEnabled = YES;
    [super onEnter];
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];

	[super dealloc];
}


- (void) addStartLayer // Well, nice name again.
{
    [self removeChild:flecheLeftMenu cleanup:YES];
    
    
    creditsLayer = [CCSprite spriteWithFile:@"gameBackground1.jpg"];
    creditsLayer.position = ccp(240,160);
    [self addChild:creditsLayer z:1];
    
    addTutoButton = YES;
   
    CCSprite *titleSprite = [CCSprite spriteWithFile:@"titre.png"];		
    titleSprite.position = ccp(240, 275);
    [creditsLayer addChild:titleSprite z:2];
    
    CCSprite *pauseTitleSprite = [CCSprite spriteWithFile:@"helpTitle.png"];
    pauseTitleSprite.position = ccp(240, 225);
    [creditsLayer addChild:pauseTitleSprite z:2];
    

    
    tutoButton = [CCMenuItemImage itemFromNormalImage:@"howToButton.png"
                                                       selectedImage:@"howToButton.png"
                                                              target:self 
                                                            selector:@selector(startTuto:)];
    
    tutoMenu = [CCMenu menuWithItems:tutoButton, nil];
    [tutoMenu setPosition:ccp(346, 184)];
    [tutoMenu alignItemsVertically];
    [creditsLayer addChild:tutoMenu z:2];
    
    frenchLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauFrance.png"		 
                                            selectedImage: @"drapeauFranceGrey.png"		 
                                                   target:self		 
                                                 selector:@selector(selectFrench:)];
    
    englishLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauAngleterreGrey.png"		 
                                             selectedImage: @"drapeauAngleterre.png"		 
                                                    target:self		 
                                                  selector:@selector(selectEnglish:)];
    
    languageMenu = [CCMenu menuWithItems:frenchLanguage, englishLanguage, nil];
    languageMenu.position = ccp (240,184);
    [languageMenu alignItemsHorizontally];
    [creditsLayer addChild:languageMenu z:3];
    
    
    if (whichLanguage == 1){
    labelReadTuto = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"LIRE LE TUTORIEL" fontName:@"BebasNeue.otf" fontSize:24] target:self selector:@selector(nextImage:)];
        labelReadTuto.color = ccc3(249,203,126);

    }
    
    else {
    labelReadTuto = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"READ THE TUTORIAL" fontName:@"BebasNeue.otf" fontSize:24] target:self selector:@selector(nextImage:)];
        labelReadTuto.color = ccc3(249,203,126);

    }


    
    menuReadTuto = [CCMenu menuWithItems:labelReadTuto, nil];
    menuReadTuto.position = ccp(224,110);
    [creditsLayer addChild:menuReadTuto];
    
}

- (void) addHelp1Layer
{
    addTutoButton = NO;
    help1Layer = [CCSprite spriteWithFile:@"fdHelp.jpg"];
    help1Layer.position = ccp(240,160);
    [self addChild:help1Layer z:1];
    
    if (whichLanguage == 1) {
        CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"Le Poisson Jaune" fontName:@"BebasNeue.otf" fontSize:20];
        title1.position = ccp(276,250);
        [help1Layer addChild:title1 z:2];
        title1.color = ccc3(249,203,126);
    }
    
    else {
        CCLabelTTF *title1 = [CCLabelTTF labelWithString:@"The Yellow Fish" fontName:@"BebasNeue.otf" fontSize:20];
        title1.position = ccp(276,250);
        [help1Layer addChild:title1 z:2];
        title1.color = ccc3(249,203,126);
    }
    
    CCSprite *fishSprite = [CCSprite spriteWithFile:@"fish.png"];
    fishSprite.position = ccp(150,250);
    [help1Layer addChild:fishSprite z:2];
    
    if (whichLanguage == 1)
    {        
        NSString *txt = @"Vous contrôlez ce petit poisson jaune\n• Vous pouvez lancer des piques en touchant l'écran.\n• Et vous déplacer, soit en glissant votre doigt du centre de l'écran vers les bords, soit en penchant votre appareil.\n\nGardez un oeil :\n• en haut à gauche : sur votre vie.\n• en haut à droite : sur vos points.";

        CGSize maxSize = { 310, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *frenchText = [CCLabelTTF labelWithString:txt
                                   dimensions:containerSize
                                    alignment:UITextAlignmentLeft
                                     fontName:@"Helvetica"
                                     fontSize:14];
        
        [frenchText setAnchorPoint:ccp(0, 1)];
		[frenchText setPosition:ccp(63, 220)];
		[help1Layer addChild:frenchText z:2];
        frenchText.color = ccc3(249,203,126);
    }
    
    else
    {
        NSString *txt = @"You control the yellow Fish. Your only purpose is to survive.\n• You can launch spines by tapping the screen.\n• You can move by swiping your finger from the center of the screen to the edges or by tilting your device in the way you want.\n\nCare about:\n• Your life, in the top left-hand corner.\n• Your points, on the top right-hand corner.";
        
        CGSize maxSize = { 310, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *englishText = [CCLabelTTF labelWithString:txt
                                                  dimensions:containerSize
                                                   alignment:UITextAlignmentLeft
                                                    fontName:@"Helvetica"
                                                    fontSize:14];
        
		[englishText setAnchorPoint:ccp(0, 1)];
		[englishText setPosition:ccp(63, 220)];
		[help1Layer addChild:englishText z:2];
        englishText.color = ccc3(249,203,126);
    }
    
    CCSprite *exBouton1 = [CCSprite spriteWithFile:@"setFinger.png"];
    exBouton1.position = ccp(399, 160);
    [help1Layer addChild:exBouton1];
    
    CCSprite *exBouton2 = [CCSprite spriteWithFile:@"setiPhone.png"];
    exBouton2.position = ccp(399, 125);
    [help1Layer addChild:exBouton2];
}

- (void) addHelp2Layer;
{
    addTutoButton = NO;
    help2Layer = [CCSprite spriteWithFile:@"fdHelp.jpg"];
    help2Layer.position = ccp(240,160);
    [self addChild:help2Layer z:1];
    
    if (whichLanguage == 1) {
        CCLabelTTF *title2 = [CCLabelTTF labelWithString:@"Ennemi Rouge" fontName:@"BebasNeue.otf" fontSize:20];
        title2.position = ccp(276,240);
        [help2Layer addChild:title2 z:2];
        title2.color = ccc3(249,203,126);
    }
    
    else {
        CCLabelTTF *title2 = [CCLabelTTF labelWithString:@"Red Enemy" fontName:@"BebasNeue.otf" fontSize:20];
        title2.position = ccp(276,240);
        [help2Layer addChild:title2 z:2];
        title2.color = ccc3(249,203,126);
    }
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyRed.plist"];
    CCSpriteBatchNode *enemyRedSpriteSheet = [CCSpriteBatchNode 
                                              batchNodeWithFile:@"enemyRed.png"];
    [self addChild:enemyRedSpriteSheet];
    
    CCSprite *enemyRed = [CCSprite spriteWithSpriteFrameName:@"enemyRed1.png"];
    enemyRed.position = ccp(150,254);
    [help2Layer addChild:enemyRed];

    if (whichLanguage == 1)
    {        
        NSString *txt = @"Pour tuer les ennemis rouges, lancez simplement un pique dans leur direction, ce qui vous rapportera 2 points.\n\nAttention : ils ne doivent pas vous toucher.";
        
        CGSize maxSize = { 270, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *frenchText = [CCLabelTTF labelWithString:txt
                                                  dimensions:containerSize
                                                   alignment:UITextAlignmentLeft
                                                    fontName:@"Helvetica"
                                                    fontSize:14];
        
        [frenchText setAnchorPoint:ccp(0, 1)];
		[frenchText setPosition:ccp(110, 210)];
		[help2Layer addChild:frenchText z:2];
        frenchText.color = ccc3(249,203,126);
    }
    
    else
    {
        NSString *txt = @"To kill red enemies you simply need to launch a spine in their direction and you will get 2 points.\n\nBe careful not to be hitten by them.";
        
        CGSize maxSize = { 270, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *englishText = [CCLabelTTF labelWithString:txt
                                                   dimensions:containerSize
                                                    alignment:UITextAlignmentLeft
                                                     fontName:@"Helvetica"
                                                     fontSize:14];
        
		[englishText setAnchorPoint:ccp(0, 1)];
		[englishText setPosition:ccp(110, 210)];
		[help2Layer addChild:englishText z:2];
        englishText.color = ccc3(249,203,126);
    }
}

- (void) addHelp3Layer;
{
    addTutoButton = NO;
    [self removeChild:flecheRightMenu cleanup:YES];
    
    help3Layer = [CCSprite spriteWithFile:@"fdHelp.jpg"];
    help3Layer.position = ccp(240,160);
    [self addChild:help3Layer z:1];
    
    if (whichLanguage == 1) {
        CCLabelTTF *title2 = [CCLabelTTF labelWithString:@"Ennemi Vert" fontName:@"BebasNeue.otf" fontSize:20];
        title2.position = ccp(276,240);
        [help2Layer addChild:title2 z:2];
        title2.color = ccc3(249,203,126);
    }
    
    else {
        CCLabelTTF *title2 = [CCLabelTTF labelWithString:@"Green Enemy" fontName:@"BebasNeue.otf" fontSize:20];
        title2.position = ccp(276,240);
        [help2Layer addChild:title2 z:2];
        title2.color = ccc3(249,203,126);
    }
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemyGreen.plist"];
    CCSpriteBatchNode *enemyGreenSpriteSheet = [CCSpriteBatchNode 
                                                batchNodeWithFile:@"enemyGreen.png"];
    [self addChild:enemyGreenSpriteSheet];
    
    CCSprite *enemyGreen = [CCSprite spriteWithSpriteFrameName:@"enemyGreen1.png"];
    enemyGreen.position = ccp(150,240);
    [help3Layer addChild:enemyGreen];

    if (whichLanguage == 1)
    {        
        NSString *txt = @"Pour tuer les ennemis verts, il vous suffit de glisser votre doigt sur l'écran. Partez du milieu de l'écran et glissez dans la direction que vous voulez. Vous gagnerez 3 points.\n\nAttention : vous ne devez pas les attaquer avec des piques.";
        
        CGSize maxSize = { 270, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *frenchText = [CCLabelTTF labelWithString:txt
                                                  dimensions:containerSize
                                                   alignment:UITextAlignmentLeft
                                                    fontName:@"Helvetica"
                                                    fontSize:14];
        
        [frenchText setAnchorPoint:ccp(0, 1)];
		[frenchText setPosition:ccp(105, 210)];
		[help3Layer addChild:frenchText z:2];
        frenchText.color = ccc3(249,203,126);
    }
    
    else
    {
        NSString *txt = @"To kill green enemies, you simply have to swipe your finger across the screen in the direction you want. Start from the middle of the screen, and swipe toward the enemy. You will win 3 points.\n\nBe careful not to launch spines on them.";
        
        CGSize maxSize = { 270, 300 };        
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                            constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize containerSize = { actualSize.width, actualSize.height };
        
        CCLabelTTF *englishText = [CCLabelTTF labelWithString:txt
                                                   dimensions:containerSize
                                                    alignment:UITextAlignmentLeft
                                                     fontName:@"Helvetica"
                                                     fontSize:14];
        
		[englishText setAnchorPoint:ccp(0, 1)];
		[englishText setPosition:ccp(105, 210)];
		[help3Layer addChild:englishText z:2];
        englishText.color = ccc3(249,203,126);
    }
}

- (IBAction) nextImage:(id)sender
{
    if (whichImage == 1) {
        flecheLeft = [CCMenuItemImage itemFromNormalImage:@"flecheLeft.png"		 
                                            selectedImage: @"flecheLeft.png"		 
                                                   target:self		 
                                                 selector:@selector(previousImage:)];
        
        flecheLeftMenu = [CCMenu menuWithItems:flecheLeft, nil];		
		flecheLeftMenu.position = ccp(30,160);		
		[flecheLeftMenu alignItemsVertically];		
		[self addChild:flecheLeftMenu z:9];
        
        goBackMenu.position = ccp(52,284);
        flecheRightMenu.position = ccp(450,160);		

        
        [self removeChild:creditsLayer cleanup:YES];
        [self addHelp1Layer];
    }
    
    if (whichImage == 2) {
        [self removeChild:help1Layer cleanup:YES];
        [self addHelp2Layer];
    }
    
    if (whichImage == 3) {
        [self removeChild:help2Layer cleanup:YES];
        [self addHelp3Layer];
    }
    
    if (whichImage == 4) {
        
    }

    if (whichImage < 4)
        whichImage ++;
}

- (IBAction) previousImage:(id)sender
{
    if (whichImage == 1) {

    }
    
    if (whichImage == 2) {
		goBackMenu.position = ccp(130,184);		
        flecheRightMenu.position = ccp(306,114);		

        [self removeChild:help1Layer cleanup:YES];
        [self addStartLayer];
    }
    
    if (whichImage == 3) {
        [self removeChild:help2Layer cleanup:YES];
        [self addHelp1Layer];
    }
    
    if (whichImage == 4) {
        flecheRight = [CCMenuItemImage itemFromNormalImage:@"flecheRight.png"		 
                                             selectedImage: @"flecheRight.png"		 
                                                    target:self		 
                                                  selector:@selector(nextImage:)];
        flecheRightMenu = [CCMenu menuWithItems:flecheRight, nil];		
		flecheRightMenu.position = ccp(450,160);		
		[flecheRightMenu alignItemsVertically];		
		[self addChild:flecheRightMenu z:9];
        
        [self removeChild:help3Layer cleanup:YES];
        [self addHelp2Layer];
    }
    
    if (whichImage > 1)
        whichImage --;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
}

- (void) showAlertWithTitleInclinaison:(id)sender
{
    [self showAlertWithTitle:@"Inclinaison" message:@"L'iPhone ne doit pas être trop incliné."];
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
}

- (void) selectFrench:(id)sender
{
    [self removeChild:languageMenu cleanup:YES];
    frenchLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauFrance.png"		 
                                            selectedImage: @"drapeauFranceGrey.png"		 
                                                   target:self		 
                                                 selector:@selector(selectFrench:)];
    
    englishLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauAngleterreGrey.png"		 
                                             selectedImage: @"drapeauAngleterre.png"		 
                                                    target:self		 
                                                  selector:@selector(selectEnglish:)];
    
    languageMenu = [CCMenu menuWithItems:frenchLanguage, englishLanguage, nil];
    languageMenu.position = ccp (240,184);
    [languageMenu alignItemsHorizontally];
    [creditsLayer addChild:languageMenu z:3];
    
    [creditsLayer removeChild:menuReadTuto cleanup:YES];
    
    labelReadTuto = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"LIRE LE TUTORIEL" fontName:@"BebasNeue.otf" fontSize:24] target:self selector:@selector(nextImage:)];
    
    labelReadTuto.color = ccc3(249,203,126);
    
    
    menuReadTuto = [CCMenu menuWithItems:labelReadTuto, nil];
    menuReadTuto.position = ccp(224,110);
    [creditsLayer addChild:menuReadTuto];
    
    whichLanguage = 1;    
}

- (void) selectEnglish:(id)sender
{
    [self removeChild:languageMenu cleanup:YES];
    frenchLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauFranceGrey.png"		 
                                            selectedImage: @"drapeauFrance.png"		 
                                                   target:self		 
                                                 selector:@selector(selectFrench:)];
    
    englishLanguage = [CCMenuItemImage itemFromNormalImage:@"drapeauAngleterre.png"		 
                                             selectedImage: @"drapeauAngleterreGrey.png"		 
                                                    target:self		 
                                                  selector:@selector(selectEnglish:)];
    
    languageMenu = [CCMenu menuWithItems:frenchLanguage, englishLanguage, nil];
    languageMenu.position = ccp (240,184);
    [languageMenu alignItemsHorizontally];
    [creditsLayer addChild:languageMenu z:3];
    
    [creditsLayer removeChild:menuReadTuto cleanup:YES];
    
    labelReadTuto = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"READ THE TUTORIAL" fontName:@"BebasNeue.otf" fontSize:24] target:self selector:@selector(nextImage:)];
    
    labelReadTuto.color = ccc3(249,203,126);
    
    
    menuReadTuto = [CCMenu menuWithItems:labelReadTuto, nil];
    menuReadTuto.position = ccp(224,110);
    [creditsLayer addChild:menuReadTuto];
    
    whichLanguage = 2;    
}

- (IBAction)startTuto:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LookTuto LTScene]];
}

@end
