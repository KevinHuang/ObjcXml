//
//  UserUtil.h
//  XMLExample
//
//  Created by Huang Kevin on 12/10/11.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSConnection.h"

typedef void (^SignInHandler)();

@interface User : NSObject

@property (readonly, nonatomic) NSString *userID;
@property (readonly, nonatomic) NSString *firstName;
@property (readonly, nonatomic) NSString *lastName;
@property (readonly, nonatomic) NSString *passport;

-(id)initWithUid:(NSString *)uid andPassword:(NSString *)pwd;

-(id)initWithPassport:(NSString *)passport;

-(void)signInSuccess:(SignInHandler)successHandler;

-(void)getPassportSuccess:(PassportHandler)successHandler ;
@end
