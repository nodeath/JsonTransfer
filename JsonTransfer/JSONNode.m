//
//  JSONNode.m
//  JsonTransfer
//
//  Created by Shawn Hung on 3/18/14.
//  Copyright (c) 2014 Shawn Hung. All rights reserved.
//

#import "JSONNode.h"

@implementation JSONNode
@synthesize name;
@synthesize code;
@synthesize menuCode;
@synthesize parent;
@synthesize children;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] init];
        self.name = @"";
        self.code = @"";
        self.menuCode = @"";
    }
    return self;
}

-(NSDictionary *)toDictionary{
    //NSLog(@"parsing:%@", self.name);
    NSMutableArray *childrenJson = [[NSMutableArray alloc] init];
    [self.children enumerateObjectsUsingBlock:^(JSONNode *child, NSUInteger idx, BOOL *stop) {
        [childrenJson addObject:[child toDictionary]];
    }];

    return @{@"name": self.name,
             @"code": self.code,
             @"menu_code": self.menuCode,
             @"children": ([childrenJson count] != 0) ? childrenJson : @""};
}

@end
