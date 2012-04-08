//
//  PTTaskHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "PTCommon.h"
#import "PTTaskHelper.h"
#import "Task.h"

@implementation PTTaskHelper

@synthesize task = task;

+ (PTTaskHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTTaskHelper *instance = [[PTTaskHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedTask = [aDictionary objectForKey:@"task"];
    if ([receivedTask isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedTask = [NSMutableArray arrayWithCapacity:[receivedTask count]];
        for (NSDictionary *item in receivedTask) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedTask addObject:[Task instanceFromDictionary:item]];
            }
        }
        
        self.task = parsedTask;
        
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"task"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedProjects = [aDictionary objectForKey:@"task"];
        if (receivedProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
            
            for (id item in receivedProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Task instanceFromDictionary:item]];
                }
            }
            
            return parsedProjects;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"task"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:1];
        
        [parsedProjects addObject:[Task instanceFromDictionary:[aDictionary objectForKey:@"task"]]];
        
        return parsedProjects;
    }
    
    return nil;
}


// Crée une nouvelle tâche dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createTask:(Task *)theTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theTask dictionaryWithValuesForKeys:[theTask createTaskKeys]]];
    
    
    // créer dictionnaire 'user création'.
    NSDictionary *userDict = [theTask.userCreated dictionaryWithValuesForKeys:[theTask.userCreated userIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:userDict forKey:@"userCreated"];
    
    // s'il s'agit d'un sous-projet...
    if (theTask.parentTaskId) {
        // créer dictionnaire 'parentProjectId'.
        Task *parentTask = [[Task alloc] init];
        parentTask.taskId = theTask.parentTaskId;
        
        NSDictionary *parentTaskDict = [parentTask dictionaryWithValuesForKeys:[parentTask taskIdKey]];
        // ajouter ce dictionnaire sous la clé 'parentProjectId'.
        [dict setObject:parentTaskDict forKey:@"parentTaskId"];
    }
    
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/tasks/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    //success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

+ (BOOL)deleteTask:(Task *)theTask successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)())failureBlock mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from Task object.
    NSDictionary *dict = [theTask dictionaryWithValuesForKeys:[theTask taskIdKey]];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/tasks/delete"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

@end
