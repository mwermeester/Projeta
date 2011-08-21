//
//  PTProjectViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 14/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTProjectViewController.h"
#import "MainWindowController.h"

@implementation PTProjectViewController

@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTProjectView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


#pragma mark -
#pragma mark Gestures handling (trackpad and mouse events)

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis 
{
    return (axis == NSEventGestureAxisHorizontal) ? YES : NO;
}

- (void)scrollWheel:(NSEvent *)event 
{
    // NSScrollView is instructed to only forward horizontal scroll gesture events (see code above). However, depending
    // on where your controller is in the responder chain, it may receive other scrollWheel events that we don't want
    // to track as a fluid swipe because the event wasn't routed though an NSScrollView first.
    if ([event phase] == NSEventPhaseNone) return; // Not a gesture scroll event.
    if (fabsf([event scrollingDeltaX]) <= fabsf([event scrollingDeltaY])) return; // Not horizontal
    // If the user has disabled tracking scrolls as fluid swipes in system preferences, we should respect that.
    // NSScrollView will do this check for us, however, depending on where your controller is in the responder chain,
    // it may scrollWheel events that are not filtered by an NSScrollView.
    if (![NSEvent isSwipeTrackingFromScrollEventsEnabled]) return;
    
    //NSLog(@"scrolled on PTProjectViewController");
    
    __block BOOL animationCancelled = NO;
    [event trackSwipeEventWithOptions:0 dampenAmountThresholdMin:-5 max:5
                         usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
                             if (animationCancelled) {
                                 *stop = YES;
                                 // Tear down animation overlay
                                 return;
                             }
                             if (phase == NSEventPhaseBegan) {
                                 // Setup animation overlay layers
                             }
                             // Update animation overlay to match gestureAmount
                             if (phase == NSEventPhaseEnded) {
                                 // The user has completed the gesture successfully.
                                 // This handler will continue to get called with updated gestureAmount
                                 // to animate to completion, but just in case we need
                                 // to cancel the animation (due to user swiping again) setup the
                                 // controller / view to point to the new content / index / whatever
                                 
                                 // if right swipe, switch to main view
                                 if ([event deltaX] > 0) 
                                     [mainWindowController switchToMainView:self];
                             } else if (phase == NSEventPhaseCancelled) {
                                 // The user has completed the gesture un-successfully.
                                 // This handler will continue to get called with updated gestureAmount
                                 // But we don't need to change the underlying controller / view settings.
                             }
                             if (isComplete) {
                                 // Animation has completed and gestureAmount is either -1, 0, or 1.
                                 // This handler block will be released upon return from this iteration.
                                 // Note: we already updated our view to use the new (or same) content
                                 // above. So no need to do that here. Just...
                                 // Tear down animation overlay here
                                 //self->_swipeAnimationCanceled = NULL;
                             }
                         }];
}

@end