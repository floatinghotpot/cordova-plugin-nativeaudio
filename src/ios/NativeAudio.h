//
// 
//  NativeAudio.h
//  NativeAudio
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NativeAudioAsset.h"

@interface NativeAudio : CDVPlugin {
    NSMutableDictionary* audioMapping; 
    NSMutableDictionary* completeCallbacks;
}

#define OPT_FADE_MUSIC  @"fadeMusic"

@property (assign) BOOL fadeMusic;

- (void) setOptions:(CDVInvokedUrlCommand *)command;
- (void) preloadSimple:(CDVInvokedUrlCommand *)command;
- (void) preloadComplex:(CDVInvokedUrlCommand *)command;
- (void) play:(CDVInvokedUrlCommand *)command;
- (void) stop:(CDVInvokedUrlCommand *)command;
- (void) loop:(CDVInvokedUrlCommand *)command;
- (void) unload:(CDVInvokedUrlCommand *)command;
- (void) setVolumeForComplexAsset:(CDVInvokedUrlCommand *)command;
- (void) addCompleteListener:(CDVInvokedUrlCommand *)command;

- (void) parseOptions:(NSDictionary*) options;

@end