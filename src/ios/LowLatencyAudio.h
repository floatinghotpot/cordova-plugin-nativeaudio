//
//  LowLatencyAudio.h
//  LowLatencyAudio
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

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LowLatencyAudioAsset.h"

@interface LowLatencyAudio : CDVPlugin {
    NSMutableDictionary* audioMapping; 
}

//Public Instance Methods (visible in Cordova API)
- (void) preloadFX:(CDVInvokedUrlCommand *)command;
- (void) preloadAudio:(CDVInvokedUrlCommand *)command;
- (void) play:(CDVInvokedUrlCommand *)command;
- (void) stop:(CDVInvokedUrlCommand *)command;
- (void) loop:(CDVInvokedUrlCommand *)command;
- (void) unload:(CDVInvokedUrlCommand *)command;


//Instance Methods  


@end
