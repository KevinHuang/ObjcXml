//
//  XmlUtil.h
//  XMLExample
//
//  Created by Huang Kevin on 12/10/8.
//  Copyright (c) 2012年 Huang Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@interface XmlUtil : NSObject

/*
 * 取得從某一節點開始，符合 xPath 的節點的內容
 */
+(NSString *)getElementText:(DDXMLElement *)elm byXPath:(NSString *)xpath ;

/*
 * 取得從某一節點開始，符合 xPath 的第一節點。如果不存在，就回傳 nil
 */
+(DDXMLElement *)selectElement:(DDXMLElement *)fromElement byXPath:(NSString *)xPath;

/*
 * 取得從某一節點開始，符合 xPath 的所有節點。如果不存在，就回傳 nil
 */
+(NSArray *)selectElements:(DDXMLElement *)fromElement byXPath:(NSString *)xPath;
@end
