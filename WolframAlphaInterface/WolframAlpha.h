//
//  WolframAlpha.h
//
//
//  Created by Vincenzo Carrino on 21/03/2012.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#define kQueryURL @"http://api.wolframalpha.com/v2/query?"
#define kValidateQueryURL @"￼http://api.wolframalpha.com/v2/validatequery?"

@interface WolframAlpha : NSObject {
    
    NSString *appid;
    NSMutableData *receivedData;
    NSURLResponse *URLResponse;
    
}

@property(nonatomic, retain) NSString *appid;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSURLResponse *URLResponse;

- (id)initWithAppid:(NSString *)argAppid;
- (void)doQueryWithInput:(NSString *)input parameters:(NSDictionary *)dict;
+ (NSDictionary *)parameterDictonaryFromKeys:(NSArray *)keys values:(NSArray *)vals;

@end
