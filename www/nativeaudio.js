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
    setOptions: function(options, successCallback, errorCallback) {

        return cordova.exec(successCallback, errorCallback, "NativeAudio", "setOptions", [options]);
    },

    preloadSimple: function(id, assetPath, successCallback, errorCallback) {

        return cordova.exec(successCallback, errorCallback, "NativeAudio", "preloadSimple", [id, assetPath]);
    },
    
    preloadComplex: function(id, assetPath, volume, voices, delay, successCallback, errorCallback) {

        return cordova.exec(successCallback, errorCallback, "NativeAudio", "preloadComplex", [id, assetPath, parseFloat(volume), voices, parseFloat(delay)]);
    },

    play: function(id, successCallback, errorCallback, completeCallback) {
        if(typeof completeCallback === "function") {
        	cordova.exec(completeCallback, errorCallback, "NativeAudio", "addCompleteListener", [id]);    
        }
        return cordova.exec(successCallback, errorCallback, "NativeAudio", "play", [id]);
        
    },

    stop: function(id, successCallback, errorCallback) {
        return cordova.exec(successCallback, errorCallback, "NativeAudio", "stop", [id]);
    },

    loop: function(id, successCallback, errorCallback) {
        return cordova.exec(successCallback, errorCallback, "NativeAudio", "loop", [id]);
    },

    unload: function(id, successCallback, errorCallback) {
        return cordova.exec(successCallback, errorCallback, "NativeAudio", "unload", [id]);
    },

    setVolumeForComplexAsset: function (id, volume, successCallback, errorCallback) {
        return cordova.exec(successCallback, errorCallback, "NativeAudio", "setVolumeForComplexAsset", [id, parseFloat(volume)]);
    }
};