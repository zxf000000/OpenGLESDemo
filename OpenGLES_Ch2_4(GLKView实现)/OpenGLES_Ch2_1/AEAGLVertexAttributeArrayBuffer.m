//
// Created by 云舟02 on 2018-12-29.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "AEAGLVertexAttributeArrayBuffer.h"


@implementation AEAGLVertexAttributeArrayBuffer {

}

- (instancetype)initWithAttribStride:(GLsizeiptr)stride
                    numberOfVertices:(GLsizei)count
                                data:(const GLvoid*)data
                               usage:(GLenum)usage {
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(data != NULL);

    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = count * stride;
        glGenBuffers(1, &_glName);
        glBindBuffer(GL_ARRAY_BUFFER, _glName);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, data, usage);
        NSAssert(_glName != 0, @"fail to generate glName");
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCooradinate:(GLuint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable {

    NSParameterAssert((count > 0) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(self.glName > 0, @"invalide glName!");

    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }

    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);

}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLuint)first
         numberOfVertices:(GLsizei)count {

    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride), @"attemp to draw more vertex data than available");
    glDrawArrays(mode, first, count);
}

- (void)dealloc {
    if (_glName != 0) {
        glDeleteBuffers(1, &_glName);
        _glName = 0;
    }
}


@end