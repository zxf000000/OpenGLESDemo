//
// Created by 云舟02 on 2018-12-27.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "AGLKView.h"


@implementation AGLKView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
        layer.drawableProperties = @{
                kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:NO],
                    kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
        };
        self.context = aContext;
    }
    return self;
}

- (void)display {
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableWidth); // 控制渲染至帧缓存的子集, 这里用的是整个缓存

    [self drawRect:self.bounds]; // 如果 delegate 不为nil, 哪么会调用 `glkView:drawInRect:`

    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if ([self.delegate respondsToSelector:@selector(aglkView:drawInRect:)]) {
        [self.delegate aglkView:self drawInRect:rect];
    }
}

- (void)layoutSubviews {
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);

    GLenum status = glCheckFramebufferStatus(GL_RENDERBUFFER);

    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"fail to make complete frame buffer object %x",status);
    }
}

- (NSInteger)drawableWidth {
    GLuint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return (NSInteger)backingWidth;
}

- (NSInteger)drawableHeight {
    GLuint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (NSInteger)backingHeight;
}

- (void)dealloc {
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}

@end