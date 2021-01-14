//
//  NSMutableArray+Exchange.m
//  tools
//
//  Created by dong wu on 2021/1/14.
//  Copyright © 2021 dong wu. All rights reserved.
//

#import "NSMutableArray+Addobject.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Addobject)


- (void)doExchange
{
    Method addObject = class_getInstanceMethod([self class], @selector(addObject:));
    Method newAddObject = class_getInstanceMethod([self class], @selector(newAddObject:));
    method_exchangeImplementations(addObject, newAddObject);
}

- (void)newAddObject:(id)anObject
{
    if(anObject == nil)
    {
        [self newAddObject:[NSNull null]];
    }else
    {
        [self newAddObject:anObject];
    }
}

@end

