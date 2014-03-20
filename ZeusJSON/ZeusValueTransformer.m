//
//  ZeusConverter.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 15/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import "ZeusValueTransformer.h"

@interface ZeusValueTransformer ()
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation ZeusValueTransformer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (BOOL)canTransform:(Class)sourceClass to:(Class)targetClass {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"__%@From%@:", targetClass, sourceClass]);
    NSLog(@"%@", NSStringFromSelector(selector)); // TODO
    return [self respondsToSelector:selector];
}

- (NSObject*)transform:(NSObject*)source to:(Class)targetClass {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"__%@From%@:", targetClass, source.class]);
    return [self performSelector:selector withObject:source];
}

#pragma mark Transformations

- (NSNumber*)__NSNumberFromNSNull:(NSNull*)null {
    return nil;
}

- (NSNumber*)__NSNumberFrom__NSCFNumber:(NSNumber*)value {
    return value;
}

- (NSString*)__NSStringFrom__NSCFString:(NSString*)value {
    return value;
}

- (NSString*)__NSStringFromNSNull:(NSNull*)null {
    return nil;
}

- (NSURL*)__NSURLFrom__NSCFString:(NSString*)value {
    return [NSURL URLWithString:value];
}

- (NSUUID*)__NSUUIDFrom__NSCFString:(NSString*)value {
    return [[NSUUID alloc] initWithUUIDString:value];
}

@end
