
The examples can get you started with the Low Latency Audio plugin.

Start by creating a project.

```shell
cordova create Piano com.example.piano Piano
cd Piano
cordova platform add android
cordova plugin add https://github.com/floatinghotpot/cordova-plugin-lowlatencyaudio.git
```

Then replace index.html with the one in the example directory and copy the assets folder into the /www/ directory.