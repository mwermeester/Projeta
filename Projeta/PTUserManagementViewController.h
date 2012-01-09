//
//  PTUsersView.h
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"

@class MainWindowController;
@class PTUserDetailsWindowController;

@interface PTUserManagementViewController : NSViewController {
    NSMutableArray *arrUsr;     // array which holds the users
    NSTableView *usersTableView;
    NSArrayController *arrayCtrl;   // array controller
    
    // user details window
    PTUserDetailsWindowController *userDetailsWindowController;
    
    __weak NSSearchField *searchField;
}

@property (strong) NSMutableArray *arrUsr;
@property (strong) IBOutlet NSTableView *usersTableView;
@property (strong) IBOutlet NSArrayController *arrayCtrl;
@property (strong) IBOutlet NSButton *deleteButton;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

@property (weak) IBOutlet NSSearchField *searchField;

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)removeButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;

- (void)openUserDetailsWindow:(BOOL)isNewUser;

//- (void)updateUser:(User *)theUser;

- (void)addObservers;
- (void)removeObservers;


- (IBAction)findUser:(id)sender;

@end
