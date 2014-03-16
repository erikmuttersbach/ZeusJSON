//
//  Order.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 15/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSMutableArray *numbers;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *names;

@end
