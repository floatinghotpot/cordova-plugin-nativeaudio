/*
THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.rjfun.cordova.plugin;

import java.io.IOException;
import java.util.ArrayList;

import android.content.res.AssetFileDescriptor;

public class LowLatencyAudioAsset {

	private ArrayList<PolyphonicVoice> voices;
	private int playIndex = 0;
	
	public LowLatencyAudioAsset(AssetFileDescriptor afd, int numVoices) throws IOException
	{
		voices = new ArrayList<PolyphonicVoice>();
		
		if ( numVoices < 0 )
			numVoices = 0;
		
		for ( int x=0; x<numVoices; x++) 
		{
			PolyphonicVoice voice = new PolyphonicVoice(afd);
			voices.add( voice );
		}
	}
	
	public void play() throws IOException
	{
		PolyphonicVoice voice = voices.get(playIndex);
		voice.play();
		playIndex++;
		playIndex = playIndex % voices.size();
	}
	
	public void stop() throws IOException
	{
		for ( int x=0; x<voices.size(); x++) 
		{
			PolyphonicVoice voice = voices.get(x);
			voice.stop();
		}
	}
	
	public void loop() throws IOException
	{
		PolyphonicVoice voice = voices.get(playIndex);
		voice.loop();
		playIndex++;
		playIndex = playIndex % voices.size();
	}
	
	public void unload() throws IOException
	{
		this.stop();
		for ( int x=0; x<voices.size(); x++) 
		{
			PolyphonicVoice voice = voices.get(x);
			voice.unload();
		}
		voices.removeAll(voices);
	}
	
}
