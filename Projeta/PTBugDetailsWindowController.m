//
//  PTProjectDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "Bug.h"
#import "PTMainWindowViewController.h"
#import "PTBugDetailsWindowController.h"
#import "PTBugHelper.h"
#import "PTBugListViewController.h"
#import "PTUserHelper.h"

Bug *bugCopy;

@implementation PTBugDetailsWindowController

@synthesize bug;

@synthesize isNewBug;
//@synthesize isPersonalTask;

@synthesize arrDevelopers;

//@synthesize parentProjectListViewController;
@synthesize mainWindowController;
@synthesize okButton;
@synthesize comboDevelopers;


@synthesize tskTreeIndexPath;
@synthesize prjArrCtrlIndex;

@synthesize parentBugListViewController;

- (id)init
{
    self = [super initWithWindowNibName:@"PTBugDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        arrDevelopers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // faire une copie du projet en cours.
    bugCopy = [[Bug alloc] init];
    bugCopy = [bug copy];
    
    // debug
    /*for (Project *p in project.childProject) {
        
        NSLog(@"title: %@", [p projectTitle] );
        
        for (Project *p1 in p.childProject) {
            NSLog(@"titlesub: %@", [p1 projectTitle] );
        }
        
    }
    
    for (Project *p in projectCopy.childProject) {
        
        NSLog(@"title: %@", [p projectTitle] );
        
        for (Project *p1 in p.childProject) {
            NSLog(@"titlesub: %@", [p1 projectTitle] );
        }
        
    }*/
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
    [self fetchDevelopersFromWebservice];
}

// lorsque l'utilisateur clique sur le "x rouge" pour fermer la fenêtre. 
- (void)windowShouldClose:(NSNotification *)notification
{
    
    // annuler les changements.
    [self cancelButtonClicked:self];
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    if (isNewBug == NO) {
        
        // cancel changes -> replace current project with previously made copy of project.
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:projectCopy];
        
        // cancel changes -> replace current project with previously made copy of project.
        if (tskTreeIndexPath) {
            
            //[parentTaskListViewController.taskTreeCtrl removeObjectAtArrangedObjectIndexPath:tskTreeIndexPath];
            
            //[parentTaskListViewController.taskTreeCtrl insertObject:taskCopy atArrangedObjectIndexPath:tskTreeIndexPath];
            
           /* [parentProjectListViewController.prjTreeController removeObjectAtArrangedObjectIndexPath:prjTreeIndexPath];
        
            [parentProjectListViewController.prjTreeController insertObject:projectCopy atArrangedObjectIndexPath:prjTreeIndexPath];*/
        }
        else {
           /* [[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:projectCopy];
            
            // re-sélectionner le projet.
            [parentProjectListViewController.prjArrayCtrl setSelectionIndex:prjArrCtrlIndex];*/
        }
             
        // TODO: select another item to avoid crash.
        //[parentProjectListViewController.prjTreeController setSelectionIndexPath:prjTreeIndexPath];       
        
    } else {
        // remove the temporary inserted/created user.
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] removeObject:project];
        
       /* [[parentProjectListViewController prjTreeController] remove:self];*/
        
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] removeObjectIdenticalTo:project];
    }
       
    // close this window.
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {
    
    BOOL bugUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:okButton];
    
    // créer une nouvelle tâche.
    if (isNewBug == YES) {
        
        
        // user created.
        bug.userReported = mainWindowController.loggedInUser;
        
        /*
        bugUpdSuc = [PTTaskHelper createTask:task successBlock:^(NSMutableData *data) { 
                                    [self finishedCreatingTask:data];
                                }
                                 failureBlock:^() {
                                     
                                 } mainWindowController:parentTaskListViewController];
         */
    }
    // mettre à jour projet existant.
    else {
        /*
        bugUpdSuc = [PTTaskHelper updateTask:task successBlock:^(NSMutableData *data) {
            [self finishedCreatingTask:data];
        } failureBlock:^() {
            
        }
                              mainWindowController:parentTaskListViewController];
         */
    }
}

- (void)finishedCreatingBug:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdBugArray = [[NSMutableArray alloc] init];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    /*[createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];*/
    
    NSLog(@"count: %lu", [createdBugArray count]);
    
    if ([createdBugArray count] == 1) {

        for (Bug *b in createdBugArray) {
   
            /*
            if (b.parentTaskId) {
                [parentTaskListViewController.taskTreeCtrl remove:task];
                
                NSIndexPath *indexPath = [parentTaskListViewController.taskTreeCtrl selectionIndexPath];
                
                [parentTaskListViewController.taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
            
            } else {
                [[parentTaskListViewController mutableArrayValueForKey:@"arrTask"] replaceObjectAtIndex:[parentTaskListViewController.arrTask indexOfObject:task] withObject:tsk];
            }*/
            
            // reassign user with user returned from web-service. 
            self.bug = b;
            
            //NSLog(@"id: %d", [prj.projectId intValue]);
            //NSLog(@"title: %@", prj.projectTitle);
        }
    }
    
    // close this window.
    [self close];
}

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice
{
    // get developers from webservice.
    [PTUserHelper developers:^(NSMutableArray *developers) {
        
        // sort descriptors for array.
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullNameAndUsername"
                                                                        ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        // sort array and affect fetched array to local array.
        [[self mutableArrayValueForKey:@"arrDevelopers"] addObjectsFromArray:[developers sortedArrayUsingDescriptors:sortDescriptors]];
        
        
    }
                failureBlock:^(NSError *error) {
                    
                }];
}

@end
