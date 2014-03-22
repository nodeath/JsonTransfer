//
//  main.m
//  JsonTransfer
//
//  Created by Shawn Hung on 3/18/14.
//  Copyright (c) 2014 Shawn Hung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONNode.h"
#define FILE_PATH @"work_mode"
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSURL *url = [[NSBundle mainBundle] URLForResource:FILE_PATH withExtension:@"js"];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        NSDictionary *jobMode = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if(error != nil){
            NSLog(@"%@",error);
        }

        JSONNode *root = [[JSONNode alloc] init];
        root.name = [jobMode objectForKey:@"showName"];
        NSArray *jobElements = [jobMode objectForKey:@"listObj"];

        [jobElements enumerateObjectsUsingBlock:^(NSDictionary *jobElement, NSUInteger idx, BOOL *stop) {
            JSONNode *node = [[JSONNode alloc] init];
            __block JSONNode *parent = nil;
            NSString *name = [jobElement objectForKey:@"level_3_name"];
            if(name.length == 0){
                name = [jobElement objectForKey:@"level_2_name"];
                if(name.length == 0){
                    node.name = [jobElement objectForKey:@"level_1_name"];
                    parent = root;
                } else {
                    node.name = name;
                    NSArray *firstGenerationChildren = root.children;
                    NSString *parentName = [jobElement objectForKey:@"level_1_name"];
                    [firstGenerationChildren enumerateObjectsUsingBlock:^(JSONNode *child, NSUInteger idx, BOOL *stop) {
                        if([child.name isEqualToString:parentName]){
                            parent = child;
                            *stop = YES;
                        }
                    }];

                    if(parent == nil){
                        parent = [[JSONNode alloc] init];
                        parent.name = parentName;
                        parent.parent = root;
                        [root.children addObject:parent];
                    }
                }
            } else {
                node.name = name;
                __block JSONNode *grandParent = nil;
                NSArray *firstGenerationChildren = root.children;
                NSString *grandParentName = [jobElement objectForKey:@"level_1_name"];
                [firstGenerationChildren enumerateObjectsUsingBlock:^(JSONNode *child, NSUInteger idx, BOOL *stop) {
                    if([child.name isEqualToString:grandParentName]){
                        grandParent = child;
                        *stop = YES;
                    }
                }];

                if(grandParent == nil){
                    grandParent = [[JSONNode alloc] init];
                    grandParent.name = grandParentName;
                    grandParent.parent = root;
                    [root.children addObject:grandParent];
                }

                NSArray *secondGenerationChildren = grandParent.children;
                NSString *parentName = [jobElement objectForKey:@"level_2_name"];
                [secondGenerationChildren enumerateObjectsUsingBlock:^(JSONNode *child, NSUInteger idx, BOOL *stop) {
                    if([child.name isEqualToString:parentName]){
                        parent = child;
                        *stop = YES;
                    }
                }];

                if(parent == nil){
                    parent = [[JSONNode alloc] init];
                    parent.name = parentName;
                    parent.parent = grandParent;
                    [grandParent.children addObject:parent];
                }
            }

            node.code = [jobElement objectForKey:@"code"];
            node.menuCode = [jobElement objectForKey:@"menu_code"];
            node.parent = parent;
            [parent.children addObject:node];
        }];

        if([NSJSONSerialization isValidJSONObject:root]){
            NSLog(@"root:%@", [NSJSONSerialization dataWithJSONObject:root options:0 error:nil]);
        }

        NSData *data = [NSJSONSerialization dataWithJSONObject:[root toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        if(error){
            NSLog(@"%@", error);
        }

        NSString *string = [[[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newFile = [FILE_PATH stringByAppendingString:@"_new.js"];
        [string writeToURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:newFile] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    return 0;
}

