#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CDVZoom : CDVPlugin
{}

+ (NSString*)cordovaVersion;

- (void)initService:(CDVInvokedUrlCommand*)command;
- (void)joinMeeting:(CDVInvokedUrlCommand*)command;
- (void)createInstantMeeting:(CDVInvokedUrlCommand*)command;

@end
