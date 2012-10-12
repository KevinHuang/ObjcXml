//
//  HttpUtil.m
//  TestDSAService
//
//  Created by Huang Kevin on 12/10/5.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil

-(void)getFrom:(NSString *)url
   withSuccess:(SuccessCallback)success
      withFail:(FailCallback)fail{
    
    _success = success ;
    _fail = fail ;
    
    NSURL *theurl =[NSURL URLWithString: url];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:theurl];
    NSString *msgLength = @"0";
    
    //---need this only if using SOAP 1.1---
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"GET"];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        responseData = [[NSMutableData data] init];
    }
}

-(void)postTo:(NSString *)url
  withRequest:(NSString *)reqDoc
  withSuccess:(SuccessCallback)success
     withFail:(FailCallback)fail{
    
    _success = success ;
    _fail = fail ;
    
    NSString *soapMsg = reqDoc;
    
    //---print the XML to examine---
    NSLog(@"%@", soapMsg);
    
    //NSURL *theurl = [NSURL URLWithString: @"http://tw.yahoo.com"];
    
    NSURL *theurl = [NSURL URLWithString:url];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:theurl];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    
    //---need this only if using SOAP 1.1---
    
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        responseData = [[NSMutableData data] init];
    }
    
}

-(void) connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *) response{
    [responseData setLength: 0];
}

-(void) connection:(NSURLConnection *)connection
    didReceiveData:(NSData *) data {
    [responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection
  didFailWithError:(NSError *) error {
    
    if (_fail) {
        _fail(error);
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    //[conn release];
    NSLog(@"DONE. Received Bytes: %d", [responseData length]);
    /*
     NSString *theXML = [[NSString alloc]
     initWithBytes:[responseData mutableBytes]
     length:[responseData length]
     encoding:NSUTF8StringEncoding];
     */
    if (_success != nil) {
        _success(responseData);
    }
    
    //---prints the XML received---
    //NSLog(@"%@", theXML);
}

@end
