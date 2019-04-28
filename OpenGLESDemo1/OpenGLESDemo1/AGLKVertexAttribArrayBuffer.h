//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/28.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import <GLKit/GLKit.h>



@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, assign) GLuint glName;
@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property(nonatomic, assign) GLsizeiptr stride;

- (instancetype)initWithAttribStride:(GLsizeiptr)stride
                    numberOfVertices:(GLsizei)count
                                data:(const GLvoid *)dataPtr
                               usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLuint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizeiptr)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

@end


