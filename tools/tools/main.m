//
//  main.m
//  tools
//
//  Created by dong wu on 2021/1/14.
//  Copyright © 2021 dong wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Addobject.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSMutableArray *array = [NSMutableArray array];
        
        [array doExchange];
//        [array addObject:@"ddd"];
        

        
        NSMutableArray *array1 = [NSMutableArray array];
        
        [array1 addObject:nil];
        
        NSLog(@"23");
    }
    return 0;
}
