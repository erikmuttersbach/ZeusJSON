//
//  ZeusJSON.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import "ZeusJSON.h"

#import <Foundation/NSJSONSerialization.h>

#import "ZeusDeserializer.h"
#import "ZeusNamingStrategy.h"

@interface ZeusJSON ()

@end

@implementation ZeusJSON

+ (NSObject *)deserializeJSONToObject:(NSData *)data withClass:(__unsafe_unretained Class)klass {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(error) {
        NSLog(@"ERROR: Could not deserialize JSON: %@", error);
        return nil;
    }
    
    ZeusDeserializer *deserializer = [[ZeusDeserializer alloc] init];
    deserializer.klass = klass;
    deserializer.json = json;
    deserializer.namingStrategy = [[ZeusNamingStrategy alloc] init];
    deserializer.valueTransformer = [[ZeusValueTransformer alloc] init];
    return [deserializer deserialize];
}

@end
