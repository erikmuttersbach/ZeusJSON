//
//  Room.h
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

@interface Room : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *persons;
@property (nonatomic, strong) Person *person;


@end
