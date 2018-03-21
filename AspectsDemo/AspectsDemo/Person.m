//
//  Person.m
//  AspectsDemo
//
//  Created by lbq on 2018/3/21.
//  Copyright © 2018年 PSPDFKit GmbH. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)test1
{
    NSLog(@"test1");
}


- (void)test2
{
    NSLog(@"test2");
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"");
}

+ (BOOL) resolveInstanceMethod:(SEL)sel
{
    NSLog(@"%s",__func__);
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"%s",__func__);
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"%s",__func__);
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"%s",__func__);
    [super forwardInvocation:anInvocation];
}

@end
