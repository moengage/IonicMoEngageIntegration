# Ionic integration of MoEngage Plugin

This is a sample app showing how to use cordova-plugin-moengage in Ionic project.

## Using the example project in iOS
1. After downloading/ cloning the project, Go to myApp folder in terminal.
2. Run : 
        $ sudo npm install
3. After this Add ios platform : 
        $ ionic platform add ios
4. Then Build and Run the project :
        $ ionic build ios
        $ ionic run ios
    

## Add Plugin to Ionic Project
To add plugin use the following command in your app folder :

    cordova plugin add moengagesdk --variable APP_ID="[your_app_id]" --variable SENDER_ID="[your_sender_id]" --variable NOTIFICATION_ICON="[notification_small_icon_drawable]" --variable NOTIFICATION_TYPE="[single/multlipe]" --variable NOTIFICATION_LARGE_ICON="[notification_small_icon]" --variable SKIP_GCM_REGISTRATION="[whether_moengage should_register for push]"

For more info refer the following link : http://docs.moengage.com/docs/sdk-integration-1

