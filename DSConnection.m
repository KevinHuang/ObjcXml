//
//  DSConnection.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "DSConnection.h"
#import "DDXML.h"
#import "DSResponse.h"
#import "XmlUtil.h"

@interface DSConnection()
{
    ConnectionHandler _connectionHandler;
    PassportHandler _passportHandler;
    
    NSString *_contract;
    NSString *_uid ;
    NSString *_pwd ;
    NSString *_passport ;
    BOOL _isConnectWithPassport ;
    NSString *_sessionID;
    NSString *_auth_url ;
}

@property (nonatomic) NSString *apUrl;
@property (nonatomic) NSString *name;

@end

@implementation DSConnection

-(id)init {
    
    if (self = [super init]) {
        _auth_url =  @"https://auth.ischool.com.tw:8443/dsa/greening";
        return self;
    }
    else
        return nil ;
}


@synthesize apUrl = _apUrl , name=_name;

-(void)connectAP:(NSString *)apUrl
     andContract:(NSString *)contract
    withPassport:(NSString *)passport
         handler:(ConnectionHandler)handler {
    
    _connectionHandler = handler ;
    _contract = contract;
    _passport = passport ;
    _isConnectWithPassport = YES ;
    //1. 如果是 DSNS，則轉換成真實的 URL
    [self parseAPUrl:apUrl];
}

-(void)connectAP:(NSString *)apUrl
     andContract:(NSString *)contract
      withUserid:(NSString *)uid
    andPasspword:(NSString *)pwd
         handler:(ConnectionHandler)handler {
    
    _contract = contract;
    _connectionHandler = handler ;
    _uid = uid;
    _pwd = pwd ;
    _isConnectWithPassport = NO ;
    [self parseAPUrl:apUrl];
    
}

-(void)sendRequest:(NSString *)reqDoc
           success:(ResponseHandler)successHandler {
    
    //Add SessionID to ReqDoc if there is no security element.
    NSString *req = [self addSessionIDToReqDoc:reqDoc];
    
    HttpUtil *hu = [[HttpUtil alloc] init];
    NSString *target_url = [NSString stringWithFormat:@"%@/%@",self.apUrl, _contract] ;
    [hu postTo:target_url
        withRequest:req
        withSuccess:^(NSData *data) {
            DSResponse *objResp = [[DSResponse alloc] initWithData:data];
            if (successHandler)
                successHandler(objResp);
        }
        withFail:^(NSError *err) {
            [NSException raise:@"sendRequest Exception" format:@"%@", err.description];
        }
     ];

}

-(void)getPassportByUid:(NSString *)uid
            andPassword:(NSString *)pwd
                success:(PassportHandler)handler{
    _uid = uid;
    _pwd = pwd ;
    [self connectAP:_auth_url andContract:@"user" withUserid:uid andPasspword:pwd
            handler:^(NSInteger connectStatus, DSResponse *resp) {
                if (connectStatus == 0) {
                    @try {
                        [self getPassportWithSuccess:^(NSString *passport) {
                            handler(passport);
                            }
                        ];
                    }
                    @catch (NSException *exception) {
                        @throw exception;
                    }
                }
                else {
                    [NSException raise:@"ConnectAP Fail !" format:@"%@", @"帳號認證時發生錯誤"];
                }
            }
     ];
}


-(void)getPassportWithSuccess:(PassportHandler)handler  {
    NSString *reqDoc = [self makePassportReqDoc] ;
    [self sendRequest:reqDoc
              success:^(DSResponse *resp) {
                  if ([resp.statusCode isEqualToString: @"0"]) {
                      DDXMLElement *elmBody = resp.body ;
                      DDXMLElement *elmPassport = [XmlUtil selectElement:elmBody byXPath:@"DSAPassport" ];
                      NSString *passport = (elmPassport) ? ([elmPassport XMLString]) : (@"");
                      if (![passport isEqualToString:@"" ]) {
                          if (handler)
                              handler(passport);
                      }
                      else {
                          [NSException raise:@"getPassportFail" format:@"%@", @"取得 passport 發生錯誤"];
                      }
                  }
                  else {
                      [NSException raise:@"getPassportFail" format:@"%@", [XmlUtil getElementText:resp.header byXPath:@"Status/Message"]];
                  }
              }
    ];
}

/*=======   private function ===== */

-(NSString *)addSessionIDToReqDoc:(NSString *)reqDoc {
    NSError *err = nil;
    DDXMLDocument *doc = [[DDXMLDocument alloc]
                   initWithXMLString:reqDoc
                   options:(1 << 25|1 << 24)
                   error:&err];
    DDXMLElement *elmHeader = [[doc nodesForXPath:@"Envelope/Header" error:&err] objectAtIndex:0];
    if ([[elmHeader nodesForXPath:@"SecurityToken" error:&err] count] == 0) {
        NSString *sessionNodeXml = [NSString stringWithFormat:@"<SecurityToken Type='Session'><SessionID>%@</SessionID></SecurityToken>", _sessionID];
        int index = -1;
        for(DDXMLElement *elm in elmHeader.children) {
            if ([elm.name isEqualToString:@"Security"]) {
                break;
            }
            index += 1;
        }
        if (index > 0) {
            [elmHeader removeChildAtIndex:index];
        }
    
        DDXMLElement *elmSecurity = [[DDXMLElement alloc] initWithXMLString:sessionNodeXml error:&err];
        [elmHeader addChild:elmSecurity];
    }
    NSLog(@"%@", [doc XMLString]);
    return [doc XMLString];
    
}

-(NSString *)makePassportReqDoc {
    NSString *temp = @"<Envelope><Header><TargetService>DS.Base.GetPassportToken</TargetService><SecurityToken Type=\"Session\"><SessionID>%@</SessionID></SecurityToken></Header><Body></Body></Envelope>";
    
    return [NSString stringWithFormat:temp, _sessionID];
}


-(void)parseAPUrl:(NSString *)apUrl {
    BOOL isHttpUrl = [apUrl hasPrefix:@"http://"] || [apUrl hasPrefix:@"https://"] ;
    
    if (! isHttpUrl) {  //解析 DSNS
        NSString *dsns_url = @"https://dsns.ischool.com.tw:8441/dsns/dsns";
        NSString *reqDoc = @"<Envelope><Header><TargetService>DS.NameService.GetDoorwayURL</TargetService><SecurityToken><UserName>anonymous</UserName><Password></Password></SecurityToken></Header><Body><DomainName>%@</DomainName></Body></Envelope>";
        reqDoc = [NSString stringWithFormat:reqDoc, apUrl];
        HttpUtil *hu = [[HttpUtil alloc] init];
        [hu postTo:dsns_url
            withRequest:reqDoc
            withSuccess:^(NSData *data) {
                DSResponse *objResp = [[DSResponse alloc] initWithData:data];
                DDXMLElement *elmBody = objResp.body ;
                NSString *target_url = [XmlUtil getElementText:elmBody byXPath:@"DoorwayURL"];
                if ([target_url isEqualToString:@""]) {
                    _connectionHandler(1, objResp); //can't find dsns
                } 
                else {
                    self.apUrl = target_url ;
                    [self connect];
                }
            }
            withFail:^(NSError *err) {
                _connectionHandler(2, nil);    //
            }
        ];
        
    }
    else {
        self.apUrl = apUrl;
        [self connect];
    }
}


-(void)connect {
    NSString *reqDoc = (_isConnectWithPassport) ? ([self makeConnectionReqDocWithPassport]) : ([self makeConnectionReqDocWithUidPwd]) ;
    
    @try {
        [self sendRequest:reqDoc
                  success:^(DSResponse *resp) {
                      NSLog(@"%@",resp.xmlDoc.XMLString );
                      if ([resp.statusCode isEqualToString:@"0"]) {
                          DDXMLElement *elmBody = resp.body ;
                          _sessionID = [XmlUtil getElementText:elmBody byXPath:@"SessionID"];
                          if ([_sessionID isEqualToString:@""]) {
                              [NSException raise:@"ConnectException" format:@"no sessionID"];
                              //_connectionHandler(3, resp); //can't find dsns
                          }
                          else {
                              _connectionHandler(0, resp);
                          }
                      }
                      else {
                          [NSException raise:@"ConnectException" format:@"%@ -- %@",resp.statusCode, resp.message];
                      }
                  }
         ];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

-(NSString *)makeConnectionReqDocWithPassport {
    NSString *temp = @"<Envelope><Header><TargetService>DS.Base.Connect</TargetService><SecurityToken  Type=\"Passport\">%@</SecurityToken></Header><Body><RequestSessionID /></Body></Envelope>";
    
    return [NSString stringWithFormat:temp, _passport];
}

-(NSString *)makeConnectionReqDocWithUidPwd {
    NSString *temp = @"<Envelope><Header><TargetService>DS.Base.Connect</TargetService><SecurityToken Type=\"Basic\"><UserName>%@</UserName><Password>%@</Password></SecurityToken></Header><Body><RequestSessionID /></Body></Envelope>";
    
    return [NSString stringWithFormat:temp, _uid, _pwd];
}



@end
