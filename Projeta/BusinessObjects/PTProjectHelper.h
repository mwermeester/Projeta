//
//  PTProjectHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTProjectHelper : NSObject {
    NSArray *projects;
}

@property (nonatomic, copy) NSArray *projects;

+ (PTProjectHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

// Crée un nouveau projet dans la base de données.
+ (BOOL)createProject:(Project *)theProject successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender;
// Supprime un projet dans la base de données.
//+ (BOOL)deleteProject:(Project *)theProject successBlock:(void(^)(BOOL))successBlock failureBlock:(void(^)())failureBlock mainWindowController:(id)sender;
+ (BOOL)deleteProject:(Project *)theProject successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)())failureBlock mainWindowController:(id)sender;

@end