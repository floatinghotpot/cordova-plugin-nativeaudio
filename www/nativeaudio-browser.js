
__res_cache = {};

exports.preloadSimple = function(id, assetPath, success, fail) {
    var res = new Audio();
    res.addEventListener('canplaythrough', success, false);
    res.onerror = fail;
    res.setAttribute('src', assetPath);
    res.load();
    __res_cache[ id ] = res;
};

exports.preloadComplex = function(id, assetPath, volume, voices, delay, success, fail) {
    var res = new Audio();
    res.addEventListener('canplaythrough', success, false);
    res.onerror = fail;
    res.setAttribute('src', assetPath);
    res.load();
    res.volume = volume;
    __res_cache[ id ] = res;
};

exports.play = function(id, success, fail) {
    var res = __res_cache[ id ];
    if(typeof res === 'object') {
        res.play();
        if(typeof success === 'function') success();
    } else {
        if(typeof fail === 'function') fail();
    }
};

exports.mute = function(ismute, success, fail) {
    for(id in __res_cache) {
        var res = __res_cache[ id ];
        if(typeof res === 'object') res.muted = ismute;
    }
    if(typeof success === 'function') success();
};

exports.loop = function(id, success, fail) {
    var res = __res_cache[ id ];
    if(typeof res === 'object') {
        res.loop = true;
        res.play();
        if(typeof success === 'function') success();
    } else {
        if(typeof fail === 'function') fail();
    }
};

exports.stop = function(id, success, fail) {
    var res = __res_cache[ id ];
    if(typeof res === 'object') {
        res.pause();
        if (res.currentTime) res.currentTime = 0;
        if(typeof success === 'function') success();
    } else {
        if(typeof fail === 'function') fail();
    }
};

exports.unload = function(id, success, fail) {
    var res = __res_cache[ id ];
    if(typeof res === 'object') {
        delete __res_cache[ id ];
        if(typeof success === 'function') success();
    } else {
        if(typeof fail === 'function') fail();
    }
};
