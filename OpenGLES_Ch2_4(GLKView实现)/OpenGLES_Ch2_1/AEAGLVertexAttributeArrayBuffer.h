//
// Created by 云舟02 on 2018-12-29.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@interface AEAGLVertexAttributeArrayBuffer : NSObject

@property(nonatomic, assign) GLsizeiptr stride;
@property(nonatomic, assign) GLsizeiptr bufferSizeBytes;

@property(nonatomic, assign) GLuint glName;

- (instancetype)initWithAttribStride:(GLsizeiptr)stride
                    numberOfVertices:(GLsizei)count
                                data:(const GLvoid*)offset
                               usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCooradinate:(GLuint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLuint)first
         numberOfVertices:(GLsizei)count;



@end