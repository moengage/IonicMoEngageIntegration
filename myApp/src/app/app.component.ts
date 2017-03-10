import { Component } from '@angular/core';
import { Platform } from 'ionic-angular';
import { StatusBar, Splashscreen } from 'ionic-native';
import { TabsPage } from '../pages/tabs/tabs';
declare var MoECordova: any; 

@Component({
  templateUrl: 'app.html'
})
export class MyApp {
  rootPage = TabsPage;

  constructor(platform: Platform) {
    platform.ready().then(() => {
      // Okay, so the platform is ready and our plugins are available.
      // Here you can do any higher level native things you might need.
      StatusBar.styleDefault();
      Splashscreen.hide();
      var moe = MoECordova.init();
      
      moe.setDataRedirection(true);
      moe.setLogLevelForiOS(1);
        
      moe.registerForPushNotification();

        var eventDict1 = {
            "attributeKey" : "attributeValue"
        };
        moe.trackEvent("Event1",eventDict1);


        var eventDict2 = {
            "attributeKeyBool" : true
        };
        moe.trackEvent("Event2",eventDict2);

        
        var eventDict3 = {
            "attributeKeyNumber" : 2333
        };
        moe.trackEvent("Event3",eventDict3);

        
        var eventDict4 = {
            "attributeKeyDecimal" : 2.34
        };
        moe.trackEvent("Event4",eventDict4);

        moe.trackEvent("Event5",null);

        moe.setExistingUser(true);


        moe.setUserAttribute("TEST_NUMBER", 23);
        moe.setUserAttribute("TEST_BOOL", true);
        moe.setUserAttribute("TEST_STRING", "HELLO");

        moe.setUserAttributeTimestamp("TEST_TIME",1470288682);

        moe.setUserAttributeLocation("TEST_LOCATION",72.0089,54.0009);

        moe.showInApp();

    });
  }
}
