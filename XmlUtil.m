//
//  XmlUtil.m
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import "XmlUtil.h"

@implementation XmlUtil

/*
 * 取得從某一節點開始，符合 xPath 的節點的內容
 */
+(NSString *)getElementText:(DDXMLElement *)elm byXPath:(NSString *)xPath {
    
    NSString *result = @"";
    DDXMLElement *elmTarget = [XmlUtil selectElement:elm byXPath:xPath];
    if (elmTarget) {
        result = elmTarget.stringValue ;
    }
    return result ;
}

/*
 * 取得從某一節點開始，符合 xPath 的第一節點。如果不存在，就回傳 nil
 */
+(DDXMLElement *)selectElement:(DDXMLElement *)fromElement byXPath:(NSString *)xPath {
    
    DDXMLElement *result = nil;
    if (fromElement) {
        NSArray *nodes = [XmlUtil selectElements:fromElement byXPath:xPath];
        if ([nodes count] > 0) {
            result = [nodes objectAtIndex:0];
        }
    }
    return result ;
}

/*
 * 取得從某一節點開始，符合 xPath 的所有節點。如果不存在，就回傳 nil
 */
+(NSArray *)selectElements:(DDXMLElement *)fromElement byXPath:(NSString *)xPath {
    NSError *err = nil;
    NSArray *result = [[NSArray alloc] init];
    if (fromElement) {
        NSArray *nodes = [fromElement nodesForXPath:xPath error:&err];
        return nodes;
    }
    return result ;
}

@end
