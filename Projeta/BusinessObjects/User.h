//
//  User.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface User : NSObject {
    NSString *password;
    NSNumber *userId;
    NSString *username;
    
    NSString *emailAddress;
    NSString *firstName;
    NSString *lastName;
}

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

//
- (NSArray *)allKeys;
// keys needed for updating username, first name, last name and email address.
- (NSArray *)namesEmailKeys;

@end