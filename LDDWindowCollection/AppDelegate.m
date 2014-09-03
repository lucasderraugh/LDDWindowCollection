//
//  AppDelegate.m
//  LDDWindowCollection
//
//  Created by Lucas Derraugh on 9/2/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import "AppDelegate.h"
#import "LDDWindowControllerCollection.h"
#import "WindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) LDDWindowControllerCollection *windowControllerCollection;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _windowControllerCollection = [[LDDWindowControllerCollection alloc] init];
}

- (IBAction)showWithoutAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [_windowControllerCollection presentWindowController:wc animatedFromBottom:NO];
}

- (IBAction)showWithAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [_windowControllerCollection presentWindowController:wc animatedFromBottom:YES];
}

- (IBAction)showWithCustomAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [_windowControllerCollection presentWindowController:wc withAnimationBlock:^(NSWindow *window, NSRect proposedEndFrame) {
        [window setAlphaValue:0.0];
        [window setFrame:NSOffsetRect(proposedEndFrame, 0, -20) display:YES];
        [window makeKeyAndOrderFront:nil];
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:1.0];
        [[window animator] setAlphaValue:1.0];
        [[window animator] setFrame:proposedEndFrame display:YES];
        [NSAnimationContext endGrouping];
    }];
}



@end
