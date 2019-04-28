//
// Created by mr.zhou on 2019-04-28.
// Copyright (c) 2019 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end