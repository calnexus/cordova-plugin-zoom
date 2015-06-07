#import <Cordova/CDV.h>
#import <ZoomSDK/ZoomSDK.h>
#import "CDVZoom.h"
#import "MainViewController.h"

@interface CDVZoom () {}
@end

@implementation CDVZoom

- (void)initService:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;

    NSString* appKey = [command.arguments objectAtIndex:0];
    NSString* appSecret = [command.arguments objectAtIndex:1];
    NSString* zoomSDKDomain = [command.arguments objectAtIndex:2];

    MainViewController *mainController = [[[MainViewController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:mainController] autorelease];
    [navController setNavigationBarHidden:YES];

    //1. Set ZoomSDK Domain
    [[ZoomSDK sharedSDK] setZoomDomain:zoomSDKDomain];
    //2. Set ZoomSDK Root Navigation Controller
    [[ZoomSDK sharedSDK] setZoomRootController:navController];
    //3. ZoomSDK Authorize
    ZoomSDKAuthService *authService = [[ZoomSDK sharedSDK] getAuthService];
    if (authService)
    {
        authService.delegate = self;

        authService.clientKey = appKey;
        authService.clientSecret = appSecret;

        [authService sdkAuth];
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)joinMeeting:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;

    NSString* userName = [command.arguments objectAtIndex:0];
    NSString* meetingNumber = [command.arguments objectAtIndex:1];

    ZoomSDKMeetingService *ms = [[ZoomSDK sharedSDK] getMeetingService];
    if (ms)
    {
        ms.delegate = self;

        ZoomSDKMeetError ret = [ms joinMeeting:meetingNumber displayName:userName];

        NSLog(@"onJoinaMeeting ret:%d", ret);
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)createInstantMeeting:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;

    NSString* userID = [command.arguments objectAtIndex:0];
    NSString* userName = [command.arguments objectAtIndex:1];
    NSString* userToken = [command.arguments objectAtIndex:2];

    ZoomSDKMeetingService *ms = [[ZoomSDK sharedSDK] getMeetingService];
    if (ms)
    {
        ms.delegate = self;

        //for scheduled meeting
//        ZoomSDKMeetError ret = [ms startMeeting:kSDKUserID userToken:kSDKUserToken userType:ZoomSDKUserType_ZoomUser displayName:kSDKUserName meetingNumber:kSDKMeetNumber];

        //for instant meeting
        ZoomSDKMeetError ret = [ms startInstantMeeting:userID userToken:userToken userType:ZoomSDKUserType_ZoomUser displayName:userName];

        NSLog(@"onMeetNow ret:%d", ret);
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

#pragma mark - Auth Delegate

- (void)onZoomSDKAuthReturn:(ZoomSDKAuthError)returnValue
{
    NSLog(@"onZoomSDKAuthReturn %d", returnValue);
}
@end
