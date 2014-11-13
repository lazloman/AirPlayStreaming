//
//  AppDelegate.h
//  AirPlay
//
//  Created by Lorenzo Thurman on 9/13/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>

@class SSAudioSource;

@interface AppDelegate : NSObject <NSApplicationDelegate>{
 
        AudioObjectID * devices;
        AudioDeviceID airplayDeviceID;
        NSMutableArray * targetSources;
        NSMutableArray * airplaySources;
        IBOutlet NSTableView * sourcesTable;
        IBOutlet NSButton * playButton;
        IBOutlet NSTextField * noDevices;
        IBOutlet NSScrollView * scrollView;        
}

@property (assign) IBOutlet NSWindow *window;

@end
