//
// Created by mr.zhou on 2019-04-28.
// Copyright (c) 2019 mr.zhou. All rights reserved.
//

#import "GLKEffectPropertyTexture+AGLKAdditions.h"


@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value {
    glBindBuffer(self.target, self.name);
    glTexParameteri(self.target, parameterID, value);
}

@end