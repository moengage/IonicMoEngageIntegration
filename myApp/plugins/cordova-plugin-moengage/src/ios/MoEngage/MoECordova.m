
//
//  MoECordova.m
//  MoEngage
//
//  Created by Chengappa C D on 27/07/2016.
//  Copyright MoEngage 2016. All rights reserved.
//

#import "MoECordova.h"
#import "MoEngage.h"
#import "MOEHelperConstants.h"

@implementation MoECordova

#pragma mark- Set AppStatus INSTALL/UPDATE

-(void)existing_user:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* attributesDict = [command.arguments objectAtIndex:0];
            if ([self validObjectForKey:@"existing_user" inDictionary:attributesDict] != nil) {
                BOOL isExisting = [[self validObjectForKey:@"existing_user" inDictionary:attributesDict] boolValue];
                NSString* message;
                if (isExisting) {
                    message = @"UPDATE tracked";
                    [[MoEngage sharedInstance] appStatus:UPDATE];
                }
                else{
                    message = @"INSTALL tracked";
                    [[MoEngage sharedInstance] appStatus:INSTALL];
                }
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arguments not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

#pragma mark- Show InApp method
-(void)showInApp:(CDVInvokedUrlCommand*)command{
    [[MoEngage sharedInstance] handleInAppMessage];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

#pragma mark- Reset method
-(void)logout:(CDVInvokedUrlCommand*)command{
    [[MoEngage sharedInstance]resetUser];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

#pragma mark- Track Event
- (void)track_event:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* eventDict = [command.arguments objectAtIndex:0];
            
            NSString* eventName = [self validObjectForKey:@"event_name" inDictionary:eventDict];
            NSMutableDictionary* payloadDict = [self validObjectForKey:@"event_attributes" inDictionary:eventDict];
            if (eventName != nil) {
                [[MoEngage sharedInstance] trackEvent:eventName andPayload:payloadDict];
                NSString* message = [NSString stringWithFormat:@"%@ tracked", eventName];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Event name was null"];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

#pragma mark- Set User Attributes

- (void)set_user_attribute:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        
        [self.commandDelegate runInBackground:^{
            NSDictionary* userAttributeDict = [command.arguments objectAtIndex:0];
            if (userAttributeDict!=nil) {
                NSString* userAttributeName = [self validObjectForKey:@"attribute_name" inDictionary:userAttributeDict];
                id userAttributeVal  = [self validObjectForKey:@"attribute_value" inDictionary:userAttributeDict];
                if (userAttributeName != nil && userAttributeVal != nil) {
                    [[MoEngage sharedInstance]setUserAttribute:userAttributeVal forKey:userAttributeName];
                    
                    NSString* message = [NSString stringWithFormat:@"%@ tracked with Value %@", userAttributeName, userAttributeVal];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or value was null"];
                }
            }
            else{
                 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or value was null"];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}


-(void)set_user_attribute_location:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
        NSDictionary* userAttributeDict = [command.arguments objectAtIndex:0];
        if (userAttributeDict!=nil) {
            
            NSString* userAttributeName = [self validObjectForKey:@"attribute_name" inDictionary:userAttributeDict];
            id userAttributeLatVal  = [self validObjectForKey:@"attribute_lat_value" inDictionary:userAttributeDict];
            id userAttributeLonVal  = [self validObjectForKey:@"attribute_lon_value" inDictionary:userAttributeDict];
            
            if (userAttributeName != nil && userAttributeLonVal !=nil && userAttributeLatVal != nil) {
                [[MoEngage sharedInstance] setUserAttributeLocationLatitude:[userAttributeLatVal doubleValue] longitude:[userAttributeLonVal doubleValue] forKey:userAttributeName];
                
                NSString* message = [NSString stringWithFormat:@"%@ tracked with Value %@ %@", userAttributeName, userAttributeLatVal, userAttributeLonVal];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or Lat,Lon value was null"];
            }
        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or value was null"];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

- (void)set_user_attribute_timestamp:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* userAttributeDict = [command.arguments objectAtIndex:0];
            if (userAttributeDict!=nil) {
                
                NSString* userAttributeName = [self validObjectForKey:@"attribute_name" inDictionary:userAttributeDict];
                id userAttributeTimestampVal  = [self validObjectForKey:@"attribute_value" inDictionary:userAttributeDict];
                
                if (userAttributeName != nil && userAttributeTimestampVal!= nil) {
                    [[MoEngage sharedInstance] setUserAttributeTimestamp:[userAttributeTimestampVal doubleValue] forKey:userAttributeName];
                    
                    NSString* message = [NSString stringWithFormat:@"%@ tracked with Value %@", userAttributeName, userAttributeTimestampVal];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or TimeStamp value was null"];
                }
                
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute name or value was null"];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];

    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
}

#pragma mark- Utility Methods

-(id)validObjectForKey:(NSString*)key inDictionary:(NSDictionary*)dict {
    id obj = [dict objectForKey:key];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    return obj;
}

- (void)setLogLevelForiOS:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* attributesDict = [command.arguments objectAtIndex:0];
            if ([self validObjectForKey:@"log_level" inDictionary:attributesDict] != nil) {
                NSInteger logLevel = [[self validObjectForKey:@"log_level" inDictionary:attributesDict] integerValue];
                NSString* message;
                if (logLevel == 1) {
                    message = @"All Logs Enabled";
                    [MoEngage debug:LOG_ALL];
                }
                else if(logLevel == 2) {
                    message = @"Exception Logs Enabled";
                    [MoEngage debug:LOG_EXCEPTIONS];
                }
                else{
                    message = @"SDK Logs Disabled";
                    [MoEngage debug:LOG_NONE];
                }
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arguments not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

}


- (void)registerForPushNotification:(CDVInvokedUrlCommand*)command{
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil andCategoriesForPreviousVersions:nil andWithUserNotificationCenterDelegate:[UIApplication sharedApplication].delegate];
}

- (void)enableDataRedirection:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* dict = [command.arguments objectAtIndex:0];
            BOOL redirectData = [[dict valueForKey:@"set_redirect"] boolValue];
            [MoEngage setDataRedirection:redirectData];
            
            NSString* message;
            if (redirectData) {
                message = @"Data redirection Enabled";
            }
            else{
                message = @"Data redirection Disabled";
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

#pragma mark- Unused methods

- (void)pass_token:(CDVInvokedUrlCommand*)command{
    NSString* message = @"Not available for iOS";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)pass_payload:(CDVInvokedUrlCommand*)command{
    NSString* message = @"Not available for iOS";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setLogLevel:(CDVInvokedUrlCommand*)command{
    NSString* message = @"Not available for iOS";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
