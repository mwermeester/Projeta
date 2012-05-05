//
//  MainWindow.m
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "OutlineCollection.h"
#import "ProjetaAppDelegate.h"
#import "PTMainWindowViewController.h"
#import "User.h"

@implementation MainWindowController

@synthesize mainView;
@synthesize progressIndicator;
@synthesize mainWindowViewController;
@synthesize projectViewController;
@synthesize detailViewToolbarItem;
@synthesize progressCount;
@synthesize searchField;

@synthesize loggedInUser;
@synthesize addProjectButton;
@synthesize addProjectMenuItem;
@synthesize addSubProjectMenuItem;
@synthesize removeProjectButton;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if(self)
    {
        //perform any initializations
        
        // set counter to 0
        progressCount = 0;
        
        loggedInUser = nil;
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
    
    
    // cacher le bouton 'ajouter un projet'.
    [addProjectButton setHidden:YES];
    [removeProjectButton setHidden:YES];
    
    // ajouter 'observer' pour savoir quand le bouton 'ajouter un projet' a été clicqué.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popupButtonClicked:) name:NSPopUpButtonWillPopUpNotification object:nil];
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
    
    // cacher le bouton 'ajouter un projet'.
    [addProjectButton setHidden:YES];
    [removeProjectButton setHidden:YES];
    
    // désactiver le bouton 'vue projet'.
    [detailViewToolbarItem setEnabled:YES];
}

- (IBAction)switchToProjectView:(id)sender {
    // instantiate PTProjectView if needed (probably not).
    [projectViewController.view removeFromSuperview];
    projectViewController = nil;
    
    //if (!projectViewController)
        projectViewController = [[PTProjectViewController alloc] init];
    
    // keep a reference to this object(self) in mainWindowViewController object 
    [projectViewController setMainWindowController:self];
    
    // test
    //projectViewController.arrPrj = [[NSMutableArray alloc] initWithArray:[[mainWindowViewController projectListViewController] arrPrj]];
    //projectViewController.arrPrj = [[mainWindowViewController projectListViewController] arrPrj];
    
    
    // index du tab actuel.
    int selectedTabIndex = [[[mainWindowViewController projectListViewController] prjTabView] indexOfTabViewItem:[[[mainWindowViewController projectListViewController] prjTabView] selectedTabViewItem]];
    
    
    
    NSMutableArray *collectionArray = [[NSMutableArray alloc] init];
    OutlineCollection *tmpOutlColl = [[OutlineCollection alloc] init];
    tmpOutlColl.objectTitle = @"PROJET";
    //Project *tmpOutlColl = [[Project alloc] init];
    //tmpOutlColl.projectTitle = @"PROJET";
    
    if (selectedTabIndex == 0)
    {
        // afficher le projet selectionné et sous-projets.
        tmpOutlColl.childObject = [[NSMutableArray alloc] initWithArray:[[[mainWindowViewController projectListViewController] prjArrayCtrl] selectedObjects]];
        
    } else if (selectedTabIndex == 1) { 
        // afficher les projets et sous-projets du projet sélectionné dans la treeview.
        tmpOutlColl.childObject = [[NSMutableArray alloc] initWithArray:[[[mainWindowViewController projectListViewController] prjTreeController] selectedObjects]];

    }
    // afficher tous les projets et sous-projets.
    //tmpOutlColl.childObject = [[mainWindowViewController projectListViewController] arrPrj];
    // afficher les projets et sous-projets du projet sélectionné dans la treeview.
    //tmpOutlColl.childObject = [[NSMutableArray alloc] initWithArray:[[[mainWindowViewController projectListViewController] prjTreeController] selectedObjects]];
    [collectionArray addObject:tmpOutlColl];
    
    /*OutlineCollection *tmpOutlColl2 = [[OutlineCollection alloc] init];
    tmpOutlColl2.objectTitle = @"PROJECT";
    [collectionArray addObject:tmpOutlColl2];*/
    projectViewController.arrPrj = collectionArray;
    
    
    
    
    
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
    
    
    // afficher le bouton 'ajouter un projet'.
    [addProjectButton setHidden:NO];
    [removeProjectButton setHidden:NO];
    
    // désactiver le bouton 'vue projet'.
    [detailViewToolbarItem setEnabled:YES];
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

- (void)popupButtonClicked:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == addProjectButton) {
        
        if (projectViewController.view) {
            
            /*if ([projectViewController.arrPrj count] > 0)
            {
                
            }*/
            
            NSIndexPath *indexPath = [projectViewController.prjTreeController selectionIndexPath];
            
            NSLog(@"length: %lu", [indexPath length]);
            
            //NSIndexSet *ids = [projectViewController.altOutlineView selectedRowIndexes];
            //NSLog(@"ids: %@", ids);
            
            /*NSLog(@"ids: %@", [[projectViewController.altOutlineView itemAtRow:[projectViewController.altOutlineView selectedRow]] description]);
            
            NSArray *test = [projectViewController.prjTreeController selectedObjects];
            OutlineCollection *oc = [test objectAtIndex:0];
            Project *p = [[oc childObject] objectAtIndex:0];
            NSLog(@"ids: %@", p.projectTitle);*/
            
            // Enable 'add project' only if the current selected project is at least a subproject. (1 = header)
            if ([indexPath length] > 2) {
                [addProjectMenuItem setEnabled:YES];
            } else {
                [addProjectMenuItem setEnabled:NO];
            }
            
            // Enable 'add subproject' only if the current selected project is at least a project. (1 = header)
            if ([indexPath length] > 1) {
                [addSubProjectMenuItem setEnabled:YES];
            } else {
                [addSubProjectMenuItem setEnabled:NO];
            }
            
            //Project *p = [[projectViewController.prjTreeController selectedObjects] objectAtIndex:0];
            //NSLog(@"projectitle: %@", p.projectTitle);

            
        }
    }
}

@end
