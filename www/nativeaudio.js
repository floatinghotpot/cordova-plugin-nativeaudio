/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var exec = require('cordova/exec');

module.exports  = {

    preloadSimple: function(id, assetPath, success, errorCallback) {
        return cordova.exec(success, errorCallback, "nativeaudio", "preloadSimple", [id, assetPath]);
    },
    
    preloadComplex: function(id, assetPath, volume, voices, success, errorCallback) {
        if (voices === undefined) voices = 1;
        if (volume === undefined) volume = 1.0;
2
        return cordova.exec(success, errorCallback, "nativeaudio", "preloadComplex", [id, assetPath, volume, voices]);
    },

    play: function(id, success, errorCallback) {
        return cordova.exec(success, errorCallback, "nativeaudio", "play", [id]);
    },

    stop: function(id, success, errorCallback) {
        return cordova.exec(success, errorCallback, "nativeaudio", "stop", [id]);
    },

    loop: function(id, success, errorCallback) {
        return cordova.exec(success, errorCallback, "nativeaudio", "loop", [id]);
    },

    unload: function(id, success, errorCallback) {
        return cordova.exec(success, errorCallback, "nativeaudio", "unload", [id]);
    }
};