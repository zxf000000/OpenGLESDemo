//
//  OpenGLES3_4ViewController.m
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/29.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import "OpenGLES3_4ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AEAGLContext.h"

@interface OpenGLES3_4ViewController ()

@property (strong, nonatomic) GLKBaseEffect  *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer  *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo  *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo  *textureInfo1;



@end

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}
ScenceVertex;

static const ScenceVertex vertices[] = {
    {{-1.0, -0.67, 0.0},{0.0, 0.0}},    // 第一个三角形
    {{1.0, -0.67, 0.0},{1.0, 0.0}},
    {{-1.0, 0.67, 0.0},{0.0, 1.0}},
    {{1.0, -0.67, 0.0},{1.0, 0.0}},     // 第二个三角形
    {{-1.0, 0.67, 0.0},{0.0, 1.0}},
    {{1.0, 0.67, 0.0},{1.0, 1.0}}
};

@implementation OpenGLES3_4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[AEAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [AEAGLContext setCurrentContext:view.context];
    
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    ((AEAGLContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(ScenceVertex) numberOfVertices:sizeof(vertices)/sizeof(ScenceVertex) data:vertices usage:GL_STATIC_DRAW];
    {
      // 这段代码设置两个纹理到baseEffect, 并且设置模式为GLKTextureEnvModeDecal, 运行看效果
    CGImageRef image0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:image0 options:@{GLKTextureLoaderOriginBottomLeft: @(YES)} error:NULL];
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    
    CGImageRef image1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:image1 options:@{GLKTextureLoaderOriginBottomLeft: @(YES)} error:NULL];
    self.baseEffect.texture2d1.name = self.textureInfo1.name;
    self.baseEffect.texture2d1.target = self.textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
        //GLKTextureEnvModeModulate 混合颜色和形状
        // GLKTextureEnvModeReplace 替换颜色和形状
        // GLKTextureEnvModeDecal 混合形状替换颜色
    
    }
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [((AEAGLContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(ScenceVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(ScenceVertex, textureCoords) shouldEnable:YES];
    
     [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(ScenceVertex, textureCoords) shouldEnable:YES];
 
// 注释的代码用于简单的叠加两张图片
//    self.baseEffect.texture2d0.name = self.textureInfo0.name;
//    self.baseEffect.texture2d0.target = self.textureInfo0.target;
//    [self.baseEffect prepareToDraw];
//    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(ScenceVertex)];
//
//
//    self.baseEffect.texture2d0.name = self.textureInfo1.name;
//    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(ScenceVertex)];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
