
//
//  MoECordova.h
//  MoEngage
//
//  Created by Chengappa C D on 27/07/2016.
//  Copyright MoEngage 2016. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface MoECordova : CDVPlugin

- (void)track_event:(CDVInvokedUrlCommand*)command;

- (void)set_user_attribute:(CDVInvokedUrlCommand*)command;
- (void)set_user_attribute_location:(CDVInvokedUrlCommand*)command;
- (void)set_user_attribute_timestamp:(CDVInvokedUrlCommand*)command;

- (void)registerForPushNotification:(CDVInvokedUrlCommand*)command;
- (void)existing_user:(CDVInvokedUrlCommand*)command;
- (void)showInApp:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)setLogLevelForiOS:(CDVInvokedUrlCommand*)command;
- (void)enableDataRedirection:(CDVInvokedUrlCommand*)command;

- (void)pass_token:(CDVInvokedUrlCommand*)command;
- (void)pass_payload:(CDVInvokedUrlCommand*)command;
- (void)setLogLevel:(CDVInvokedUrlCommand*)command;

@end


