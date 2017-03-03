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
import android.media.MediaPlayer.OnPreparedListener;

public class NativeAudioAssetComplex implements OnPreparedListener, OnCompletionListener {

	private static final int INVALID = 0;
	private static final int PREPARED = 1;
	private static final int PENDING_PLAY = 2;
	private static final int PLAYING = 3;
	private static final int PENDING_LOOP = 4;
	private static final int LOOPING = 5;

	private MediaPlayer mp;
	private int state;
	private Timer HACK_loopTimer;
	private TimerTask HACK_loopTask;
	private long mHackLoopingPreview;
	Callable<Void> completeCallback;

	public NativeAudioAssetComplex(AssetFileDescriptor afd, float volume, int preview) throws IOException {
		mHackLoopingPreview = (long) preview;
		// prevent the native loop to jump in
		if (mHackLoopingPreview < 3)
			mHackLoopingPreview = 3;
		state = INVALID;
		mp = new MediaPlayer();
		mp.setOnCompletionListener(this);
		mp.setOnPreparedListener(this);
		mp.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
		mp.setAudioStreamType(AudioManager.STREAM_MUSIC);
		mp.setVolume(volume, volume);
		mp.prepare();
	}

	public void play(Callable<Void> completeCb) throws IOException {
		completeCallback = completeCb;
		invokePlay(false);
	}

	private void invokePlay(Boolean loop) {
		Boolean playing = mp.isPlaying();
		if (!playing && state == PREPARED) {
			state = (loop ? PENDING_LOOP : PENDING_PLAY);
			onPrepared(mp);
		} else if (!playing) {
			state = (loop ? PENDING_LOOP : PENDING_PLAY);
			mp.setLooping(loop);
			mp.start();
		}
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
			if (mp.isPlaying()) {
				if (state == LOOPING)
					HACK_loopTimer.cancel();
				state = INVALID;
				mp.pause();
				mp.setLooping(false);
				mp.seekTo(0);
			}
		} catch (IllegalStateException e) {
			// I don't know why this gets thrown; catch here to save app
		}
	}

	public void setVolume(float volume) {
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

	public void onPrepared(MediaPlayer mPlayer) {
		if (state == PENDING_PLAY) {
			mp.seekTo(0);
			mp.start();
			state = PLAYING;
		} else if (state == PENDING_LOOP) {
			HACK_loopTimer = new Timer();
			HACK_loopTask = new TimerTask() {
				@Override
				public void run() {
					if (mp.isPlaying())
						mp.seekTo(0);
				}
			};
			long waitingTime = (long) mp.getDuration() - mHackLoopingPreview;
			HACK_loopTimer.schedule(HACK_loopTask, waitingTime, waitingTime);
			mp.seekTo(0);
			mp.start();
			state = LOOPING;
		} else {
			state = PREPARED;
			mp.seekTo(0);
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
		}
	}
}
