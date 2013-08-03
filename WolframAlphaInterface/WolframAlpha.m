//
//  WolframAlpha.m
//
//
//  Created by Vincenzo Carrino on 21/03/2012.
//

#import "WolframAlpha.h"

@interface WolframAlpha (PrivateMethods)

- (void)doGetRequest:(NSURL *)url;

@end


@implementation WolframAlpha

@synthesize appid;
@synthesize receivedData;
@synthesize URLResponse;

#pragma mark -

- (id) initWithAppid:(NSString *)argAppid
{
    if (!(self = [super init])){
        return nil;
    }
    
    self.appid = argAppid;
    
    return self;
}

#pragma mark -
#pragma mark Class Methods

+ (NSDictionary *)parameterDictonaryFromKeys:(NSArray *)keys
                                      values:(NSArray *)vals
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    for (int i = 0; i < [keys count]; i++){
        if (![dict objectForKey:[keys objectAtIndex:i]]){
            [dict setObject:[vals objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        }
        else{
            if ([[dict objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSMutableArray class]]){
                [[dict objectForKey:[keys objectAtIndex:i]] addObject:[vals objectAtIndex:i]];
            }
            else{
                NSString *s = [[NSString alloc] initWithString:[dict objectForKey:[keys objectAtIndex:i]]];
                [dict removeObjectForKey:[keys objectAtIndex:i]];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:s,[vals objectAtIndex:i], nil];
                [dict setObject:arr forKey:[keys objectAtIndex:i]];
                [s release];
                [arr release];
            }
        }
    }
    return [dict autorelease];
}

#pragma mark -
#pragma mark Queries

- (void)doQueryWithInput:(NSString *)input
              parameters:(NSDictionary *)dict
{
    if ((input == nil) || ([input length] <= 0)){
        return;
    }
    NSMutableString *queryString = [[NSMutableString alloc] initWithFormat:@"%@appid=%@&input=%@",kQueryURL,appid,input];
    if ((dict != nil) && ([dict count] > 0)){
        NSArray *keys = [dict allKeys];
        for (int i = 0; i < [keys count]; i++) {
            if (![[dict objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSMutableArray class]]) {
                [queryString appendFormat:@"&%@=%@",[keys objectAtIndex:i],[dict objectForKey:[keys objectAtIndex:i]]];
            }
            else{
                for (int j = 0; j < [[dict objectForKey:[keys objectAtIndex:i]] count]; j++) {
                    [queryString appendFormat:@"&%@=%@",[keys objectAtIndex:i],[[dict objectForKey:[keys objectAtIndex:i]] objectAtIndex:j]];
                }
            }
        }
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[url absoluteString]);
    
    [self doGetRequest:url];
    [queryString release];
    [url release];
}



#pragma mark -
#pragma mark Requests

- (void)doGetRequest:(NSURL *)url
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (con){
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        [data release];
    }
    
    //[con autorelease];
    [req release];
    
}

- (void)doPostRequest:(NSURL *)url
         withBodyData:(NSData *)bodyData
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:bodyData];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (con){
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData = data;
        [data release];
    }
    
    //[con autorelease];
    [req release];
}

#pragma mark -
#pragma mark Response Parsing 

// Create new class of WolframAlphaResponse to populate with parsed data
// OR
// Data structure of parsed data in WolframAlpha class

// 

#pragma mark -
#pragma mark URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    self.URLResponse = response;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [connection release];
    self.receivedData = nil;
    //[receivedData release];
    
    NSLog(@"Connection failed! Error - %@ (URL: %@)",
          [error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",dataString);
    
    [dataString release];
    
    
    [connection release];
    self.receivedData = nil;
    [receivedData release];
    self.URLResponse = nil;
    [URLResponse release];
}

#pragma mark -

- (void)dealloc
{
    [appid release];
    [receivedData release];
    [URLResponse release];
    [super dealloc];
}


@end
