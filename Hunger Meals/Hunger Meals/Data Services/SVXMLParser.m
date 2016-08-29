//
//  SVXMLParser.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 2/29/16.
//

#import "SVXMLParser.h"

@implementation SVXMLParser

-(void)parseXML:(NSData *)response withKey:(NSString *)key{
    self.parsedResponse = [[NSMutableString alloc] init];
    self.parseKey = key;
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:response];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.currentElement=elementName;
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    self.currentElement=@"";
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if([self.currentElement isEqualToString:self.parseKey]) {
        [self.parsedResponse appendString:string];
    }
}

@end
