//
//  ManifestsView.h
//  MunkiAdmin
//
//  Created by Juutilainen Hannes on 13.6.2012.
//

#import <Cocoa/Cocoa.h>
#import "GradientBackgroundView.h"

@interface ManifestsView : NSViewController <NSMenuDelegate> {
    NSSplitView *tripleSplitView;
    NSView *leftPlaceHolder;
    NSView *middlePlaceHolder;
    GradientBackgroundView *rightPlaceHolder;
    NSTableView *manifestsTableView;
    NSArrayController *manifestsArrayController;
    NSTreeController *directoriesTreeController;
    NSOutlineView *directoriesOutlineView;
    NSMenu *manifestsTableViewMenu;
}

@property (assign) IBOutlet NSSplitView *tripleSplitView;
@property (assign) IBOutlet NSView *leftPlaceHolder;
@property (assign) IBOutlet NSView *middlePlaceHolder;
@property (assign) IBOutlet GradientBackgroundView *rightPlaceHolder;
@property (assign) IBOutlet NSTableView *manifestsTableView;
@property (assign) IBOutlet NSArrayController *manifestsArrayController;
@property (assign) IBOutlet NSTreeController *directoriesTreeController;
@property (assign) IBOutlet NSOutlineView *directoriesOutlineView;
@property (assign) IBOutlet NSMenu *manifestsTableViewMenu;

@end
