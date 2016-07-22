//
//  LDDWindowControllerCollection.h
//  LDDWindowCollection
//
//  Created by Lucas Derraugh on 9/2/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LDDAnimationBlock)(NSWindow *window, NSRect proposedEndFrame);

/**
 *  A class to hold a collection of NSWindowControllers in a non document-based application.
 *  
 *  This class takes care of releasing both the window and window controller in an ARC environment.
 */
@interface LDDWindowControllerCollection : NSObject

/**
 *  Presents a given window controller (calls NSWindowController's -showWindow:) and adds it to the collection.
 *	Window is presented without animation
 *
 *  @param controller The window controller to be added.
 */
- (void)presentWindowController:(NSWindowController *)controller;

/**
 *  Presents a given window controller (calls NSWindowController's -showWindow:) and adds it to the collection.
 *  Includes option to animate window in from bottom of the screen.
 *
 *  @param controller The window controller to be added.
 *  @param animated   If @c YES then window will animate in from bottom, @c NO shows window immediately.
 */
- (void)presentWindowController:(NSWindowController *)controller animatedFromBottom:(BOOL)animated;

/**
 *  Presents a given window controller (calls -showWindow:) and adds it to the collection.
 *
 *  @param controller The window controller to be added.
 *
 *  Make sure that the window controller's window is not visible at launch.
 */
- (void)presentWindowController:(NSWindowController *)controller withAnimationBlock:(LDDAnimationBlock)block;

/**
 *  Returns a bool that indicates whether a given window exists in the collection.
 *
 *  @param window A window.
 *  @return @c YES if a given window exists in the collection, otherwise @c NO.
 */
- (BOOL)containsWindow:(NSWindow *)window;

/**
 *  Returns a bool that indicates whether a given window controller exists in the collection.
 *
 *  @param controller A controller.
 *  @return @c YES if a given window controller exists in the collection, otherwise @c NO.
 */
- (BOOL)containsController:(NSWindowController *)controller;

@end
