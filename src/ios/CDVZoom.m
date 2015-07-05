#import <Cordova/CDV.h>
#import <ZoomSDK/ZoomSDK.h>
#import "CDVZoom.h"
#import "MainViewController.h"

@interface CDVZoom ()<ZoomSDKMeetingServiceDelegate, ZoomSDKAuthDelegate> {
    
    UINavigationController *_navController;
    UIViewController *_vc;
    
}
@end

@implementation CDVZoom

- (void)initService:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;
    
    NSString* appKey = [command.arguments objectAtIndex:0];
    NSString* appSecret = [command.arguments objectAtIndex:1];
    NSString* zoomSDKDomain = [command.arguments objectAtIndex:2];
    
    _vc = [UIViewController new];
    _navController = [[UINavigationController alloc] initWithRootViewController:_vc];
    [_navController setNavigationBarHidden:YES];
    
    //1. Set ZoomSDK Domain
    [[ZoomSDK sharedSDK] setZoomDomain:zoomSDKDomain];
    //2. Set ZoomSDK Root Navigation Controller
    [[ZoomSDK sharedSDK] setZoomRootController:_navController];
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
        
        [self.viewController presentViewController:_navController animated:YES completion:nil];
        
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

#pragma mark - Meeting Service Delegate

- (void)onMeetingReturn:(ZoomSDKMeetError)error internalError:(NSInteger)internalError
{
    NSLog(@"onMeetingReturn:%d, internalError:%zd", error, internalError);
}

- (void)onMeetingStateChange:(ZoomSDKMeetingState)state
{
    NSLog(@"onMeetingStateChange:%d", state);
    
    if (state == 0) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
