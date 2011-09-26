//
//  PTProjectListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Project.h"

@class MainWindowController;

@interface PTProjectListViewController : NSViewController {
    NSMutableArray *arrPrj;     // array which holds the projects
    NSArrayController *prjArrayCtrl;    // array controller
    NSCollectionView *prjCollectionView;
}

@property (strong) NSMutableArray *arrPrj;
@property (strong) IBOutlet NSArrayController *prjArrayCtrl;
@property (strong) IBOutlet NSCollectionView *prjCollectionView;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

@end