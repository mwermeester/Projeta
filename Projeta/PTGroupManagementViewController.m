//
//  PTGroupManagementViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTGroupManagementViewController.h"
#import "PTUsergroupHelper.h"
#import "Usergroup.h"

@implementation PTGroupManagementViewController

@synthesize arrUsrGrp;
@synthesize usergroupArrayCtrl;
@synthesize usergroupTableView;
@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTGroupManagementView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        arrUsrGrp = [[NSMutableArray alloc] init];
        
        // Fetch user groups from webservice.
        [self fetchUsergroups];
    }
    
    return self;
}

// Fetch user groups from webservice.
- (void)fetchUsergroups {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/usergroups/all"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self fetchRequestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self fetchRequestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

- (void)fetchRequestFinished:(NSMutableData*)data {
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrUsrGrp"] addObjectsFromArray:[PTUsergroupHelper setAttributesFromJSONDictionary:dict]];
    
    // sort the user list by username. 
    [usergroupTableView setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES selector:@selector(compare:)], nil]];
}

- (void)fetchRequestFailed:(NSError*)error {
    
}

- (IBAction)addUsergroupButtonClicked:(id)sender {
    
    Usergroup *usrgrp = [[Usergroup alloc] init];
    [usergroupArrayCtrl insertObject:usrgrp atArrangedObjectIndex:([arrUsrGrp count])];
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(int)rowIndex {
    
    NSArray *selectedObjects = [usergroupArrayCtrl selectedObjects];
    
    for (Usergroup *usrgrp in selectedObjects)
    {
        // update Usergroup.
        [self updateUsergroup:usrgrp];
        //[PTUserHelper updateUser:usr mainWindowController:mainWindowController];
    }
}

- (void)updateUsergroup:(Usergroup *)theUsergroup {
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSDictionary *dict = [theUsergroup dictionaryWithValuesForKeys:[theUsergroup allKeys]];
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/usergroups"];
    
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
    
}

@end