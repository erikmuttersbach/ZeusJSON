//
//  ZeusConverter.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 15/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZeusValueTransformer : NSObject

- (BOOL) canTransform:(Class)sourceClass to:(Class)targetClass;
- (NSObject*) transform:(NSObject*)source to:(Class)targetClass;

@end
