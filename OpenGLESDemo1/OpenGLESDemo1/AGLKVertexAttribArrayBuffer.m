//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/28.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@implementation AGLKVertexAttribArrayBuffer

- (instancetype)initWithAttribStride:(GLsizeiptr)stride
                    numberOfVertices:(GLsizei)count
                                data:(const GLvoid *)dataPtr
                               usage:(GLenum)usage {
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(dataPtr != NULL);
    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = stride * count;
        glGenBuffers(1, &_glName);
        glBindBuffer(GL_ARRAY_BUFFER, _glName);

        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);
        NSAssert(_glName != 0, @"fail to gen glName");
    }
    return self;

}


- (void)reinitWithAttribStride:(GLsizeiptr)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr {
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(dataPtr != NULL);
    NSAssert(_glName != 0, @"invalid name");

    self.stride = stride;
    self.bufferSizeBytes = stride * count;
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLuint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable {
    NSAssert(count > 0 && count < 4, @"");
    NSParameterAssert(offset < _stride);
    NSAssert(_glName != 0, @"invalid glName");
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, _stride, NULL + offset);

}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count {
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride, @"attempt to draw more vertex data than available");

    glDrawArrays(mode, first, count);
}

- (void)dealloc {
    if (self.glName != 0) {
        glDeleteBuffers(1, &_glName);
        _glName = 0;
    }
}


@end
