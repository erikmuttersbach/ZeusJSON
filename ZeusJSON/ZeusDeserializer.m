//
//  ZeusDeserializer.m
//  ZeusJSON
//
//  Created by Erik Muttersbach on 14/03/14.
//  Copyright (c) 2014 Pablo Guide UG. All rights reserved.
//

#import "ZeusDeserializer.h"

#import <MYSRuntime/MYSClass.h>
#import <MYSRuntime/MYSProperty.h>
#import <MYSRuntime/MYSType.h>

#import "ZeusValueTransformer.h"
#import "NSObject+Zeus.h"

#define REF_KEY(className, id)  [NSString stringWithFormat:@"%@:%@", className, id]

@interface ZeusDeserializer ()
@property (nonatomic, strong) NSMutableDictionary *references;
@end

@implementation ZeusDeserializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.references = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSObject *)deserialize {
    // deserialize root object
    NSString *rootPropertyName = [self.namingStrategy JSONPropertyForClass:NSStringFromClass(self.klass)];
    if(!self.json[rootPropertyName]) {
        DDLogError(@"Property '%@' missing", rootPropertyName);
        return nil;
    }
    
    NSObject *root = [self deserialize:self.json[rootPropertyName] JSONProperty:rootPropertyName withTargetClass:self.klass];
    
    // deserialize the remaining sideloaded objects, which
    // might have been referenced by id
    for(NSString *jsonPropertyName in self.json.allKeys) {
        if([jsonPropertyName isEqualToString:rootPropertyName]) {
            continue;
        }
        
        // TODO check if really array
        [self deserializeArray:self.json[jsonPropertyName] forJSONProperty:jsonPropertyName];
        
    }
    
    return root;
}

/**
 * Deserializes an NSString, NSNumber, NSDictionary from a decoded JSON object
 * to a specific target class.
 *
 * The target class will be determined if not set.
 *
 */
- (NSObject*) deserialize:(NSObject*)jsonObject JSONProperty:(NSString*)jsonPropertyName withTargetClass:(Class)klass {
    assert(![jsonObject isKindOfClass:NSArray.class]);
    
    if(!klass) {
        klass = NSClassFromString([self.namingStrategy classForJSONProperty:jsonPropertyName]);
    }
    
    // if the object is already of the class or a subclass,
    // nothing has to be done. usualy happens for NSNumber, NSString, NSDictionary etc.
    if([jsonObject.class isSubclassOfClass:klass]) {
        return jsonObject;
    }
    
    // if there is a value transformer to convert the json object/string/number to a model
    // object, we don't actually care about the target type and let the transformer do the magic
    else if([self.valueTransformer canTransform:[jsonObject class] to:klass]) {
        return [self.valueTransformer transform:jsonObject to:klass];
    }
    
    // if no converter was found and the object is a dictionary, deserialize it
    // to a model object
    else if([jsonObject.class isSubclassOfClass:NSDictionary.class]) {
        return [self deserializeDictionary:(NSDictionary*)jsonObject withTargetClass:klass];
    }
    else {
        DDLogError(@"Cannot deserialize %@ for JSON property %@ with target class %@", jsonObject.className, jsonPropertyName, klass);
        return nil;
    }
}

- (NSObject*) deserializeDictionary:(NSDictionary*)jsonObject withTargetClass:(Class)klass {
    NSObject *obj = [[klass alloc] init];
    
    NSArray *properties = [[[MYSClass alloc] initWithClass:klass] properties];
    properties = [properties sortedArrayUsingComparator:^NSComparisonResult(MYSProperty *obj1, MYSProperty *obj2) {
        if([obj1.name isEqualToString:@"identifier"]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    for (MYSProperty *property in properties) {
        if(property.isReadOnly) {
            continue;
        }
        
        Class propertyClass = NSClassFromString(property.type.tag);
        if(!propertyClass) {
            // if the type implements a protocol, strip it, e.g.
            // the tag is then MyModel<MyProtocol>
            NSArray *components = [property.type.tag componentsSeparatedByString:@"<"];
            if(components.count) {
                propertyClass = NSClassFromString(components[0]);
            }
        }
        
        if(!propertyClass) {
            DDLogError(@"Could not determine class of property %@", property.name);
            return nil;
        }
        
        // check if we are deserializing an embedded or side-loaded
        // property
        NSString *jsonPropertyName = [self.namingStrategy JSONPropertyForProperty:property.name];
        if(!jsonObject[jsonPropertyName]) {
            jsonPropertyName = [self.namingStrategy JSONIdRefPropertyForProperty:property.name];
            if(!jsonObject[jsonPropertyName]) {
                continue;
            }
        }
        
        if([propertyClass isSubclassOfClass:NSArray.class]) {
            // make sure that the JSON contains an array of objects
            if(![jsonObject[jsonPropertyName] isKindOfClass:[NSArray class]]) {
                DDLogError(@"Expected property %@ in JSON to be an array, but is %@", jsonPropertyName, NSStringFromClass([jsonObject[jsonPropertyName] class]));
                continue;
            }
            
            NSArray *array = [self deserializeArray:(NSArray*)jsonObject[jsonPropertyName] forJSONProperty:jsonPropertyName];
            [obj setValue:array forKey:property.name];
        } else {
            NSObject *value = nil;
            if([self.namingStrategy isIdRefProperty:jsonPropertyName]) {
                NSNumber *identifier = (NSNumber*)[self.valueTransformer transform:jsonObject[jsonPropertyName] to:NSNumber.class];
                value = [self referencedObjectWithClass:propertyClass andId:identifier];
            } else {
                value = [self deserialize:jsonObject[jsonPropertyName] JSONProperty:jsonPropertyName withTargetClass:NSClassFromString(property.type.tag)];
            }
            
            // if we just encountered an object with an id we'll replace obj
            // with the factory provided object, because it might have been referenced already some
            // where.
            // this is no problem regarding loss of other deserialized properties, because we orderd
            // the propertes array such that identifier is at the top. thus, no properties before the
            // id could have been written.
            if([self.namingStrategy isIdProperty:property.name]) {
                obj = [self referencedObjectWithClass:klass andId:(NSNumber*)value];
            }
            [obj setValue:value forKey:property.name];
        }
    }
    
    return obj;
}

- (NSArray*)deserializeArray:(NSArray*)jsonArray forJSONProperty:(NSString*)jsonPropertyName {
    // check if we can find out a target type
    Class arrayElementClass = NSClassFromString([self.namingStrategy classForJSONProperty:jsonPropertyName]);
    if(!arrayElementClass) {
        // guess the type
        if(jsonArray.count) {
            if([[jsonArray[0] class] isSubclassOfClass:[NSNumber class]]) {
                arrayElementClass = [NSNumber class];
            } else if([[jsonArray[0] class] isSubclassOfClass:[NSString class]]) {
                arrayElementClass = [NSString class];
            }
        }
    }
    if(!arrayElementClass) {
        // TODO enable
        DDLogError(@"Could not determine class for element of JSON property %@", jsonPropertyName);
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSUInteger i=0; i<jsonArray.count; i++) {
        NSObject *element = nil;
        
        if([self.namingStrategy isIdRefProperty:jsonPropertyName]) {
            NSNumber *identifier = (NSNumber*)[self.valueTransformer transform:jsonArray[i] to:NSNumber.class];
            element = [self referencedObjectWithClass:arrayElementClass andId:identifier];
        } else {
            element = [self deserialize:jsonArray[i] JSONProperty:nil withTargetClass:arrayElementClass];
        }
        
        if(element) {
            [array addObject:element];
        }
    }
    
    return array;
}

- (NSObject*) referencedObjectWithClass:(Class)klass andId:(NSNumber*)identifier {
    NSString *key = REF_KEY(klass, identifier);
    if(!self.references[key]) {
        self.references[key] = [[klass alloc] init];
    }
    return self.references[key];
}

@end
