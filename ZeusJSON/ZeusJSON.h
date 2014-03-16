//
//  ZeusJSON.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZeusJSON : NSObject

+ (NSObject*) deserializeJSONToObject:(NSData*)data withClass:(Class)klass;

@end
