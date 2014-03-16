//
//  NSObject+Zeus.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 15/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import "NSObject+Zeus.h"

@implementation NSObject (Zeus)

- (NSString*) className {
    return NSStringFromClass(self.class);
}

@end
