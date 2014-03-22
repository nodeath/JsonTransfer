//
//  JSONNode.h
//  JsonTransfer
//
//  Created by Shawn Hung on 3/18/14.
//  Copyright (c) 2014 Shawn Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONNode : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *menuCode;
@property (strong, nonatomic) JSONNode *parent;
@property (strong, nonatomic) NSMutableArray *children;

-(NSDictionary *)toDictionary;

@end
