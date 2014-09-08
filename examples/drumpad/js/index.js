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

        if( window.plugins && window.plugins.NativeAudio ) {

            window.plugins.NativeAudio.preloadSimple('assets/bass.mp3', 'assets/bass.mp3', function(msg){console.info(msg)}, function(msg){ console.error( 'Error: ' + msg ); });
            window.plugins.NativeAudio.preloadSimple('assets/snare.mp3', 'assets/snare.mp3', function(msg){console.info(msg)}, function(msg){ console.error( 'Error: ' + msg ); });
            window.plugins.NativeAudio.preloadSimple('assets/highhat.mp3', 'assets/highhat.mp3', function(msg){console.info(msg)}, function(msg){ console.error( 'Error: ' + msg ); });
            window.plugins.NativeAudio.preloadSimple('assets/bongo.mp3', 'assets/bongo.mp3', function(msg){console.info(msg)}, function(msg){ console.error( 'Error: ' + msg ); });

            window.plugins.NativeAudio.preloadComplex('assets/ambient.mp3', 'assets/ambient.mp3', 0.7, 1, function(msg){console.info(msg), window.plugins.NativeAudio.play('assets/ambient.mp3')}, function(msg){ alert( 'Error: ' + msg ); });



            window.plugins.NativeAudio.play('assets/ambient.mp3', function(msg){console.info(msg)}, function(msg){ console.error( 'Error: ' + msg ); }, function(msg){ console.error( 'Complete: ' + msg ); });
        }

    },

    play: function(drum) {
        document.getElementById(drum).classList.add('touched');
        window.plugins.NativeAudio.play('assets/' + drum + '.mp3', function(msg){console.info(msg), document.getElementById(drum).classList.remove('touched');}, function(msg){ console.error( 'Error: ' + msg ); });
    }


};