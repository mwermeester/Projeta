//
//  PTProjectDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class Project;
@class PTProjectListViewController;

@interface PTProjectDetailsWindowController : NSWindowController {
    
    BOOL isNewProject;
    __weak NSButton *okButton;
}

@property (strong) Project *project;

@property (assign) BOOL isNewProject;

// parent project list view controller.
@property (strong) PTProjectListViewController *parentProjectListViewController;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSButton *okButton;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

@end
