//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"

@interface PTUserHelper : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;

#pragma mark webservice methods

// updates username, first name and last name of a given user. 
// mainWindowController parameter is user for animating the main window's progress indicator.
+ (void)updateUser:(User *)theUser mainWindowController:(id)sender;

@end
