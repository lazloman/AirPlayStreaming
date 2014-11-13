//
//  AppDelegate+AirPlayUtilities.m
//  AirPlay
//
//  Created by Lorenzo Thurman on 11/7/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

// Utilties for getting AirPlay destination info.

#import "AppDelegate+AirPlayUtilities.h"
#import "SSAudioSource.h"

@implementation AppDelegate (AirPlayUtilities)

#pragma mark -
#pragma mark Core Adudio Property Methods

- (OSStatus) getProperty:(UInt32)selector
              forChannel:(UInt32)scope
                datasize:(UInt32)size
                     ptr:(void *)pointer
                deviceID:(AudioDeviceID)deviceID{
        
        AudioObjectPropertyAddress addr;
        addr.mSelector = selector;
        addr.mScope = scope;
        addr.mElement = kAudioObjectPropertyElementMaster;
        
        return AudioObjectGetPropertyData(deviceID, &addr, 0, NULL, &size, pointer);
}

- (void)copyProperty:(UInt32)selector
          forChannel:(UInt32)scope
            datasize:(UInt32 *)size
                 ptr:(void **)pointer {
        
        AudioObjectPropertyAddress addr;
        addr.mSelector = selector;
        addr.mScope = scope;
        addr.mElement = kAudioObjectPropertyElementMaster;
        
        AudioObjectGetPropertyDataSize(airplayDeviceID, &addr, 0, NULL, size);
        
        *pointer = malloc(*size);
        
        AudioObjectGetPropertyData(airplayDeviceID, &addr, 0, NULL, size, *pointer);
}

#pragma mark -
#pragma mark Source related Methods

- (void)getAirPlaySources{
        
        airplaySources = [NSMutableArray new];
        
        UInt32 *sourceIds = NULL;
        UInt32 dataSize = 0;
        
        [self copyProperty:kAudioDevicePropertyDataSources
                forChannel:kAudioDevicePropertyScopeOutput
                  datasize:&dataSize
                       ptr:(void **)&sourceIds];
        
        int numberOfSources = dataSize / sizeof(UInt32);
        
        for (int i=0; i<numberOfSources; i++) {
                SSAudioSource *source = [[SSAudioSource alloc]
                                         initWithID:sourceIds[i]
                                         device:airplayDeviceID];
                [airplaySources addObject:source];
        }
        
        free(sourceIds);
}

- (void)getTargetSources:(AudioDeviceID[])sources{
        
        NSUInteger count = targetSources.count;
        
        for(NSUInteger index = 0; index < count; index++){
                sources[index] = ((SSAudioSource*)targetSources[index]).sourceID;
        }
}

- (void)enumerateAirPlaySources{
        
        AudioObjectPropertyAddress addr;
        addr.mSelector = kAudioHardwarePropertyDevices;
        addr.mScope = kAudioObjectPropertyScopeWildcard;
        addr.mElement = kAudioObjectPropertyElementWildcard;
        
        UInt32 propsize;
        AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &addr, 0, NULL, &propsize);
        
        int numDevices = propsize / sizeof(AudioDeviceID);
        
        AudioDeviceID *devids = malloc(propsize);
        AudioObjectGetPropertyData(kAudioObjectSystemObject, &addr, 0, NULL, &propsize, devids);
        
        // Get the lone AirPlay device...
        for (int i = 0; i < numDevices; i++) {
                
                UInt32 transportType = 0;
                [self getProperty:kAudioDevicePropertyTransportType
                       forChannel:kAudioObjectPropertyScopeGlobal
                         datasize:sizeof(transportType)
                              ptr:&transportType
                                deviceID:devids[i]];
                
                if(transportType == kAudioDeviceTransportTypeAirPlay){
                        // ...list its sources
                        airplayDeviceID = devids[i];
                        [self getAirPlaySources];
                        
                        break;
                }
        }
        
        free(devids);
        
        if(airplaySources.count == 0){
                
                [scrollView setHidden:YES];
                [noDevices setHidden:NO];
                [playButton setEnabled:NO];
        }
}
@end
