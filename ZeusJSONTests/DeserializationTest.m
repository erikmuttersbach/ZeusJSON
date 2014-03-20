//
//  ArrayDeserializationTest.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 15/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ZeusJSON.h"

#import "Order.h"
#import "Item.h"
#import "Room.h"
#import "Person.h"
#import "Primitive.h"
#import "Big.h"

@interface DeserializationTest : XCTestCase
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation DeserializationTest

- (void)setUp
{
    [super setUp];
    
    self.bundle = [NSBundle bundleForClass:[self class]];
    
}

#pragma mark Array Deserialization

- (void)testImmutableArray {
    NSData *json = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"ArrayDeserializationImmutable" ofType:@"json"]];
    Room *room = (Room*)[ZeusJSON deserializeJSONToObject:json withClass:[Room class]];
    
    XCTAssert(room.persons.count == 2);
    XCTAssert([((Person*)room.persons[0]).name isEqualToString:@"Foo"]);
    XCTAssert([((Person*)room.persons[1]).name isEqualToString:@"Bar"]);
}

- (void)testMutableArray {
    NSData *json = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"ArrayDeserializationMutable" ofType:@"json"]];
    Order *order = (Order*)[ZeusJSON deserializeJSONToObject:json withClass:[Order class]];
    
    XCTAssert([order.numbers isKindOfClass:[NSMutableArray class]]);
    XCTAssert(order.numbers.count == 2);
    XCTAssert([order.numbers[0] isEqualToNumber:@1]);
    XCTAssert([order.numbers[1] isEqualToNumber:@10]);
    
    XCTAssert(order.items.count == 2);
    XCTAssert([((Item*)order.items[0]).name isEqualToString:@"foo"]);
    XCTAssert([((Item*)order.items[1]).name isEqualToString:@"bar"]);
    
    XCTAssert(order.names.count == 2);
    XCTAssert([order.names[0] isEqualToString:@"hello"]);
    XCTAssert([order.names[1] isEqualToString:@"world"]);
}

#pragma mark Id References

- (void)testIdModel {
    NSDictionary *model = @{@"room": @{
                                    @"person_id": @10
                                    },
                            @"persons": @[
                                    @{@"id": @10, @"name": @"Hinz"},
                                    ]
                            };
    NSData *json = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
    Room *room = (Room*)[ZeusJSON deserializeJSONToObject:json withClass:[Room class]];
    
    XCTAssert([room.person.name isEqualToString:@"Hinz"]);
    
}

- (void)testIdCollection {
    NSDictionary *model = @{@"room": @{
                                @"person_ids": @[@1, @2]
                            },
                            @"persons": @[
                                @{@"name": @"Hinz", @"id": @1},
                                @{@"name": @"Kunz", @"id": @2}
                            ]
                          };
    NSData *json = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
    Room *room = (Room*)[ZeusJSON deserializeJSONToObject:json withClass:[Room class]];
    
    XCTAssert(room.persons.count == 2);
    XCTAssert([[room.persons[0] name] isEqualToString:@"Hinz"]);
    XCTAssert([[room.persons[1] name] isEqualToString:@"Kunz"]);
}

#pragma mark Built-in Transformations

- (void) testDeserializeUrl {
    NSDictionary *model = @{@"big": @{
                                    @"url": @"http://example.com"
                                    }
                            };
    NSData *json = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
    Big *big = (Big*)[ZeusJSON deserializeJSONToObject:json withClass:[Big class]];
    
    XCTAssert([big.url.absoluteString isEqualToString:@"http://example.com"]);
}

- (void) testDeserializeUUID {
    NSDictionary *model = @{@"big": @{
                                    @"uuid": @"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"
                                    }
                            };
    NSData *json = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
    Big *big = (Big*)[ZeusJSON deserializeJSONToObject:json withClass:[Big class]];
    
    XCTAssert([big.uuid.UUIDString isEqualToString:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"]);
}

- (void) testPrimitives {
    NSDictionary *model = @{@"primitive": @{
                                @"unsigned_integer": @(22),
                                @"integer": @(-123),
                                @"d": @1.234,
                                @"f": @(-12.12),
                                @"b": @(true)
                            }
                           };
    NSData *json = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [NSString stringWithCString:json.bytes encoding:NSUTF8StringEncoding];
    Primitive *primitive = (Primitive*)[ZeusJSON deserializeJSONToObject:json withClass:[Primitive class]];

    XCTAssert(primitive.unsignedInteger == 22);
    XCTAssert(primitive.integer == -123);
    XCTAssert(primitive.d == 1.234);
    XCTAssertEqualWithAccuracy(primitive.f, -12.12, 0.1);
    XCTAssert(primitive.b == YES);
}

@end
