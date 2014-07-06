/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        console.log('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        
		if(window.plugins && window.plugins.LowLatencyAudio) {

			var notes = ['2G', '2Ab', '2A', '2Bb', '2B', '3C', '3Db', '3D', '3Eb', '3E', '3F', '3Gb', '3G', '3Ab', '3A', '3Bb', '3B', '4C', '4Db', '4D', '4Eb', '4E'];
			
			for (x in notes) {
				window.plugins.LowLatencyAudio.preloadFX(notes[x], 'assets/' + notes[x] + '.mp3', function(msg){}, function(msg){ alert( 'Error: ' + msg ); });
			}	    
		}

    },
    
	play: function(note) {
        window.plugins.LowLatencyAudio.play(note);
	}
};
