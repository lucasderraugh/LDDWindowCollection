//
//  LDDWindowControllerCollection.m
//  LDDWindowCollection
//
//  Created by Lucas Derraugh on 9/2/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import "LDDWindowControllerCollection.h"

@interface LDDWindowControllerCollection ()

@property (nonatomic, strong, readwrite) NSMutableArray *windowControllers;

@end

@implementation LDDWindowControllerCollection

- (id)init {
    if (self = [super init]) {
        _windowControllers = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeWindowController:)
                                                     name:NSWindowWillCloseNotification
                                                   object:nil];
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
        [[window animator] setFrame:proposedEndFrame display:YES];
    };
    [self presentWindowController:controller withAnimationBlock:block];
}

// Designated presenter
- (void)presentWindowController:(NSWindowController *)controller withAnimationBlock:(LDDAnimationBlock)block {
    if (![self addWindowController:controller]) return;
    
    if (block) {
        block(controller.window, controller.window.frame);
    } else {
        [controller showWindow:nil];
    }
}

- (BOOL)containsWindow:(NSWindow *)window {
    for (NSWindowController *wC in _windowControllers) {
        if ([wC.window isEqual:window]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsController:(NSWindowController *)controller {
    return [_windowControllers containsObject:controller];
}

#pragma mark - Private

- (BOOL)addWindowController:(NSWindowController *)controller {
    if ([_windowControllers containsObject:controller]) {
        return NO;
    }
    [controller.window setReleasedWhenClosed:NO];
    [_windowControllers addObject:controller];
    return YES;
}

// Strickly called upon notification, should not be invoked otherwise!
- (void)removeWindowController:(NSNotification *)notification {
    __autoreleasing NSWindowController *controllerToRemove = nil;
    for (NSWindowController *controller in _windowControllers) {
        if ([controller.window isEqual:[notification object]]) {
            controllerToRemove = controller;
            break;
        }
    }
    [_windowControllers removeObject:controllerToRemove];
}

NSRect startFrameForBottomAnimationUsingEndFrame(NSRect frame) {
    return NSMakeRect(frame.origin.x, 0-frame.size.height, frame.size.width, frame.size.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
