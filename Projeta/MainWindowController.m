//
//  MainWindow.m
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "ProjetaAppDelegate.h"
#import "PTMainWindowViewController.h"

@implementation MainWindowController

@synthesize mainView;
@synthesize progressIndicator;
@synthesize mainWindowViewController;
@synthesize projectViewController;
@synthesize detailViewToolbarItem;
@synthesize progressCount;
@synthesize searchField;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if(self)
    {
        //perform any initializations
        
        // set counter to 0
        progressCount = 0;
    }
    return self;
}

/*- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}*/

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // instantiate PTMainWindowView.
    mainWindowViewController = [[PTMainWindowViewController alloc] init];
    
    // keep a reference to this object(self) in mainWindowViewController object 
    [mainWindowViewController setMainWindowController:self];
    
    /*// adjust for window margin.
	NSWindow* window = self.window;
	CGFloat padding = [window contentBorderThicknessForEdge:NSMinYEdge];
	NSRect frame = [window.contentView frame];
	frame.size.height -= padding;
	frame.origin.y += padding;
    mainWindowViewController.view.frame = frame;*/
    
    // resize view to fit ContentView
    mainWindowViewController.view.frame = [self frameWithContentViewFrameSize];
    
    // add the view to the window.
    //[self.mainView addSubview:mainWindowViewController.view];
    //[window.contentView addSubview:mainWindowViewController.view];
    [self.window.contentView addSubview:mainWindowViewController.view];
    
    // auto resize the view.
    [mainWindowViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // set the view to receive NSResponder events (used for trackpad and mouse gestures)
    [mainWindowViewController.view setNextResponder:mainWindowViewController];
}

- (void)windowDidResize:(NSNotification *)notification
{
   
}

- (void)windowWillClose:(NSNotification *)notification
{
    // remove reference to this window
    [ProjetaAppDelegate removeMainWindow:self];
}

- (IBAction)switchToMainView:(id)sender {
    // instantiate PTProjectView if needed (probably not).
    if (!mainWindowViewController)
        mainWindowViewController = [[PTMainWindowViewController alloc] init];
    
    // keep a reference to this object(self) in mainWindowViewController object 
    [mainWindowViewController setMainWindowController:self];
    
    // resize view to fit ContentView
	mainWindowViewController.view.frame = [self frameWithContentViewFrameSize];
    
    //[window.contentView removeFromSuperview];
    [projectViewController.view removeFromSuperview];
    
    // add the view to the window.
    [self.window.contentView addSubview:mainWindowViewController.view];
    
    // auto resize the view.
    [mainWindowViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // set the view to receive NSResponder events (used for trackpad and mouse gestures)
    [mainWindowViewController.view setNextResponder:mainWindowViewController];
}

- (IBAction)switchToProjectView:(id)sender {
    // instantiate PTProjectView if needed (probably not).
    if (!projectViewController)
        projectViewController = [[PTProjectViewController alloc] init];
    
    // keep a reference to this object(self) in mainWindowViewController object 
    [projectViewController setMainWindowController:self];
    
    
    // test
    //projectViewController.arrPrj = [[NSMutableArray alloc] initWithArray:[[mainWindowViewController projectListViewController] arrPrj]];
    projectViewController.arrPrj = [[mainWindowViewController projectListViewController] arrPrj];
    
    
    // resize view to fit ContentView
	projectViewController.view.frame = [self frameWithContentViewFrameSize];
    
    //[window.contentView removeFromSuperview];
    [mainWindowViewController.view removeFromSuperview];
    
    // add the view to the window.
    [self.window.contentView addSubview:projectViewController.view];
    
    // auto resize the view.
    [projectViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // set the view to receive NSResponder events (used for trackpad and mouse gestures)
    [projectViewController.view setNextResponder:projectViewController];
}

// returns a frame which fits the ContentView
- (NSRect)frameWithContentViewFrameSize
{
    // adjust for window margin.
    NSWindow* window = self.window;
	CGFloat padding = [window contentBorderThicknessForEdge:NSMinYEdge];
	NSRect frame = [window.contentView frame];
	frame.size.height -= padding;
	frame.origin.y += padding;
    
    return frame;
}


#pragma mark -
#pragma mark Gestures handling (trackpad and mouse events)

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis {
    
    // forward to the subview
    [self.nextResponder wantsScrollEventsForSwipeTrackingOnAxis:axis];
    
    return NO;
}

- (void)scrollWheel:(NSEvent *)event {
    
    // forward to the subview
    [self.nextResponder scrollWheel:event];
}


#pragma mark -
#pragma mark progress indicators and animations

// start animating the circular progress indicator.
- (void)startProgressIndicatorAnimation {
    
    // increment the counter to keep track of the number of requests.
    progressCount++;
    
    // start animating the circular progress indicator.
    [progressIndicator startAnimation:self];
}

// stop animating the circular progress indicator.
- (void)stopProgressIndicatorAnimation {
    
    // decrement the counter.
    progressCount--;
    
    // if all requests have been handled, stop the animation.
    if (progressCount == 0)
        [progressIndicator stopAnimation:self];
}

@end
