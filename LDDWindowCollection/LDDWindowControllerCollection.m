//
//  LDDWindowControllerCollection.m
//  LDDWindowCollection
//
//  Created by Lucas Derraugh on 9/2/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import "LDDWindowControllerCollection.h"

@interface LDDWindowControllerCollection ()

@property (nonatomic, copy) NSMutableArray *windowControllers;

@end

@implementation LDDWindowControllerCollection

- (id)init {
    if (self = [super init]) {
        _windowControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)presentWindowController:(NSWindowController *)controller {
    [self presentWindowController:controller withAnimationBlock:nil];
}

- (void)presentWindowController:(NSWindowController *)controller animatedFromBottom:(BOOL)animated {
    LDDAnimationBlock block = !animated ? nil : ^(NSWindow *window, NSRect proposedEndFrame) {
        NSRect startFrame = startFrameForBottomAnimationUsingEndFrame(proposedEndFrame);
        [window setFrame:startFrame display:YES];
        [window makeKeyAndOrderFront:nil];
        [window.animator setFrame:proposedEndFrame display:YES];
    };
    [self presentWindowController:controller withAnimationBlock:block];
}

// Designated presenter
- (void)presentWindowController:(NSWindowController *)controller withAnimationBlock:(LDDAnimationBlock)block {
    if ([self containsController:controller]) return;
	
	[self addWindowController:controller];
	
    if (block) {
        block(controller.window, controller.window.frame);
    } else {
        [controller showWindow:nil];
    }
}

- (BOOL)containsWindow:(NSWindow *)window {
	return window.windowController ? [_windowControllers containsObject:window.windowController] : NO;
}

- (BOOL)containsController:(NSWindowController *)controller {
    return [_windowControllers containsObject:controller];
}

#pragma mark - Private

- (void)addWindowController:(NSWindowController *)controller {
    controller.window.releasedWhenClosed = NO;
	[NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(removeWindowController:)
                                               name:NSWindowWillCloseNotification
                                             object:controller.window];
    [_windowControllers addObject:controller];
}

NSRect startFrameForBottomAnimationUsingEndFrame(NSRect frame) {
	frame.origin.y = -frame.size.height;
	return frame;
}

#pragma mark - Notifications

// Strickly called upon notification, should not be invoked otherwise!
- (void)removeWindowController:(NSNotification *)notification {
	NSWindow *window = (NSWindow *)notification.object;
	
	[NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowWillCloseNotification object:window];
	[_windowControllers removeObject:window.windowController];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
