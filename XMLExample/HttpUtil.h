//
//  HttpUtil.h
//  TestDSAService
//
//  Created by Huang Kevin on 12/10/5.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FailCallback)(NSError *) ;
typedef void (^SuccessCallback)(NSData *);

@interface HttpUtil : NSObject
{
    NSMutableData *responseData;
    NSURLConnection *conn;
    SuccessCallback _success;
    FailCallback _fail ;
}


/* reqDoc : request body
 * success : handler for success scenario
 * fail : handler for fail scenario
 */
-(void)postTo:(NSString *)url
  withRequest:(NSString *)reqDoc
  withSuccess:(SuccessCallback)success
     withFail:(FailCallback)fail;

-(void)getFrom:(NSString *)url
   withSuccess:(SuccessCallback)success
      withFail:(FailCallback)fail;

@end
