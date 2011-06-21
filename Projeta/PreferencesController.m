//
//  PreferencesController.m
//  Projeta
//
//  Created by Michael Wermeester on 18/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PreferencesController.h"
#import "ASIHTTPRequest.h"

static PreferencesController *_sharedPrefsWindowController = nil;

static NSString *nibName = @"Preferences";

@implementation PreferencesController

/*@synthesize username;
@synthesize password;
@synthesize URL;*/

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

+ (PreferencesController *)sharedPrefsWindowController
 {
 if (!_sharedPrefsWindowController) {
 _sharedPrefsWindowController = [[self alloc] initWithWindowNibName:nibName];
 }
 
 return _sharedPrefsWindowController;
}

-(void)awakeFromNib{
	[self.window setContentSize:[generalPreferenceView frame].size];
	[[self.window contentView] addSubview:generalPreferenceView];
	[bar setSelectedItemIdentifier:@"General"];
	[self.window center];
}

-(NSView *)viewForTag:(NSInteger)tag {
    NSView *view = nil;
    
	switch(tag) {
		case 0: default: view = generalPreferenceView; break;
		case 1: view = accountPreferenceView; break;
	}
    
    return view;
}
-(NSRect)newFrameForNewContentView:(NSView *)view {
	
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

-(IBAction)switchView:(id)sender {
	
	NSInteger tag = (int)[sender tag];
	
	NSView *view = [self viewForTag:tag];
	NSView *previousView = [self viewForTag: currentViewTag];
	currentViewTag = tag;
	NSRect newFrame = [self newFrameForNewContentView:view];

    
    NSView *emptyView = [[NSView alloc] init];
    
    [[self.window contentView] replaceSubview:previousView with:emptyView];
    
    //NSRect frame = [self.window frame];
    //frame.origin = newFrame.origin;
    
    //NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    //NSSize newSize = newFrameRect.size;
    //NSSize newSize = newFrame.size;
    
    //frame.size = newSize;
    
    //[self.window setFrame:frame display:YES animate:YES];
    [self.window setFrame:newFrame display:YES animate:YES];
    
   
    [[self.window contentView] replaceSubview:emptyView with:view]; 
}


#pragma mark Credentials - Keychain

- (NSString*)username
{
    return @"mw";
}

- (void)setUsername:(NSString *)username
{
    [self saveCredentialsToKeychain];
}

- (NSString*)password
{
    return @"test";
}

- (void)setPassword:(NSString *)password
{
    [self saveCredentialsToKeychain];
}

/*- (NSString*)URL
{
    return @"https://luckycode.be:8181/test";
}*/

- (NSURL*)URL
{
    // load user defaults from preferences file
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL"];
    
    // return URL
    return [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)setURL:(NSString *)theURL
{
    // save user defaults to preferences file
    [[NSUserDefaults standardUserDefaults] setObject:theURL forKey:@"URL"];
    
    // save credentials to keychain (call ASIHTTPRequest method)
    [self saveCredentialsToKeychain];
}

- (void)saveCredentialsToKeychain
{
    
    //NSURL *url = [NSURL URLWithString:[[self URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLCredential* credential;
	credential = [NSURLCredential credentialWithUser:[self username]
											password:[self password]
										 persistence:NSURLCredentialPersistencePermanent];

    // save credentials to keychain
    [ASIHTTPRequest saveCredentials:credential forHost:[[self URL] host] port:[[[self URL] port] intValue] protocol:[[self URL] scheme] realm:nil];
}

@end
