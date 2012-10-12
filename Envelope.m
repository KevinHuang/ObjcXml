//
//  Envelope.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "Envelope.h"
#import "DDXML.h"


@implementation Envelope

@synthesize xmlDoc = _xmlDoc;

-(id) initWithXmlString: (NSString *)xmlString {
    if (self = [super init]) {
        NSError *err = nil;
        
        self.xmlDoc = [[DDXMLDocument alloc]
                      initWithXMLString:xmlString
                      options:(1 << 25|1 << 24)
                      error:&err];
        
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

        return self;
    }
    else
        return nil ;
}

-(NSString *)StatusCode {
    NSError *err = nil;
    NSString *result = @"";
    if (self.xmlDoc) {
        NSArray *nodes = [self.xmlDoc nodesForXPath:@"Envelope/Header/Status/Code" error:&err];
        if (nodes.count > 0)
        {
            result = [[nodes objectAtIndex:0] stringValue];
        }
    }
    
    return result ;
}



@end
