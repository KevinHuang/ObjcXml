//
//  DSConnection.h
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtil.h"
#import "DSResponse.h"

typedef void (^ConnectionHandler)(NSInteger, DSResponse *resp);
typedef void (^PassportHandler)(NSString *);
typedef void (^ResponseHandler)(DSResponse *);

@interface DSConnection : NSObject

@property (readonly, nonatomic) NSString *apUrl;
@property (readonly, nonatomic) NSString *name;


-(void)connectAP:(NSString *)apUrl
        andContract:(NSString *)contract
         withUserid:(NSString *)uid
       andPasspword:(NSString *)pwd
            handler:(ConnectionHandler)handler;


-(void)connectAP :(NSString *)apUrl
        andContract:(NSString *)contract
       withPassport:(NSString *)passport
            handler:(ConnectionHandler)handler;

-(void)sendRequest:(NSString *)reqDoc success:(ResponseHandler)successHandler ;

-(void)getPassportWithSuccess:(PassportHandler)handler ;

-(void)getPassportByUid:(NSString *)uid andPassword:(NSString *)pwd success:(PassportHandler)handler;

@end
