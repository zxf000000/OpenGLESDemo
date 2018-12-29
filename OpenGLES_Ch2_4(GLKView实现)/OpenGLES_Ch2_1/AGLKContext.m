//
// Created by 云舟02 on 2018-12-29.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "AGLKContext.h"


@implementation AGLKContext {

}

- (void)setClearColor:(GLKVector4)clearColor {

    _clearColor = clearColor;
    NSAssert([[self class] currentContext], @"Receiving context require to be current context");

    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLbitfield)mask {
    NSAssert([[self class] currentContext], @"Receiving context require to be current context");
    glClear(mask);
}
@end