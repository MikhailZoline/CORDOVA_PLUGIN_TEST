To test coolMethod plugin:
- cordova create testapp com.create.testapp TestApp
- cd testapp
- cordova plugin add cordova-plugin-add-swift-support --save
- cordova platform add ios
- cordova plugin add ../coolMethodPlugin/coolMethod/
- in testapp/platforms/ios/www/js/index.js
in index.js replace onDeviceReady:
with:
onDeviceReady: function() {
  this.receivedEvent('deviceready');
  coolMethod.coolMethod(
    'Plugin Ready!', 
    function(msg) { 
      document
        .getElementById('deviceready')
        .querySelector('.received')
        .innerHTML = msg;   
    },
    function(err) {
      document
        .getElementById('deviceready')
        .innerHTML = '<p class="event received">' + err + '</p>'; 
    }
  );

  coolMethod.coolMethodjs(
    'Hello Plugin',
    function(msg) {
      document.getElementsByTagName('h1')[0].innerHTML = msg;
    },
    function(err) {
      document.getElementsByTagName('h1')[0].innerHTML = err;
    }
  );
}

- build with xcode and test
- or cordova build, cordova run