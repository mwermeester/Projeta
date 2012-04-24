//
//  PTProjectDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class Bug;
@class PTBugListViewController;

@interface PTBugDetailsWindowController : NSWindowController {
    
    BOOL isNewBug;
    //BOOL isPersonalTask;
    __weak NSButton *okButton;
    __weak NSComboBox *comboDevelopers;
    
    NSMutableArray *arrDevelopers;
}

@property (strong) Bug *bug;

@property (assign) BOOL isNewBug;

//@property (assign) BOOL isPersonalTask;

@property (strong) NSMutableArray *arrDevelopers;

// test -- can remove
@property (strong) NSIndexPath *tskTreeIndexPath;
@property (assign) NSUInteger prjArrCtrlIndex;

// parent project list view controller.
@property (strong) PTBugListViewController *parentBugListViewController;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSButton *okButton;
@property (weak) IBOutlet NSComboBox *comboDevelopers;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice;

@end
