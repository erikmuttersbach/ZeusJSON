//
//  ZeusNamingStrategyTests.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 17/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ZeusNamingStrategy.h"

@interface ZeusNamingStrategyTests : XCTestCase
@property (nonatomic, strong) ZeusNamingStrategy *strategy;
@end

@implementation ZeusNamingStrategyTests

- (void)setUp
{
    [super setUp];

    self.strategy = [[ZeusNamingStrategy alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIdRef
{
    XCTAssertTrue([[self.strategy JSONIdRefPropertyForProperty:@"visitorClasses"] isEqualToString:@"visitor_class_ids"]);
    
    XCTAssertTrue([[self.strategy JSONIdRefPropertyForProperty:@"rooms"] isEqualToString:@"room_ids"]);
    XCTAssertTrue([[self.strategy JSONIdRefPropertyForProperty:@"room"] isEqualToString:@"room_id"]);
}

- (void) testClassForJSONProperty {
    XCTAssertTrue([[self.strategy classForJSONProperty:@"visitor_class_ids"] isEqualToString:@"VisitorClass"]);
    XCTAssertTrue([[self.strategy classForJSONProperty:@"visitor_class_id"] isEqualToString:@"VisitorClass"]);
    
    XCTAssertTrue([[self.strategy classForJSONProperty:@"room_id"] isEqualToString:@"Room"]);
    XCTAssertTrue([[self.strategy classForJSONProperty:@"room_ids"] isEqualToString:@"Room"]);
    
}

@end
