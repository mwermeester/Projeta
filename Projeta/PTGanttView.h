//
//  PTGanttView.h
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Project;

@interface PTGanttView : NSView

@property (strong) Project *project;

@end