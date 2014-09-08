//
// 
//  NativeAudioAsset.m
//  NativeAudioAsset
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import "NativeAudioAsset.h"

@implementation NativeAudioAsset

-(id) initWithPath:(NSString*) path withVoices:(NSNumber*) numVoices withVolume:(NSNumber*) volume
{
    self = [super init];
    if(self) {
        voices = [[NSMutableArray alloc] init];  
        
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        
        for (int x = 0; x < [numVoices intValue]; x++) {
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error: NULL];
            player.volume = volume.floatValue;
            [player prepareToPlay];
            [voices addObject:player];
            [player setDelegate:self];
        }
        
        playIndex = 0;
    }
    return(self);
}

- (void) play
{
    AVAudioPlayer * player = [voices objectAtIndex:playIndex];
    [player setCurrentTime:0.0];
    player.numberOfLoops = 0;
    [player play];
    playIndex += 1;
    playIndex = playIndex % [voices count];
}

- (void) stop
{
    for (int x = 0; x < [voices count]; x++) {
        AVAudioPlayer * player = [voices objectAtIndex:x];
        [player stop];
    }
}

- (void) loop
{
    [self stop];
    AVAudioPlayer * player = [voices objectAtIndex:playIndex];
    [player setCurrentTime:0.0];
    player.numberOfLoops = -1;
    [player play];
    playIndex += 1;
    playIndex = playIndex % [voices count];
}

- (void) unload 
{
    [self stop];
    for (int x = 0; x < [voices count]; x++) {
        AVAudioPlayer * player = [voices objectAtIndex:x];
        player = nil;
    }
    voices = nil;
}

- (void) setVolume:(NSNumber*) volume;
{

    for (int x = 0; x < [voices count]; x++) {
        AVAudioPlayer * player = [voices objectAtIndex:x];

        [player setVolume:volume.floatValue];
    }
}

- (void) setCallbackAndId:(CompleteCallback)cb audioId:(NSString*)aID
{
    self->audioId = aID;
    self->finished = cb;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self->finished) {
        self->finished(self->audioId);
    }
}

- (void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (self->finished) {
        self->finished(self->audioId);
    }
}

@end