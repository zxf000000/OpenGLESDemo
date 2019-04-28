//
//  AEAGLContext.h
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/28.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import <GLKit/GLKit.h>



@interface AEAGLContext : EAGLContext


@property (nonatomic, assign) GLKVector4 clearColor;


- (void)clear:(GLbitfield)mask;

@end






