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

var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

var mplExport = {

preloadFX: function ( id, assetPath, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "preloadFX", [id, assetPath]);
},    
    
preloadAudio: function ( id, assetPath, voices, success, fail) {
	if(voices === undefined) voices = 1;
    return cordova.exec(success, fail, "LowLatencyAudio", "preloadAudio", [id, assetPath, voices]);
},
    
play: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "play", [id]);
},
    
stop: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "stop", [id]);
},
    
loop: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "loop", [id]);
},
    
unload: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "unload", [id]);
}
};

module.exports = mplExport;
