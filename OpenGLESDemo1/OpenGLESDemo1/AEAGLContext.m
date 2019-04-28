//
//  AEAGLContext.m
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/28.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import "AEAGLContext.h"

@implementation AEAGLContext

- (void)setClearColor:(GLKVector4)clearColor {
    _clearColor = clearColor;
    NSAssert(self == [[self class] currentContext], @"Recieving context require to be a currentContext");
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLbitfield)mask {
    NSAssert(self == [[self class] currentContext], @"Recieving context require to be a currentContext");
    
    glClear(mask);
}

@end
