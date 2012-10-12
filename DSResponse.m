//
//  DSResponse.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "DSResponse.h"

@interface DSResponse()

@property (nonatomic) NSString *statusCode;
@property (nonatomic) NSString *message;
@property DDXMLElement *header ;
@property DDXMLElement *body ;

@end

@implementation DSResponse

@synthesize statusCode =_statusCode , message =_message;

-(id) initWithXmlString: (NSString *)xmlString {
    
    if (self = [super init]) {
        NSError *err = nil;
        self.xmlDoc = [[DDXMLDocument alloc]
                       initWithXMLString:xmlString
                       options:(1 << 25|1 << 24)
                       error:&err];
        [self parseContent];
        return self;
    }
    else
        return nil ;
}


-(id) initWithData: (NSData *)xmlData {
    if (self = [super init]) {
        NSError *err = nil;
        self.xmlDoc = [[DDXMLDocument alloc]
                       initWithData:xmlData
                       options:(1 << 25|1 << 24)
                       error:&err];
        [self parseContent];
        return self;
    }
    else
        return nil ;
}

-(void)parseContent {
    NSError *err = nil;
    //1. parse Status Code
    
    self.header = [[self.xmlDoc nodesForXPath:@"Envelope/Header"
                                       error:&err] objectAtIndex:0];
    self.body = [[self.xmlDoc nodesForXPath:@"Envelope/Body"
                                        error:&err] objectAtIndex:0];
    [self parseStatusCode];
}

-(void)parseStatusCode {
    NSError *err = nil;
    if (self.xmlDoc) {
        //Code
        NSArray *nodes = [self.xmlDoc nodesForXPath:@"Envelope/Header/Status/Code" error:&err];
        if (nodes.count > 0)
        {
            self.statusCode = [[nodes objectAtIndex:0] stringValue];
        }
        //Message
        nodes = [self.xmlDoc nodesForXPath:@"Envelope/Header/Status/Message" error:&err];
        if (nodes.count > 0)
        {
            self.message = [[nodes objectAtIndex:0] stringValue];
        }
    }
}

@end
