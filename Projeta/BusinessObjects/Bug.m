//
//  Bug.m
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "Project.h"
#import "PTCommon.h"
#import "User.h"

@implementation Bug

@synthesize bugCategory;
@synthesize bugId;
@synthesize canceled;
@synthesize deleted;
@synthesize dateReported;
@synthesize details;
@synthesize fixed;
@synthesize priority;
@synthesize project;
@synthesize title;
@synthesize userAssigned;
@synthesize userReported;



+ (Bug *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Bug *instance = [[Bug alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    // dates
    //self.dateCreated = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"dateCreated"]];
    //self.endDate = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"endDate"]];
    //self.startDate = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"startDate"]];
    
    /*NSDateFormatter *df = [[NSDateFormatter alloc] init];
     NSLocale *enUSPOSIXLocale;
     enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
     [df setLocale:enUSPOSIXLocale];
     [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
     [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
     
     NSString *dateCreatedString = [aDictionary objectForKey:@"dateCreated"];
     if (dateCreatedString && ![dateCreatedString isKindOfClass:[NSNull class]]) {
     self.dateCreated = [df dateFromString:dateCreatedString];
     }*/
    
   /* @synthesize bugCategory;
    @synthesize priority;
    @synthesize project;
*/
    
    
    self.dateReported = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"dateReported"]];
    
    self.canceled = [(NSString *)[aDictionary objectForKey:@"canceled"] boolValue];
    self.deleted = [(NSString *)[aDictionary objectForKey:@"deleted"] boolValue];
    self.fixed = [(NSString *)[aDictionary objectForKey:@"fixed"] boolValue];
    
    self.details = [aDictionary objectForKey:@"details"];
    
    self.bugId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"bugId"]];
    self.title = [aDictionary objectForKey:@"title"];
    
    self.userAssigned = [User instanceFromDictionary:[aDictionary objectForKey:@"userAssigned"]];
    
    self.userReported = [User instanceFromDictionary:[aDictionary objectForKey:@"userReported"]];
    
    /*if ([[aDictionary objectForKey:@"parentProjectId"] isKindOfClass:[NSArray class]] == NO) {
        self.parentProjectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"parentProjectId"]];
    }
    
    
    // child projects
    if ([[aDictionary objectForKey:@"childProject"] isKindOfClass:[NSArray class]]) {
        
        NSArray *tmpChildProjects = [aDictionary objectForKey:@"childProject"];
        if (tmpChildProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[tmpChildProjects count]];
            
            for (id item in tmpChildProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Project instanceFromDictionary:item]];
                }
            }
            
            childProject = parsedProjects;
        }
    }*/
    
}


- (id) copyWithZone:(NSZone *)zone {
    
    Bug *copy = [[Bug alloc] init];
    
    
    copy.bugId = [bugId copyWithZone:zone];
    /*copy.projectTitle = [projectTitle copyWithZone:zone];
    copy.projectDescription = [projectDescription copyWithZone:zone];
    copy.endDate = [endDate copyWithZone:zone];
    copy.dateCreated = [dateCreated copyWithZone:zone];
    copy.endDateReal = [endDateReal copyWithZone:zone];
    copy.flagPublic = flagPublic;
    copy.completed = completed;
    copy.canceled = canceled;
    copy.parentProjectId = [parentProjectId copyWithZone:zone];
    copy.startDate = [startDate copyWithZone:zone];
    copy.startDateReal = [startDateReal copyWithZone:zone];
    copy.userCreated = [userCreated copyWithZone:zone];
    copy.childProject = [childProject copyWithZone:zone];*/
    
    return copy;
}

@end
