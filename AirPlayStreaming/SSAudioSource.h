//
//  SSAudioSource.h
//  AirPlay
//
//  Created by Lorenzo Thurman on 9/18/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SSAudioDevice;

@interface SSAudioSource : NSObject


@property(nonatomic, readonly) AudioDeviceID sourceID;
@property(nonatomic, readonly) AudioDeviceID deviceID;
@property(nonatomic, readonly) NSString *name;

- (id) initWithID:(UInt32)sourceID device:(AudioDeviceID)deviceID;
@end
