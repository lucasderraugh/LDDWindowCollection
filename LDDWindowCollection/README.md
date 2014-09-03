LDDWindowCollection
===================
Allows you to add a collection of NSWindowControllers and manages the memory for when a window is closed. Some examples of when you might use this are with mail applications where you can compose multiple messages in seperate windows. The behavior is similar to that of a document-based app, without the document.

Usage
=====
1. Simply create a new NSWindowController subclass with a corresponding xib file and uncheck the "Visible at launch" option for the window.
2. Add the LDDWindowCollection.h/.m files to your project.

There are different presentation options, but examples are shown in the main window and in the menu bar (File>New).

```
// Defined in AppDelegate or controller for windows
@property LDDWindowCollection *windowCollection;

// In a method that creates a new window
WindowController *wc = [[WindowController alloc] init];
[self.windowCollection presentWindowController:wc animatedFromBottom:YES];


// Example of custom animation for presenting window
WindowController *wc = [[WindowController alloc] init];
[self.windowControllerCollection presentWindowController:wc withAnimationBlock:^(NSWindow *window, NSRect proposedEndFrame) {
    [window setAlphaValue:0.0];
    [window setFrame:NSOffsetRect(proposedEndFrame, 0, -20) display:YES];
    [window makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[window animator] setAlphaValue:1.0];
    [[window animator] setFrame:proposedEndFrame display:YES];
    [NSAnimationContext endGrouping];
}];
```
