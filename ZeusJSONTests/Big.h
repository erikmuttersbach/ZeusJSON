//
//  Big.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 16/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Big : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSUUID *uuid;

@end
