//
//  ViewController.m
//  OpenGLESDemo1
//
//  Created by mr.zhou on 2019/4/28.
//  Copyright © 2019 mr.zhou. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AEAGLContext.h"
#import "GLKEffectPropertyTexture+AGLKAdditions.h"

@interface ViewController () {
    GLuint vertexBufferID;
}
@property(strong, nonatomic) GLKBaseEffect *baseEffect;
@property(nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property(nonatomic, assign) BOOL shouldRepeatTexture;
@property(nonatomic, assign) BOOL shouldUseLinearFilter;

@property(nonatomic, assign) BOOL shouldAnimate;

@property(nonatomic, assign) GLfloat sCoordinateOffset;
@end

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SenceVertex;


static SenceVertex vertices[] = {
        {{-0.5, -0.5, 0.0}, {0.0, 0.0}},
        {{-0.5, 0.5, 0.0}, {1.0, 1.0}},
        {{0.5, -0.5, 0}, {0.0, 1.0}},
};

static const SenceVertex defaultVertices[] = {
        {{-0.5, -0.5, 0.0f}, {0.0f, 0.0f}},
        {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
        {{-0.5f, 0.5f, 0.0f}, {0.0f, 1.0f}}
};

static GLKVector3 movementVectors[3] = {
        {-0.02, -0.01, 0.0},
        {0.01, -0.005, 0.0f},
        {-0.01, 0.01, 0.0}
};

@implementation ViewController

- (void)updateTextureParmenters {
    [self.baseEffect.texture2d0
            aglkSetParameter:GL_TEXTURE_WRAP_S
                       value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE)];

    [self.baseEffect.texture2d0
            aglkSetParameter:GL_TEXTURE_MAG_FILTER
                       value:self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST];
}

- (void)updateAnimatedVertexPosition {
    if (self.shouldAnimate) {
        int i;
        for (i = 0; i < 3; ++i) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x >= 1.f || vertices[i].positionCoords.x <= -1.f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >= 1.f || vertices[i].positionCoords.y <= -1.f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices->positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >= 1.f ||
                    vertices[i].positionCoords.z <= -1.f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }

    {
        int i;
        for (i = 0; i < 3; ++i) {
            vertices[i].textureCoords.s = defaultVertices[i].textureCoords.s + _sCoordinateOffset;
        }
    }
}

- (void)update {
    [self updateAnimatedVertexPosition];
    [self updateTextureParmenters];

    [_vertexBuffer reinitWithAttribStride:sizeof(SenceVertex)
                         numberOfVertices:sizeof(vertices)/ sizeof(SenceVertex)
                                    bytes:vertices];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *) self.view;
    view.context = [[AEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AEAGLContext setCurrentContext:view.context];

    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);


    ((AEAGLContext *) view.context).clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SenceVertex)
                                                                 numberOfVertices:sizeof(vertices) / sizeof(SenceVertex)
                                                                             data:vertices
                                                                            usage:GL_STATIC_DRAW];
    CGImageRef image = [[UIImage imageNamed:@"grid.png"] CGImage];
    // 创建一个包含image 的纹理缓存
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image
                                                               options:nil
                                                                 error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    [self.baseEffect prepareToDraw];

    [((AEAGLContext *) view.context) clear:GL_COLOR_BUFFER_BIT];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SenceVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SenceVertex, textureCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];

}

- (void)dealloc {
    GLKView *view = (GLKView *) self.view;
    [EAGLContext setCurrentContext:view.context];

    if (vertexBufferID != 0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    view.context = nil;
    [EAGLContext setCurrentContext:nil];

}
- (IBAction)slide:(UISlider *)sender {
    self.sCoordinateOffset = [sender value];
}

- (IBAction)switch1:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (IBAction)slide2:(UISwitch *)sender {
    self.shouldAnimate = sender.on;
    
}
- (IBAction)slide3:(UISwitch *)sender {
    self.shouldUseLinearFilter = sender.isOn;
}

@end
