/**
 * Created by liming on 14-7-18.
 */

var hotjs = hotjs || {};

(function() {

    var html5_audio = {
        // id -> obj mapping
        res_cache: {},

        preloadSimple: function(id, assetPath, success, fail) {
            var res = new Audio();
            res.addEventListener('canplaythrough', success, false);
            res.onerror = fail;
            res.setAttribute('src', assetPath);
            res.load();
            this.res_cache[ id ] = res;
        },

        preloadComplex: function(id, assetPath, volume, voices, delay, success, fail) {
            var res = new Audio();
            res.addEventListener('canplaythrough', success, false);
            res.onerror = fail;
            res.setAttribute('src', assetPath);
            res.load();
            res.volume = volume;
            this.res_cache[ id ] = res;
        },

        play: function(id, success, fail) {
            var res = this.res_cache[ id ];
            if(typeof res === 'object') {
                res.play();
                if(typeof success === 'function') success();
            } else {
                if(typeof fail === 'function') fail();
            }
        },

        mute: function(ismute, success, fail) {
            for(id in this.res_cache) {
                var res = this.res_cache[ id ];
                if(typeof res === 'object') res.muted = ismute;
            }
            if(typeof success === 'function') success();
        },

        loop: function(id, success, fail) {
            var res = this.res_cache[ id ];
            if(typeof res === 'object') {
                res.loop = true;
                res.play();
                if(typeof success === 'function') success();
            } else {
                if(typeof fail === 'function') fail();
            }
       },
        stop: function(id, success, fail) {
            var res = this.res_cache[ id ];
            if(typeof res === 'object') {
                res.pause();
                if (res.currentTime) res.currentTime = 0;
                if(typeof success === 'function') success();
            } else {
                if(typeof fail === 'function') fail();
            }
        },
        unload: function(id, success, fail) {
            var res = this.res_cache[ id ];
            if(typeof res === 'object') {
                delete this.res_cache[ id ];
                if(typeof success === 'function') success();
            } else {
                if(typeof fail === 'function') fail();
            }
        }
    };

    hotjs.Audio = hotjs.Audio || {};

    var initHotjsAudio = function() {
        if(window.plugins && window.plugins.NativeAudio) {
            hotjs.Audio = window.plugins.NativeAudio;
            if(typeof hotjs.Audio.mute !== 'function') {
                hotjs.Audio.mute = function(ismute, success, fail) {
                };
            }
        } else {
            hotjs.Audio = html5_audio;
        }

        hotjs.Audio.preloadSimpleBatch = function(fx_mapping, success, fail) {
            for(var k in fx_mapping) {
                this.preloadSimple(k, fx_mapping[k]);
            }
        };
        hotjs.Audio.unloadBatch = function(fx_mapping, success, fail) {
            for(var k in fx_mapping) {
                this.unload(k);
            }
        };

        hotjs.Audio.init = initHotjsAudio;
    };

    hotjs.Audio.init = initHotjsAudio;

})();
