//
//  PGAudio.m
//  PGAudio
//
//  Created by Andrew Trice on 1/19/12.
//
// THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
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

#import "LowLatencyAudio.h"

@implementation LowLatencyAudio

NSString* ERROR_NOT_FOUND = @"file not found";
NSString* WARN_EXISTING_REFERENCE = @"a reference to the audio ID already exists";
NSString* ERROR_MISSING_REFERENCE = @"a reference to the audio ID does not exist";
NSString* CONTENT_LOAD_REQUESTED = @"content has been requested";
NSString* PLAY_REQUESTED = @"PLAY REQUESTED";
NSString* STOP_REQUESTED = @"STOP REQUESTED";
NSString* UNLOAD_REQUESTED = @"UNLOAD REQUESTED";
NSString* RESTRICTED = @"ACTION RESTRICTED FOR FX AUDIO";

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (LowLatencyAudio*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
    	// do some init work here.
    }
    return self;
}

- (void) preloadFX:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0]; 
    NSString *assetPath = [arguments objectAtIndex:1]; 
    
    NSLog( @"preloadFX - %@", assetPath );

    if(audioMapping == nil) {
        audioMapping = [NSMutableDictionary dictionary];
    }
    
    NSNumber* existingReference = [audioMapping objectForKey: audioID];
    if (existingReference == nil) {
        NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        NSString* path = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
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

- (void) preloadAudio:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0]; 
    NSString *assetPath = [arguments objectAtIndex:1]; 

    NSLog( @"preloadAudio - %@", assetPath );
    
    NSNumber *voices = nil;
    if ( [arguments count] > 2 ) {
        voices = [arguments objectAtIndex:2];
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
    if (existingReference == nil) {
        NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        NSString* path = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            LowLatencyAudioAsset* asset = [[LowLatencyAudioAsset alloc] initWithPath:path withVoices:voices];
            [audioMapping setObject:asset  forKey: audioID];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED];
        } else {
            NSLog( @"audio file not found" );
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_NOT_FOUND];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WARN_EXISTING_REFERENCE];        
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void) play:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0]; 
    
    //NSLog( @"play - %@", audioID );

    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]]) {
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset play];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
            NSNumber *_asset = (NSNumber*) asset;
            AudioServicesPlaySystemSound([_asset intValue]);
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: PLAY_REQUESTED];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
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
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]]) {
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset stop];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED];        
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
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
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]]) {
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset loop];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED];        
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
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
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]]) {
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset unload];
        } else if ( [asset isKindOfClass:[NSNumber class]] ) {
            NSNumber *_asset = (NSNumber*) asset;
            AudioServicesDisposeSystemSoundID([_asset intValue]);
        }
        
        [audioMapping removeObjectForKey: audioID];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: UNLOAD_REQUESTED];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end
