//
// Created by 云舟02 on 2018-12-27.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
@class EAGLContext;
@protocol AGLKViewDelegate;

@interface AGLKView : UIView {
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
}

@property(nonatomic, weak) id<AGLKViewDelegate> delegate;
@property(nonatomic, strong) EAGLContext *context;
@property (nonatomic, readonly, assign) NSInteger drawableWidth;
@property (nonatomic, readonly, assign) NSInteger drawableHeight;

- (void)display;


@end


@protocol AGLKViewDelegate<NSObject>

@required

- (void)aglkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end