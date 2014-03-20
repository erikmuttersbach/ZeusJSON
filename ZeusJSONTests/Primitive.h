//
//  Primitive.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 20/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Primitive : NSObject

@property (atomic) NSUInteger unsignedInteger;
@property (atomic) NSInteger integer;
@property (atomic) double d;
@property (atomic) float f;
@property (atomic) BOOL b;

@end
