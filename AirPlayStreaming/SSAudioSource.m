//
//  SSAudioSource.m
//  AirPlay
//
//  Created by Lorenzo Thurman on 9/18/14.
//  Copyright (c) 2014 Lorenzo P. Thurman. All rights reserved.
//

// Simple calss to represent an AirPlay destination
#import <CoreAudio/CoreAudio.h>
#import "SSAudioSource.h"

@implementation SSAudioSource

#pragma mark -
#pragma mark Initialization Methods


- (id)initWithID:(AudioDeviceID)sourceID device:(AudioDeviceID)deviceID {
        
	self = [super init];
	
	if (self) {
		_sourceID = sourceID;
				
		AudioObjectPropertyAddress nameAddr;
		nameAddr.mSelector = kAudioDevicePropertyDataSourceNameForIDCFString;
		nameAddr.mScope = kAudioObjectPropertyScopeOutput;
		nameAddr.mElement = kAudioObjectPropertyElementMaster;
		
		CFStringRef value = NULL;
		
		AudioValueTranslation audioValueTranslation;
		audioValueTranslation.mInputDataSize = sizeof(UInt32);
		audioValueTranslation.mOutputData = (void *) &value;
		audioValueTranslation.mOutputDataSize = sizeof(CFStringRef);
		audioValueTranslation.mInputData = (void *) &_sourceID;
		
		UInt32 propsize = sizeof(AudioValueTranslation);
		
		AudioObjectGetPropertyData(deviceID, &nameAddr, 0, NULL, &propsize, &audioValueTranslation);
		
		_name = (__bridge NSString *)value;
	}
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SSAudioSource: %@, SourceID: %d", _name, _sourceID];
}
@end