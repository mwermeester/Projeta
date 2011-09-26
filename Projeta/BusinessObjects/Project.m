//
//  Project.m
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Project.h"
#import "PTCommon.h"
#import "PTProjectHelper.h"
#import "User.h"

@implementation Project

@synthesize dateCreated = dateCreated;
@synthesize endDate = endDate;
@synthesize flagPublic = flagPublic;
@synthesize projectDescription = projectDescription;
@synthesize projectId = projectId;
@synthesize projectTitle = projectTitle;
@synthesize startDate = startDate;
@synthesize userCreated = userCreated;
@synthesize childProject = childProject;

+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Project *instance = [[Project alloc] init];
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
    
    self.dateCreated = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"dateCreated"]];
    self.endDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"endDate"]];
    self.startDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"startDate"]];
    
    self.flagPublic = [(NSString *)[aDictionary objectForKey:@"flagPublic"] boolValue];
    
    self.projectDescription = [aDictionary objectForKey:@"projectDescription"];
    
    self.projectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"projectId"]];
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
    
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
    }
    
}

@end