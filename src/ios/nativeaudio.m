//
//  nativeaudio.m
//  NativeAudio
//
//  Created by Sidney Bofah on 2014-06-26.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "nativeaudio.h"
#import <AVFoundation/AVAudioSession.h>

@implementation NativeAudio

NSString* ERROR_NOT_FOUND = @"(NATIVE AUDIO) File not found.";
NSString* WARN_EXISTING_REFERENCE = @"(NATIVE AUDIO) Audio asset ID reference already exists.";
NSString* ERROR_MISSING_REFERENCE = @"(NATIVE AUDIO) Audio asset ID reference does not exist";
NSString* CONTENT_LOAD_REQUESTED = @"(NATIVE AUDIO) Asset requested.";
NSString* PLAY_REQUESTED = @"(NATIVE AUDIO) Play requested.";
NSString* STOP_REQUESTED = @"(NATIVE AUDIO) Stop requested.";
NSString* UNLOAD_REQUESTED = @"(NATIVE AUDIO) Asset unload requested.";
NSString* RESTRICTED = @"(NATIVE AUDIO) Action restrictd to multichannel/complex asset references.";

- (void)pluginInitialize
{
    // do some init work here.

    // set up Audio so that user can play own music
    AudioSessionInitialize(NULL, NULL, nil , nil);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    
    [session setActive: YES error: nil];
}

- (void) preloadSimple:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    NSString *assetPath = [arguments objectAtIndex:1];
    
    NSLog( @"preloadSimple - %@", assetPath );
    
    if(audioMapping == nil) {
        audioMapping = [NSMutableDictionary dictionary];
    }
    
    NSNumber* existingReference = [audioMapping objectForKey: audioID];
    if (existingReference == nil) {
        NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        NSString* path = [NSString stringWithFormat:@"%@", assetPath];
        NSString* pathFromWWW = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
        
        
        NSLog(@"basePath: %@", basePath);
        NSLog(@"path: %@", path);
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            CFURLRef        soundFileURLRef = (CFURLRef) CFBridgingRetain(pathURL);
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID(soundFileURLRef, & soundID);
            [audioMapping setObject:[NSNumber numberWithInt:soundID]  forKey: audioID];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath : pathFromWWW]) {
            NSURL *pathURL = [NSURL fileURLWithPath : pathFromWWW];
            CFURLRef        soundFileURLRef = (CFURLRef) CFBridgingRetain(pathURL);
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID(soundFileURLRef, & soundID);
            [audioMapping setObject:[NSNumber numberWithInt:soundID]  forKey: audioID];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_NOT_FOUND];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WARN_EXISTING_REFERENCE];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void) preloadComplex:(CDVInvokedUrlCommand *)command
{
        NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    NSString *assetPath = [arguments objectAtIndex:1];
    
    NSLog( @"preloadComplex - %@", assetPath );

    NSNumber *volume = nil;
    if ( [arguments count] > 2 ) {
        volume = [arguments objectAtIndex:2];
        if([volume isEqual:nil]) {
            volume = [NSNumber numberWithFloat:1.0f];
        }
    } else {
        volume = [NSNumber numberWithFloat:1.0f];
    }

    NSLog( @"volume - %@", volume.stringValue );

    NSNumber *voices = nil;
    if ( [arguments count] > 3 ) {
        voices = [arguments objectAtIndex:3];
        if([voices isEqual:nil]) {
            voices = [NSNumber numberWithInt:1];
        }
    } else {
        voices = [NSNumber numberWithInt:1];
    }
    
    if(audioMapping == nil) {
        audioMapping = [NSMutableDictionary dictionary];
    }
    
    NSNumber* existingReference = [audioMapping objectForKey: audioID];

    [self.commandDelegate runInBackground:^{
        if (existingReference == nil) {
            NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
            NSString* path = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
                NativeAudioAsset* asset = [[NativeAudioAsset alloc] initWithPath:path withVoices:voices withVolume:volume];
                [audioMapping setObject:asset  forKey: audioID];

                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED] callbackId:callbackId];
            } else {
                NSLog( @"audio file not found" );
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_NOT_FOUND] callbackId:callbackId];
            }
        } else {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WARN_EXISTING_REFERENCE] callbackId:callbackId];
        }

    }];
}

- (void) play:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];

    [self.commandDelegate runInBackground:^{
        if ( audioMapping ) {
            NSObject* asset = [audioMapping objectForKey: audioID];
            if ([asset isKindOfClass:[NativeAudioAsset class]]) {
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                [_asset play];
            } else if ( [asset isKindOfClass:[NSNumber class]] ) {
                NSNumber *_asset = (NSNumber*) asset;
                AudioServicesPlaySystemSound([_asset intValue]);
            }
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: PLAY_REQUESTED] callbackId:callbackId];
        } else {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE] callbackId:callbackId];
        }
        }];
}

- (void) stop:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    //NSLog( @"stop - %@", audioID );
    
    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[NativeAudioAsset class]]) {
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset stop];

            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED] callbackId:callbackId];

        } else if ( [asset isKindOfClass:[NSNumber class]] ) {

         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED] callbackId:callbackId];
        }
    } else {

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE] callbackId:callbackId];
    }

}

- (void) loop:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    NSLog( @"loop - %@", audioID );
    
    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[NativeAudioAsset class]]) {
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset loop];
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED] callbackId:callbackId];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
         [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED] callbackId:callbackId];
        }
    } else {

    };
}

- (void) unload:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    NSLog( @"unload - %@", audioID );
    
    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[NativeAudioAsset class]]) {
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset unload];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
            NSNumber *_asset = (NSNumber*) asset;
            AudioServicesDisposeSystemSoundID([_asset intValue]);
        }
        
        [audioMapping removeObjectForKey: audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: UNLOAD_REQUESTED] callbackId:callbackId];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE] callbackId:callbackId];
    }

}

@end
