//
//  PTUsersView.m
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserManagementViewController.h"
#import "PTUserHelper.h"
#import "User.h"
#import <Foundation/NSJSONSerialization.h>
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTUserHelper.h"
#import "PTUserDetailsWindowController.h"
#import "MainWindowController.h"
#import "Role.h"

@implementation PTUserManagementViewController
@synthesize searchField;
@synthesize deleteButton;

@synthesize arrayCtrl;
@synthesize usersTableView;

@synthesize arrUsr;

@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTUserManagementView" bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization code here.
        
        arrUsr = [[NSMutableArray alloc] init];
        
        // load user defaults from preferences file
        //NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
        
        // get server URL as string
        NSString *urlString = [PTCommon serverURLString];
        // build URL by adding resource path
        urlString = [urlString stringByAppendingString:@"resources/users/all"];
        
        // convert to NSURL
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        // NSURLConnection - MWConnectionController
        MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                        initWithSuccessBlock:^(NSMutableData *data) {
                                                            [self requestFinished:data];
                                                        }
                                                        failureBlock:^(NSError *error) {
                                                            [self requestFailed:error];
                                                        }];
        
        
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
        
                
        // get users
        //NSURL *url = [NSURL URLWithString:@"https://luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/"];
        // get user
        //NSURL *url = [NSURL URLWithString:@"https://test:test@luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/2?"];
        
        // register for detecting changes in table view
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:)
        //                                             name:NSControlTextDidEndEditingNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:nil];
    
    // register for detecting changes in table view
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:)
      //   name:NSControlTextDidEndEditingNotification object:nil];
    
    [[mainWindowController searchField] bind:@"predicate" toObject:arrayCtrl withKeyPath:@"filterPredicate" options:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"predicate", NSDisplayNameBindingOption,
      @"(username contains[cd] $value) OR (firstName contains[cd] $value) OR (lastName contains[cd] $value) OR (emailAddress contains[cd] $value)",
      NSPredicateFormatBindingOption,
      nil]];
}

- (void)addObservers {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:nil];
    
    // register for detecting changes in table view
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:)
      //                                           name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

- (void)removeObservers {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)dealloc
{
    // remove the observer.
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(int)rowIndex {
    
    NSArray *selectedObjects = [arrayCtrl selectedObjects];
    
    for (User *usr in selectedObjects)
    {
        // update User
        //[self updateUser:usr];
        [PTUserHelper updateUser:usr mainWindowController:mainWindowController];
    }
}

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    NSError *error;
    
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"response: %@", responseString);
    //NSDictionary *dict = [[NSDictionary alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrUsr"] addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    
    // sort the user list by username. 
    [usersTableView setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(compare:)], nil]];
    
    //[arrayCtrl addObjects:[PTUser setAttributesFromDictionary2:dict]];
    
    // add a new user programmatically
    /*
     User *user = [[User alloc] init];
     user.username = @"test";
     [arrayCtrl addObject:user];
     */
}

- (void)requestFailed:(NSError*)error
{
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

- (IBAction)deleteButtonClicked:(NSButton*)sender {
    
    /*for (User* usr in arrUsr)
    {
        NSLog(@"t: %@", [usr username]);
    }*/
    NSRunAlertPanel(@"Not implemented", @"Not implemented yet.", @"OK", nil, nil);
}

- (IBAction)detailsButtonClicked:(id)sender {
    
    // open user details window. 
    // NO means that the user already exists.
    [self openUserDetailsWindow:NO];
    
        
        //NSLog(@"items: %lu", [[PTRoleHelper rolesForUser:userDetailsWindowController.user] count]);
        
        //User *u = [[selectedObjects objectAtIndex:0] copy];
        //userDetailsWindowController.user = u;
        
        //[NSApp runModalForWindow:[userDetailsWindowController window]];
        //[userDetailsWindowController showWindow:self];
}

- (void)openUserDetailsWindow:(BOOL)isNewUser {
    // get selected users.
    NSArray *selectedObjects = [arrayCtrl selectedObjects];
    
    // if a user is selected, open the window to show its user details.
    if ([selectedObjects count] == 1) {
        
        userDetailsWindowController = [[PTUserDetailsWindowController alloc] init];
        userDetailsWindowController.parentUserManagementViewCtrl = self;
        userDetailsWindowController.mainWindowController = mainWindowController;
        userDetailsWindowController.isNewUser = isNewUser;
        userDetailsWindowController.user = [selectedObjects objectAtIndex:0];
        
        // fetch user roles.
        //userDetailsWindowController.user.roles = [PTRoleHelper rolesForUser:userDetailsWindowController.user];
        [PTRoleHelper rolesForUser:userDetailsWindowController.user successBlock:^(NSMutableArray *userRoles){
            
            // sort user roles alphabetically.
            [userRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
                
                return [r1.code compare:r2.code];
            }];
            
            //if (isNewUser == NO) {
            userDetailsWindowController.user.roles = userRoles;
            //} else {
            //    userDetailsWindowController.user.roles = [[NSMutableArray alloc] init];
            //}
            
            //[[userDetailsWindowController.user mutableArrayValueForKey:@"roles"] addObjectsFromArray:userRoles];
            
            //[userDetailsWindowController showWindow:self];
        }];
        
        // fetch available roles.
        [PTRoleHelper rolesAvailable:^(NSMutableArray *availableRoles){
            
            // sort available roles alphabetically.
            [availableRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
                
                return [r1.code compare:r2.code];
            }];
            
            userDetailsWindowController.availableRoles = availableRoles;
            
            [userDetailsWindowController showWindow:self];
        }];
    }
}

// Don't allow table view selection to be changed when user details window is open.
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView {
    
    if ([[userDetailsWindowController window] isVisible])
        return NO;
    else
        return YES;
}

// update user when finished editing cell in table view
- (void)editingDidEnd:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == usersTableView) {
        
        NSArray *selectedObjects = [arrayCtrl selectedObjects];
        
        for (User *usr in selectedObjects)
        {
            // update User
            //[self updateUser:usr];
            [PTUserHelper updateUser:usr mainWindowController:mainWindowController];
            
            
            //        // works! -> updateUser method
            //        NSDictionary *dict = [usr dictionaryWithValuesForKeys:[usr allKeys]];
            //        
            //        NSError* error;
            //        NSData *data = [[NSData alloc] init];
            //        data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            //        
            //        //NSLog(@"JSON result: %@", data);
            //        
            //        NSString* newStr = [[NSString alloc] initWithData:data
            //                                                 encoding:NSUTF8StringEncoding];
            //        
            //        NSLog(@"JSON result: %@", newStr);
        }
    }
}

// moved to PTUserHelper
/*- (void)updateUser:(User *)theUser
{
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeys]];
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {

                                                    }
                                                    failureBlock:^(NSError *error) {

                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    //[urlRequest setHTTPMethod:@"POST"]; // create
    [urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
}*/

- (IBAction)addButtonClicked:(id)sender {
    
    //[arrayCtrl add:sender];
    User *usr = [[User alloc] init];
    [arrayCtrl insertObject:usr atArrangedObjectIndex:([arrUsr count])];
    //[arrayCtrl insertObject:[arrayCtrl newObject] atArrangedObjectIndex:([arrUsr count])];
    
    //[self detailsButtonClicked:nil];
    
    // open user details window. 
    // YES means that we're creating a new user.
    [self openUserDetailsWindow:YES];
    
    
}

- (IBAction)removeButtonClicked:(id)sender {
    
}

// fires, when user types something in the search field.
- (IBAction)findUser:(id)sender {
    NSLog(@"find: %@", [searchField stringValue]);
}


@end
