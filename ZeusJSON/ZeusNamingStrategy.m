//
//  ZeusNamingStrategy.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import "ZeusNamingStrategy.h"

#import "NSString+Inflections.h"

@implementation ZeusNamingStrategy

- (NSString *)JSONPropertyForClass:(NSString *)className {
    NSString *propertyName = [className underscore];
    return propertyName;
}

- (NSString *)JSONPropertyForProperty:(NSString *)property {
    if([property isEqualToString:@"identifier"]) {
        return @"id";
    }
    NSString *propertyName = [property underscore];
    return propertyName;
}

- (NSString *)JSONIdRefPropertyForProperty:(NSString *)property {
    if(property.isSingular) {
        return [property.underscore stringByAppendingString:@"_id"];
    } else {
        return [property.singularize.underscore stringByAppendingString:@"_ids"];
    }
}

- (NSString *)classForJSONProperty:(NSString *)property {
    if([property hasSuffix:@"_id"]) {
        property = [property substringToIndex:property.length-3];
    } else if ([property hasSuffix:@"_ids"]) {
        property = [property substringToIndex:property.length-4];
    }
    
    if(property.isPlural) {
        property = [property singularize];
    }
    return [[property tableize] classify];
}

- (BOOL) isIdRefProperty:(NSString*)property {
    return [property hasSuffix:@"_id"] || [property hasSuffix:@"_ids"];
}

- (NSString*) idProperty {
    return @"identifier";
}

- (NSString *)JSONIdProperty {
    return @"id";
}

- (BOOL) isIdProperty:(NSString*)property {
    return [self.idProperty isEqualToString:property];
}

- (BOOL) isJSONIdProperty:(NSString*)property {
    return [self.idProperty isEqualToString:property];
}

@end
