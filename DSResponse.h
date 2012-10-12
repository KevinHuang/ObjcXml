//
//  DSResponse.h
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Envelope.h"

@interface DSResponse : Envelope

@property (readonly, nonatomic) NSString *statusCode;
@property (readonly, nonatomic) NSString *message;
@property (readonly) DDXMLElement *header;
@property (readonly) DDXMLElement *body ;

-(id) initWithXmlString: (NSString *)xmlString;
-(id) initWithData: (NSData *)xmlData ;

@end
