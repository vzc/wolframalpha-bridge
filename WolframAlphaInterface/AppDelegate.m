//
//  AppDelegate.m
//  WolframAlphaInterface
//
//  Created by Vincenzo Carrino on 22/03/2012.
//

#import "AppDelegate.h"
#import "WolframAlpha.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    WolframAlpha *wa = [[WolframAlpha alloc] initWithAppid:@"7JLJTR-YKUHLEVR6R"];
    
    /*
    // Test case Pi
    NSArray *k = [[NSArray alloc] initWithObjects:@"format", @"ignorecase", nil];
    NSArray *v = [[NSArray alloc] initWithObjects:@"html", @"true", nil];
    
    NSString *qu = [[NSString alloc] initWithString:@"Pi"];
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[WolframAlpha parameterDictonaryFromKeys:k values:v]];
    
    [wa doQueryWithInput:qu parameters:dict];

    [k release];
    [v release];
    [dict release];
    [qu release];
     */
    
    // Test case weather
    NSArray *k2 = [[NSArray alloc] initWithObjects:@"podstate", nil];
    NSArray *v2 = [[NSArray alloc] initWithObjects:@"WeatherCharts:WeatherData__Past+5+years", nil];
    
    NSString *qu2 = [[NSString alloc] initWithString:@"weather"];
    NSDictionary *dict2 = [[NSDictionary alloc] initWithDictionary:[WolframAlpha parameterDictonaryFromKeys:k2 values:v2]];

    [wa doQueryWithInput:qu2 parameters:dict2];
    
    [k2 release];
    [v2 release];
    [dict2 release];
    [qu2 release];
    
    
    NSLog(@"Done");
    [wa release];
}

@end
