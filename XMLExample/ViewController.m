//
//  ViewController.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/5.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "ViewController.h"
#import "KissXML/DDXML.h"
#import "HttpUtil.h"
#import "DSUtil.h"

@interface ViewController ()
{
    DSConnection *_cn;
    NSString *_passport;
}

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_click:(id)sender {
    
    NSString *url = @"https://auth.ischool.com.tw:8443/dsa/greening/user" ;
    //NSURL *furl = [NSURL URLWithString:url];
    HttpUtil *hu = [[HttpUtil alloc] init];
    [hu getFrom:url
        withSuccess:^(NSData *resp) {
            NSError *err = nil;
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:resp
                                                        options:(1 << 25|1 << 24)
                                                        error:&err];
            NSLog(@"%@",[doc XMLString] );
            NSString *txt = [XmlUtil getElementText:[doc rootElement] byXPath:@"Header/Status/Code"];
            NSLog(@"%@", txt);
                        
        }
        withFail:^(NSError *err) {
            NSLog(@"Exception : %@", err.description);
        }
    ];
}

- (IBAction)btnDSConnection_Click:(id)sender {
    
    User *u = [[User alloc] initWithUid:@"kevin.huang@ischool.com.tw" andPassword:@"1234567" ];
    @try {
        [u signInSuccess:^(void) {
            NSString *fName = u.firstName;
            NSString *lName = u.lastName ;
            self.lblMsg.text = [NSString stringWithFormat:@"歡迎你, %@ %@",fName, lName ] ;
            
            }
        ];

    }
    @catch (NSException *exception) {
        self.lblMsg.text = exception.description ;
    }

    /*
    _cn = [[DSConnection alloc] init];
    [_cn getPassportByUid:@"kevin.huang@ischool.com.tw"
              andPassword:@"12345678"
                  success:^(NSString *passport) {
                      _passport = passport;
                      self.lblMsg.text = _passport ;

                  }
                     fail:^(NSError *err) {
                         self.lblMsg.text = err.description ;
                         //NSLog(@"%@", err.description);
                     }
     ];
 */
}

- (IBAction)btnSignWithPassport_Click:(id)sender {
    DSConnection *cn = [[DSConnection alloc] init];
    [cn connectAP:@"h.trialschool.tw"
      andContract:@"ta"
     withPassport:_passport
          handler:^(NSInteger connectStatus, DSResponse *resp) {
              NSLog(@"%i", connectStatus);
              if(connectStatus == 0) {
                  NSString *req = [self makeRequestDoc];
                  [cn sendRequest:req
                          success:^(DSResponse *resp) {
                              NSLog(@"%@", resp.xmlDoc.XMLString);
                          }
                   ];
              }
              else {
                  NSLog(@"%@", @"連線錯誤！");
              }
          }
    ];
}

-(NSString *)makeRequestDoc {
    NSString *result = @"<Envelope><Header><TargetService>TeacherAccess.GetCurrentDateTime</TargetService></Header><Body></Body></Envelope>" ;
    
    return result ;
}

@end
