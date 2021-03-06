    //
//  BenthosiPadRootViewController.m
//  SeafloorExplore
//
//  Modified from Brad Larson's Molecules Project in 2011-2012 for use in The SeafloorExplore Project
//
//  Copyright (C) 2012 Matthew Johnson-Roberson
//
//  See COPYING for license details
//  
//  Molecules
//
//  The source code for Molecules is available under a BSD license.  See COPYING for details.
//
//  Created by Brad Larson on 2/20/2010.
//
//  The download toolbar icon in this application is courtesy of Joseph Wain / glyphish.com
//  See the GlyphishIconLicense.txt file for more information on these icons


#import "BenthosiPadRootViewController.h"
#import "BenthosGLViewController.h"
#import "BenthosGLView.h"
#include "Benthos.h"
#import "MyOpenGLES20Renderer.h"
@implementation BenthosiPadRootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];

	UIView *backgroundView = [[UIView alloc] initWithFrame:mainScreenFrame];
	backgroundView.opaque = YES;
	backgroundView.backgroundColor = [UIColor blackColor];
	backgroundView.autoresizesSubviews = YES;
	self.view = backgroundView;
	[backgroundView release];
	
	BenthosGLViewController *viewController = [[BenthosGLViewController alloc] initWithNibName:nil bundle:nil];
	self.glViewController = viewController;
	[viewController release];
	
	[self.view addSubview:glViewController.view];
	glViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	mainToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, glViewController.view.frame.size.width, 44.0f)];
	mainToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	mainToolbar.tintColor = [UIColor blackColor];
	[backgroundView addSubview:mainToolbar];

	UIImage *screenImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"69-display" ofType:@"png"]];	
	screenBarButton = [[UIBarButtonItem alloc] initWithImage:screenImage style:UIBarButtonItemStylePlain target:self action:@selector(displayOnExternalOrLocalScreen:)];
	screenBarButton.width = 44.0f;
	[screenImage release];	
	
	/*UIImage *downloadImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"57-download" ofType:@"png"]];	
	UIBarButtonItem *downloadBarButton = [[UIBarButtonItem alloc] initWithImage:downloadImage style:UIBarButtonItemStylePlain target:self action:@selector(showDownloadOptions:)];
	downloadBarButton.width = 44.0f;
	[downloadImage release];
	*/
	UIImage *visualizationImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homeIcon" ofType:@"png"]];	
	visualizationBarButton = [[UIBarButtonItem alloc] initWithImage:visualizationImage style:UIBarButtonItemStylePlain target:self action:@selector(sendHome:)];
	visualizationBarButton.width = 44.0f;
	[visualizationImage release];
	
	spacerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

	unselectedRotationImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PaintOn" ofType:@"png"]];	
	rotationBarButton = [[UIBarButtonItem alloc] initWithImage:unselectedRotationImage style:UIBarButtonItemStylePlain target:glViewController action:@selector(switchVisType:)];
	rotationBarButton.width = 44.0f;
    
    selectedRotationImage = [UIImage imageNamed:@"PaintIpad.png"];

	
/*	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConnectionOfMonitor:) name:UIScreenDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDisconnectionOfMonitor:) name:UIScreenDidDisconnectNotification object:nil];

	if ([[UIScreen screens] count] > 1)
	{
		for (UIScreen *currentScreen in [UIScreen screens])
		{
			if (currentScreen != [UIScreen mainScreen])
				externalScreen = currentScreen;
		}
		[mainToolbar setItems:[NSArray arrayWithObjects:spacerItem, screenBarButton, downloadBarButton, visualizationBarButton, rotationBarButton, nil] animated:NO];
	}
	else
	{*/
		[mainToolbar setItems:[NSArray arrayWithObjects:spacerItem,  visualizationBarButton, rotationBarButton, nil]animated:NO];
    [mainToolbar setItems:[NSArray arrayWithObjects:spacerItem, visualizationBarButton, rotationBarButton, nil] animated:NO];
     /*
    [mainToolbar setItems:[NSArray arrayWithObjects:spacerItem, downloadBarButton, rotationBarButton, nil] animated:NO];
    [mainToolbar setItems:[NSArray arrayWithObjects:spacerItem, rotationBarButton, nil] animated:NO];
*///	}
		
	//[downloadBarButton release];

	glViewController.view.frame = CGRectMake(mainScreenFrame.origin.x, mainToolbar.bounds.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height -  mainToolbar.bounds.size.height);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
    return YES;
}
- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[visualizationBarButton release];
	[spacerItem release];
	[mainToolbar release];
	[selectedRotationImage release];
	[unselectedRotationImage release];
	[rotationBarButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Bar response methods

/*- (void)showModels:(id)sender;
{
	modelListPopover = [[UIPopoverController alloc] initWithContentViewController:self.tableNavigationController];
	[self.tableNavigationController setContentSizeForViewInPopover:CGSizeMake(320.0f, round(0.5f * self.view.bounds.size.height))];
	[modelListPopover setDelegate:self];
	[modelListPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}*/
- (void)sendHome:(id)sender;
{
    [glViewController sendHome];
}
- (void)showVisualizationModes:(id)sender;
{
	if (glViewController.visualizationActionSheet != nil)
		return;
	
	UIActionSheet *actionSheet = [glViewController actionSheetForVisualizationState];
	[actionSheet showFromBarButtonItem:visualizationBarButton animated:YES];
	glViewController.visualizationActionSheet = actionSheet;
	
	[modelTablePopover dismissPopoverAnimated:YES];
	modelTablePopover = nil;
	
	[downloadOptionsPopover dismissPopoverAnimated:YES];
	[downloadOptionsPopover release];
	downloadOptionsPopover = nil;
}


#pragma mark -
#pragma mark Passthroughs for managing models

- (void)selectedModelDidChange:(NSInteger)newModelIndex;
{
	[super selectedModelDidChange:newModelIndex];
	
	glViewController.modelToDisplay = bufferedModel;
	
	//[modelTablePopover dismissPopoverAnimated:YES];
	// modelTablePopover = nil;
    [(MyOpenGLES20Renderer*)glViewController.openGLESRenderer setRemoveOnceRender:YES];
    [glViewController startOrStopAutorotation:YES];

	
}

#pragma mark -
#pragma mark Manage the switching of rotation state

- (void)toggleRotationButton:(NSNotification *)note;
{
	if ([[note object] boolValue])
	{
		
		rotationBarButton.image = selectedRotationImage;
	}
	else
	{
		rotationBarButton.image = unselectedRotationImage;
	}
}

#pragma mark -
#pragma mark External monitor support

- (void)handleConnectionOfMonitor:(NSNotification *)note;
{
	externalScreen = [note object];
	NSMutableArray *items = [[mainToolbar items] mutableCopy];
    [items insertObject:screenBarButton atIndex:[items indexOfObject:spacerItem] + 1];
    [mainToolbar setItems:items animated:YES];
    [items release];
}

- (void)handleDisconnectionOfMonitor:(NSNotification *)note;
{
	NSMutableArray *items = [[mainToolbar items] mutableCopy];
    [items removeObject:screenBarButton];
    [mainToolbar setItems:items animated:YES];
    [items release];	
	
	if (externalWindow != nil)
	{
		[self.view addSubview:glViewController.view];
		[glViewController updateSizeOfGLView:nil];
		[externalWindow release];		
		externalWindow = nil;
	}
	externalScreen = nil;
}

- (void)displayOnExternalOrLocalScreen:(id)sender;
{
	if (externalWindow != nil)
	{
		// External window exists, need to move back locally
		[self.view addSubview:glViewController.view];
		CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
		glViewController.view.frame = CGRectMake(mainScreenFrame.origin.x, mainToolbar.bounds.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height -  mainToolbar.bounds.size.height);

		// Move view back to local window
		[externalWindow release];
		externalWindow = nil;
	}
	else
	{
		// Being displayed locally, move to external window
		CGRect externalBounds = [externalScreen bounds];
		externalWindow = [[UIWindow alloc] initWithFrame:externalBounds];
		externalWindow.backgroundColor = [UIColor whiteColor];
		externalWindow.screen = externalScreen;
		
		
//		if (glViewController.is
		
//		[glViewController.view removeFromSuperview];
//		glViewController.view = nil;
//		
//		glViewController.view = [[BenthosGLView alloc] initWithFrame:externalBounds];

		
//		BenthosGLView *glView = (BenthosGLView *)glViewController.view;
//		[EAGLContext setCurrentContext:glView.context];
//		[opengl destroyFramebuffer];
		
		
//		glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		[externalWindow addSubview:glViewController.view];

//		[EAGLContext setCurrentContext:glView.context];		
//		[glView createFramebuffer];
//		[glView configureProjection];
//		[glViewController _drawViewByRotatingAroundX:0.0f rotatingAroundY:0.0f scaling:1.0f translationInX:0.0f translationInY:0.0f];	
		
//		UILabel *helloWorld = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 400.0f, 400.0f, 60.0f)];
//		helloWorld.text = @"This page intentionally left blank.";
//		[externalWindow addSubview:helloWorld];
//		[helloWorld release];
		
		glViewController.view.frame = externalBounds;		
		[externalWindow makeKeyAndVisible];
	}
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate methods

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
	[downloadOptionsPopover dismissPopoverAnimated:YES];
	[downloadOptionsPopover release];
	downloadOptionsPopover = nil;
//	[downloadOptionsPopover release];
	
	[glViewController.visualizationActionSheet dismissWithClickedButtonIndex:2 animated:YES];
	glViewController.visualizationActionSheet = nil;
	[glViewController startOrStopAutorotation:NO];
	modelTablePopover = pc;
    modelTablePopover.delegate=self;
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
{		
	[(UINavigationController *)aViewController navigationBar].barStyle = UIBarStyleBlackOpaque;

//    barButtonItem.title = @"Models";
    NSMutableArray *items = [[mainToolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [mainToolbar setItems:items animated:YES];
    [items release];
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
	[(UINavigationController *)aViewController navigationBar].barStyle = UIBarStyleBlackOpaque;

    NSMutableArray *items = [[mainToolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [mainToolbar setItems:items animated:YES];
    [items release];
}	

#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;
{
	if (popoverController == downloadOptionsPopover)
	{
		[downloadOptionsPopover release];
		downloadOptionsPopover = nil;
	}
	else if (popoverController == modelTablePopover)
	{
		modelTablePopover = nil;

	}
    
    [glViewController startOrStopAutorotation:YES];

    
}


#pragma mark -
#pragma mark Accessors

@end
