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

@property (nonatomic, strong) LDDWindowControllerCollection *windowCollection;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _windowCollection = [[LDDWindowControllerCollection alloc] init];
}

#pragma mark - IBActions

- (IBAction)showWithoutAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [self.windowCollection presentWindowController:wc];
}

- (IBAction)showWithAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [self.windowCollection presentWindowController:wc animatedFromBottom:YES];
}

- (IBAction)showWithCustomAnimation:(id)sender {
    WindowController *wc = [[WindowController alloc] init];
    [self.windowCollection presentWindowController:wc withAnimationBlock:^(NSWindow *window, NSRect proposedEndFrame) {
        window.alphaValue = 0.0;
        [window setFrame:NSOffsetRect(proposedEndFrame, 0, -20) display:YES];
        [window makeKeyAndOrderFront:nil];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1.0;
            window.animator.alphaValue = 1.0;
            [window.animator setFrame:proposedEndFrame display:YES];
        } completionHandler:nil];
    }];
}



@end
