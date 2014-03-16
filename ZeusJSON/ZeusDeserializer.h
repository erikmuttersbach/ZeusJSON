//
//  ZeusDeserializer.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZeusNamingStrategy.h"
#import "ZeusValueTransformer.h"

@interface ZeusDeserializer : NSObject

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic) Class klass;
@property (nonatomic, strong) ZeusNamingStrategy *namingStrategy;
@property (nonatomic, strong) ZeusValueTransformer *valueTransformer;

- (NSObject*) deserialize;

@end
