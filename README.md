#Cordova Native Audio Plugin
=======================

Cordova plugin for native audio playback for the usage in HTML5 games & audio applications.
Community-driven fork of the Low Latency Audio Plugin.

## Index

1. [Description](#description)
2. [Roadmap](#roadmap)
3. [History](#history)
4. [Installation](#installation)
5. [Usage](#usage)
6. [API](#api)
7. [Demo](#demo)

##Description

Cordova plugin for concurrent (multi-channel), polyphonic (multi-voice) and latency-reduced (caching) audio playback. Designed for usage in HTML5 games and hybrid audio applications.


##Roadmap

Following the Cordova core philosophy, this is a "shim" for a mobile web audio solution which is as fast and feature-rich as the native APIs.On mobile, neither the Web Audio API or HTML5 Audio offer fast cross-platform solutions with support for polyphony and concurrency.

Should be replaced by a W3C solution as soon as it offers comparable performance across devices.


##History

Community-driven, clean fork of the Low Latency Audio Plugin for Cordova & PhoneGap, initially published by Andrew Trice and maintained by R. Xie.


##Installation

Via Cordova CLI:
```bash
cordova plugin add https://github.com/sidneys/cordova-plugin-nativeaudio.git
```

##Usage

1. Wait for device ready.
1. Preload an audio asset, either optimized for short clips (up to 5 seconds) or ambient background audio (multichannel)
2. Play the audio asset.
3. Unload the audio asset.


##API
```javascript
preloadSimple: function ( id, assetPath, success, fail)
```
Loads an audio file into memory. Optimized for short clips / single shots (up to five seconds).
Cannot be stopped / looped.

Uses lower-level native APIs with small footprint (iOS: AudioToolbox/AudioServices).
Fully concurrent and multichannel.

* params
 * ID - string unique ID for the audio file
 * assetPath - the relative path or absolute URL (inluding http://) to the audio asset.
 * success - success callback function
 * fail - error/fail callback function


```javascript
preloadComplex: function ( id, assetPath, volume, voices, success, fail)
```

Loads an audio file into memory. Optimized for background music / ambient sound.
Can be stopped / looped.

Uses higher-level native APIs with a larger footprint. (iOS: AVAudioPlayer).

###Voices
By default, there is 1 voice, that is: one instance that will be stopped & restarted on play().
If there are multiple voices (number greater than 0), it will cycle through voices to play overlapping audio.

###Volume
The default volume is 1.0, a lower default can be set by using a numerical value from 0.1 to 1.0.

* params
 * ID - string unique ID for the audio file
 * assetPath - the relative path to the audio asset within the www directory
 * volume - the volume of the preloaded sound (0.1 to 1.0)
 * voices - the number of multichannel voices available
 * success - success callback function
 * fail - error/fail callback function

```javascript
play: function (id, success, fail)
```

Plays an audio asset.

* params:
 * ID - string unique ID for the audio file
 * success - success callback function
 * fail - error/fail callback function

```javascript
loop: function (id, success, fail)
```
Loops an audio asset infinitely - this only works for assets loaded via preloadComplex.

* params
 * ID - string unique ID for the audio file
 * success - success callback function
 * fail - error/fail callback function

```javascript
stop: function (id, success, fail)
```

Stops an audio file. Only works for assets loaded via preloadComplex.

* params:
 * ID - string unique ID for the audio file
 * success - success callback function
 * fail - error/fail callback function

```javascript
unload: function (id, success, fail)
```

Unloads an audio file from memory.


* params:
 * ID - string unique ID for the audio file
 * success - success callback function
 * fail - error/fail callback function
	
##Example

In this example, the resources reside in a relative path under the Cordova root folder "www/".

```javascript
if( window.plugins && window.plugins.nativeaudio ) {
	
	// Preload audio resources
	window.plugins.nativeaudio.preloadComplex( 'music', 'audio/music.mp3', 1, 1, function(msg){
	}, function(msg){
		console.log( 'error: ' + msg );
	});
	
	window.plugins.nativeaudio.preloadSimple( 'click', 'audio/click.mp3', function(msg){
	}, function(msg){
		console.log( 'error: ' + msg );
	});


	// Play
	window.plugins.nativeaudio.play( 'click' );
	window.plugins.nativeaudio.loop( 'music' );


	// Stop multichannel clip after 60 seconds
	window.setTimeout( function(){

		window.plugins.nativeaudio.stop( 'music' );
			
		window.plugins.nativeaudio.unload( 'music' );
		window.plugins.nativeaudio.unload( 'click' );

	}, 1000 * 60 );
}
```

## Demo
The demonstration projects in the examples directory can get you started with the plugin.

```bash
cordova create drumpad com.example.nativeaudio drumpad
cd drumpad
cordova platform add ios
cordova plugin add https://github.com/sidneys/cordova-plugin-nativeaudio.git
rm -R www/*
cp -r plugins/org.apache.cordova.nativeaudio/examples/drumpad www
cordova build ios
cordova emulate ios
```
