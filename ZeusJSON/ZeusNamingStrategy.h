//
//  ZeusNamingStrategy.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZeusNamingStrategy : NSObject

- (NSString*) JSONPropertyForClass:(NSString*)className;
- (NSString*) JSONPropertyForProperty:(NSString*)property;
- (NSString*) JSONIdRefPropertyForProperty:(NSString*)property;

- (NSString*) classForJSONProperty:(NSString*)property;

- (NSString*) idProperty;
- (NSString*) JSONIdProperty;
- (BOOL) isIdProperty:(NSString*)property;
- (BOOL) isJSONIdProperty:(NSString*)property;

- (BOOL) isIdRefProperty:(NSString*)property;

@end
