#Cordova Low Latency Audio Plugin for iOS and Android
=======================

Prerequisites: A Cordova/PhoneGap 3.0+ project for iOS or Android.

## Index

1. [Description](#description)
2. [Installation](#installation)
3. [Usage](#usage)
4. [API Methods](#api-methods)
5. [Example](#example)
6. [Demo Projects](#demo-projects)
7. [Credits](#credits)
##Description

The low latency audio plugin is designed to enable low latency and polyphonic/background audio from Cordova/PhoneGap applications.

It was orginally developed by Andrew Trice, you can read more about this plugin at:
http://www.tricedesigns.com/2012/01/25/low-latency-polyphonic-audio-in-phonegap/

##Installation

To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface).

This plugin follows the Cordova 3.0 plugin spec, so it can be installed through the Cordova CLI in your existing Cordova project:
```bash
cordova plugin add https://github.com/floatinghotpot/cordova-plugin-lowlatencyaudio.git
```

##Usage

1. Preload the audio asset. You can use a relative path or absolute URL and set a lower volume.
   Note: Make sure to wait for the "deviceready" event before attepting to load assets.
2. Play the audio asset.
3. When done, unload the audio asset.

##API Methods
```javascript
preloadFX: function ( id, assetPath, success, fail)
```

The preloadFX function loads an audio file into memory.  Assets that are loaded using preloadFX are managed/played using AudioServices methods from the AudioToolbox framework.   These are very low-level audio methods and have minimal overhead.  Audio loaded using this function is played using AudioServicesPlaySystemSound.   These assets should be short, and are not intended to be looped or stopped.   They are fully concurrent and polyphonic.

* params
 * ID - string unique ID for the audio file
 * assetPath - the relative path or absolute URL (inluding http://) to the audio asset.
 * success - success callback function
 * fail - error/fail callback function

```javascript
preloadAudio: function ( id, assetPath, voices, volume, success, fail)
```

The preloadAudio function loads an audio file into memory.  Assets that are loaded using preloadAudio are managed/played using AVAudioPlayer.   These have more overhead than assets laoded via preloadFX, and can be looped/stopped.   By default, there is a single "voice" - only one instance that will be stopped & restarted when you hit play.  If there are multiple voices (number greater than 0), it will cycle through voices to play overlapping audio. The default volume is for a preloaded sound is 1.0, a lower default volume can be preset by using a numerical value from 0.1 to 1.0.

* params: ID - string unique ID for the audio file
 * assetPath - the relative path to the audio asset within the www directory
 * volume - the volume of the preloaded sound (0.1 to 1.0)
 * voices - the number of polyphonic voices available
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
Loops an audio asset infinitely - this only works for assets loaded via preloadAudio.

* params
 * ID - string unique ID for the audio file
 * success - success callback function
 * fail - error/fail callback function

```javascript
stop: function (id, success, fail)
```

Stops an audio file - this only works for assets loaded via preloadAudio.

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
For example, if the file is under "www/audio/music.mp3", then:

```javascript
var music_mp3 = 'audio/music.mp3';
var click_sound = 'audio/click.mp3'
```

The implementation goes as follows:

```javascript
if( window.plugins && window.plugins.LowLatencyAudio ) {
	var lla = window.plugins.LowLatencyAudio;
	
	// preload audio resource
	lla.preloadAudio( music_mp3, music_mp3, 1, function(msg){
	}, function(msg){
		console.log( 'error: ' + msg );
	});
	
	lla.preloadFX( click_sound, click_sound, function(msg){
	}, function(msg){
		console.log( 'error: ' + msg );
	});
	
	// now start playing
	lla.play( click_sound );
	lla.loop( music_mp3 );

	// stop after 1 min	
	window.setTimeout( function(){
		//lla.stop( click_sound );
		lla.stop( music_mp3 );
			
		lla.unload( music_mp3 );
		lla.unload( click_sound );
	}, 1000 * 60 );
}
```

## Demo Projects
The demonstration projects in the examples directory can get you started with the plugin.

Start by creating a project. Then replace index.html with the one in the example directory and copy the assets folder into the /www/ directory.

```bash
cordova create Piano com.example.piano Piano
cd Piano
cordova platform add ios
cordova plugin add https://github.com/floatinghotpot/cordova-plugin-lowlatencyaudio.git
```

## Credits

The first iteration of the Plugin was built by [Andrew Trice](https://github.com/triceam/LowLatencyAudio).
This plugin was ported to Plugman / Cordova 3 by [Raymond Xie](https://github.com/floatinghotpot), [SidneyS](https://github.com/sidneys) and other committers.