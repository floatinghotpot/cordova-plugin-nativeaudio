
Examples to use LowLatencyAudio plugin.

The resource must be relative path under cordova web files root folder "www/".
For example, if the file is under "www/audio/music.mp3", then:

```javascript
var music_mp3 = 'audio/music.mp3';
var click_sound = 'audio/click.mp3';

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