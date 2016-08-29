//
//  SVXMLParser.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 2/29/16.
//

#import <Foundation/Foundation.h>

@interface SVXMLParser : NSObject<NSXMLParserDelegate>

@property(retain,nonatomic)NSMutableString *parsedResponse;
@property(retain,nonatomic)NSString *parseKey;
@property(retain,nonatomic)NSString *currentElement;

-(void)parseXML:(NSString *)response withKey:(NSString *)key;

@end
