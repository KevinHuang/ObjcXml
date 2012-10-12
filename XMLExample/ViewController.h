//
//  ViewController.h
//  XMLExample
//
//  Created by Huang Kevin on 12/10/5.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
- (IBAction)btn_click:(id)sender;
- (IBAction)btnDSConnection_Click:(id)sender;
- (IBAction)btnSignWithPassport_Click:(id)sender;

@end
