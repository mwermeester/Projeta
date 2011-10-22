//
//  PTRoleHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface PTRoleHelper : NSObject {
    NSArray *role;
}

@property (nonatomic, copy) NSArray *role;

+ (PTRoleHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

// Returns all available roles.
+ (void)rolesAvailable:(void(^)(NSMutableArray *))successBlock_;
//+ (NSMutableArray *)rolesForUser:(User *)aUser;
+ (void)rolesForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock_;
//+ (NSMutableArray *)rolesForUserName:(NSString *)aUsername;
+ (void)rolesForUserName:(NSString *)aUsername successBlock:(void(^)(NSMutableArray *))successBlock_;

//+ (void)updateRolesForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock;

//
+ (void)updateRolesForUser:(User *)aUser roles:(NSMutableDictionary *)roles;

@end
