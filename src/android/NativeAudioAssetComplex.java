//
//
//  NativeAudioAssetComplex.java
//
//  Created by Sidney Bofah on 2014-06-26.
//

package com.rjfun.cordova.plugin.nativeaudio;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Callable;

import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.util.Log;

public class NativeAudioAssetComplex implements OnCompletionListener {

	private static final int INVALID = 0;
	private static final int PREPARED = 1;
	private static final int PENDING_PLAY = 2;
	private static final int PLAYING = 3;
	private static final int PENDING_LOOP = 4;
	private static final int LOOPING = 5;

	private MediaPlayer mp;
	private MediaPlayer nmp;
	private int state;
	private Timer GapTimer;
	private TimerTask GapTimerTask;
	private int gapLoopTime;
	private float volume;
	// private AssetFileDescriptor afd;
	private String fullPath;
	Callable<Void> completeCallback;

	public NativeAudioAssetComplex(String fullPath, float volume, int preview) throws IOException {
		this.gapLoopTime = preview;
		this.state = INVALID;
		this.volume = volume;
		// this.afd = afd;
		this.fullPath = fullPath;
		this.mp = prepareNextMediaplayer();
	}

	private MediaPlayer prepareNextMediaplayer() throws IOException {
		MediaPlayer m = new MediaPlayer();
		m.setOnCompletionListener(this);
		// m.setOnPreparedListener(this);
		AssetFileDescriptor afd = cordova.getActivity().getApplicationContext().getResources().getAssets().openFd(this.fullPath);
		m.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
		afd.close();
		//
		if (gapLoopTime == -4)
			m.setAudioStreamType(AudioManager.STREAM_ALARM);
		else
			m.setAudioStreamType(AudioManager.STREAM_MUSIC);
		m.setVolume(volume, volume);
		m.prepare();
		return m;
	}

	public void play(Callable<Void> completeCb) throws IOException {
		completeCallback = completeCb;
		invokePlay(false);
	}

	private void invokePlay(Boolean loop) {
		// check the best status for the player
		Boolean playing = mp.isPlaying();
		if (playing) {
			mp.pause();
			mp.setLooping(loop);
			mp.seekTo(0);
			mp.start();
		} else if (!playing) {
			state = (loop ? PENDING_LOOP : PENDING_PLAY);
			mp.setLooping(loop);
			mp.start();
		}
		// invoke a play based on the status
		checkStatus();
	}

	public boolean pause() {
		try {
			if (mp.isPlaying()) {
				mp.pause();
				return true;
			}
		} catch (IllegalStateException e) {
			// I don't know why this gets thrown; catch here to save app
		}
		return false;
	}

	public void resume() {
		mp.start();
	}

	public void stop() {
		try {
			if (GapTimer != null)
				GapTimer.cancel();
			if (mp.isPlaying()) {
				state = INVALID;
				mp.pause();
				mp.seekTo(0);
			}
		} catch (IllegalStateException e) {
			// I don't know why this gets thrown; catch here to save app
		}
	}

	public void setVolume(float volume) {
		this.volume = volume;
		try {
			mp.setVolume(volume, volume);
		} catch (IllegalStateException e) {
			// I don't know why this gets thrown; catch here to save app
		}
	}

	public void loop() throws IOException {
		invokePlay(true);
	}

	public void unload() throws IOException {
		this.stop();
		mp.release();
	}

	public void checkStatus() {
		if (state == PENDING_PLAY) {
			mp.setLooping(false);
			mp.seekTo(0);
			mp.start();
			state = PLAYING;
		} else if (state == PENDING_LOOP) {
			// Self Manage the Loop
			if (gapLoopTime > 0) {
				mp.setLooping(false);
				GapTimer = new Timer();
				GapTimerTask = new TimerTask() {
					@Override
					public void run() {
						try {
							if (mp.isPlaying() && gapLoopTime > 0) {
								mp.seekTo(0);
							} else if (!mp.isPlaying()) {
								mp.start();
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				};
				long waitingTime = (long) mp.getDuration() - (long) gapLoopTime;
				GapTimer.schedule(GapTimerTask, waitingTime, waitingTime);
				Log.i(NativeAudioAssetComplex.class.getName(), "Started MediaPlayer with GapTimer enabled.");
			} else if (gapLoopTime == -1) {
				try {
					mp.setLooping(false);
					nmp = prepareNextMediaplayer();
					mp.setNextMediaPlayer(nmp);
					Log.i(NativeAudioAssetComplex.class.getName(), "Started MediaPlayer with GapLess enabled.");
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				mp.setLooping(true);
				Log.i(NativeAudioAssetComplex.class.getName(), "Started MediaPlayer with standard loop enabled.");
			}
			mp.seekTo(0);
			mp.start();
			state = LOOPING;
		}
	}

	public void onCompletion(MediaPlayer mPlayer) {
		if (state != LOOPING) {
			this.state = INVALID;
			try {
				this.stop();
				if (completeCallback != null)
					completeCallback.call();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (gapLoopTime == -1) {
			try {
				this.nmp.setVolume(volume, volume);
				MediaPlayer tmp = prepareNextMediaplayer();
				this.nmp.setNextMediaPlayer(tmp);
				this.mp = this.nmp;
				this.nmp = tmp;
				mPlayer.stop();
				mPlayer.release();
				// Log.i(NativeAudioAssetComplex.class.getName(), "Continue with GapLess Next Mediaplayer.");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
