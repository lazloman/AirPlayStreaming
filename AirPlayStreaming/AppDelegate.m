//
//  AppDelegate.m
//  AirPlay
//
//  Created by Lorenzo Thurman on 9/13/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreAudio/CoreAudio.h>
#import "SSAudioSource.h"
#import "AppDelegate+AirPlayUtilities.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Initialization Methods

- (void)awakeFromNib{
        
        targetSources = [NSMutableArray new];
        
        [noDevices setHidden:YES];
        
        [self enumerateAirPlaySources];
}


#pragma mark -
#pragma mark NSTableViewDelegate Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
        
        return airplaySources.count;
}

- (NSView *)tableView:(NSTableView *)tableView
                viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
        
        SSAudioSource * source = airplaySources[row];
        
        NSButton * button = [[NSButton alloc] init];
        [button setButtonType:NSSwitchButton];
        [button setTitle:source.name];
        [button setAction:@selector(addToAirPlaySources:)];
        [button setTag:row];
        
        return button;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
 
        return 22.0;
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)addToAirPlaySources:(NSButton*)sender{
        
        NSUInteger tag = [sender tag];
        
        if([sender state] == NSOnState){
                [targetSources addObject:airplaySources[tag]];
        }
        else{
                NSUInteger target = [targetSources indexOfObject:airplaySources[tag]];
                [targetSources removeObjectAtIndex:target];
        }
}

- (IBAction)playToAirPlayDevice:(id)sender{
        
        AudioDeviceID * sources = malloc(sizeof(AudioDeviceID) * airplaySources.count);
        [self getTargetSources:sources];
        
        OSStatus err = 0;
        UInt32 size = sizeof(UInt32);
                
        AudioObjectPropertyAddress addr;
        addr.mSelector = kAudioDevicePropertyDataSource;
        addr.mScope = kAudioDevicePropertyScopeOutput;
        addr.mElement = kAudioObjectPropertyElementMaster;
        
        
        // At some point in the past, you could stream to multiple AirPlay destinations
        // by passing an array of AirPlay sourceID's to AudioObjectSetPropertyData.
        // Can't do that anymore, so this will only stream to the AirPlay device
        // in [0] of the sources array. If I figure out how to stream multiple
        // destinations, I'll update the project.
        
        // Set the 'AirPlay' device to point to one (or more) of its sources...
        err = AudioObjectSetPropertyData(airplayDeviceID, &addr, 0, nil, size, sources);
        
        // ...now set the system output to point at the 'AirPlay' device
        AudioObjectPropertyAddress audioDevicesAddress = {
                kAudioHardwarePropertyDefaultOutputDevice,
                kAudioObjectPropertyScopeGlobal,
                kAudioObjectPropertyElementMaster
        };
        
        err = AudioObjectSetPropertyData(kAudioObjectSystemObject, &audioDevicesAddress, 0, nil, size, &airplayDeviceID);
        
        free(sources);
}
@end
