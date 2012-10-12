//
//  UserUtil.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/11.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "User.h"
@interface User()   {
    NSString *_uid;
    NSString *_pwd;
    NSString *_sessionID;
    //NSString *_passport;
    NSString *_auth_url ;
    BOOL _isInitWithPassport ;
    SignInHandler _connectionSuccessHandler;
    FailCallback _connectionFailHandler ;
    PassportHandler _passportSuccessHandler ;
    FailCallback _passportFailHandler ;
    
}
    @property (nonatomic) NSString *userID;
    @property (nonatomic) NSString *firstName;
    @property (nonatomic) NSString *lastName;
    @property (nonatomic) NSString *passport;

@end


@implementation User


@synthesize userID=_userID, firstName=_firstName, lastName=_lastName, passport=_passport;

-(id)initWithUid:(NSString *)uid andPassword:(NSString *)pwd {
    
    if (self = [super init]) {
        _uid = uid;
        _userID = uid ;
        _pwd = pwd;
        _isInitWithPassport = NO;
        return self;
    }
    else
        return nil ;

}

-(id)initWithPassport:(NSString *)passport {
    
    if (self = [super init]) {
        _passport = passport ;
        _isInitWithPassport = YES;
        return self ;
    }
    else
        return nil ;
}

-(void)getPassportSuccess:(PassportHandler)successHandler {
    
}

-(void)signInSuccess:(SignInHandler)successHandler {
    
    _connectionSuccessHandler = successHandler;
    @try {
        HttpUtil *hu = [[HttpUtil alloc] init] ;
        NSString *url = [NSString stringWithFormat:@"https://auth.ischool.com.tw/service/basicauth.php?uid=%@&pwd=%@", _uid, _pwd];
        //[NSException raise:@"SignIn Fail !" format:@"%@", @"parse json error."];
        
        [hu getFrom:url
        withSuccess:^(NSData *data) {
            [NSException raise:@"SignIn Fail !" format:@"%@", @"parse json error."];
            NSError *e = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
            if (!dic) {
                NSLog(@"parse json error : ");
                [NSException raise:@"SignIn Fail !" format:@"%@", @"parse json error."];
            }
            else {
                NSString *errMsg=@"";
                
                for(NSString *key in [dic keyEnumerator]) {
                    if ([key isEqualToString:@"firstName"])
                        _firstName = [dic objectForKey:key];
                    if ([key isEqualToString:@"lastName"])
                        _lastName = [dic objectForKey:key];
                    if ([key isEqualToString:@"sessionID"])
                        _sessionID = [dic objectForKey:key];
                    if ([key isEqualToString:@"errMsg"])
                        errMsg = [dic objectForKey:key];
                    
                    NSLog(@"%@ = %@", key, [dic valueForKey:key]);
                }
                
                if ([errMsg isEqualToString:@""]) {
                    [self MyConnectionHandler:0];
                }
                else {
                    [NSException raise:@"SignIn Fail !" format:@"%@", errMsg];
                }
            }
            
        }
           withFail:^(NSError *err) {
               [NSException raise:@"SignIn Fail !" format:@"%@", err.description];
           }
        ];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    
    /*
    DSConnection *cn =  [[DSConnection alloc] init];
    _auth_url = @"https://auth.ischool.com.tw:8443/dsa/greening";
    if (_isInitWithPassport) {
        [cn connectAP:_auth_url
          andContract:@"user"
         withPassport: _passport
              handler: ^(NSInteger connectionStatus, DSResponse *resp) {
                  NSLog(@"%@", resp.xmlDoc.XMLString);
                  [self MyConnectionHandler:connectionStatus];
              }
         ];
    }
    else {
        [cn connectAP:_auth_url
          andContract:@"user"
           withUserid:_uid
         andPasspword:_pwd
              handler:^(NSInteger connectionStatus, DSResponse *resp) {
                  NSLog(@"%@", resp.xmlDoc.XMLString);
                  //get passport
                  [cn getPassportWithSuccess:^(NSString *passport) {
                      _passport = passport ;
                      [self parsePassport:passport]; //parse passport to retrieve firstname, lastname ...
                      [self MyConnectionHandler:connectionStatus];
                  }
                   ];
              }
         ];
    }
     */
}

-(void)parsePassport:(NSString *)passport {
    
}

-(void)MyConnectionHandler:(NSInteger)connectionStatus {
    switch(connectionStatus) {
        case 0:
            _connectionSuccessHandler();
            break;
        case 1:
            _connectionFailHandler(nil);  //帳密錯誤
            break;
        case 2:
            _connectionFailHandler(nil); //
            break ;
        case 3:
            _connectionFailHandler(nil);
            break ;
    }
}


@end
