//
//  AppDelegate+AirPlayUtilities.h
//  AirPlay
//
//  Created by Lorenzo Thurman on 11/7/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AirPlayUtilities)
- (OSStatus) getProperty:(UInt32)selector
              forChannel:(UInt32)scope
                datasize:(UInt32)size
                     ptr:(void *)pointer
                deviceID:(AudioDeviceID)deviceID;

- (void)copyProperty:(UInt32)selector
          forChannel:(UInt32)scope
            datasize:(UInt32 *)size
                 ptr:(void **)pointer;

- (void)getAirPlaySources;
- (void)getTargetSources:(AudioDeviceID[])sources;
- (void)enumerateAirPlaySources;
@end
