//
// Created by 云舟02 on 2018-12-29.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>


@interface AGLKContext : EAGLContext

@property(nonatomic, assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;

@end