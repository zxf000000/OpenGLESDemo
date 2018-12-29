//
//  ViewController.m
//  OpenGLES_Ch2_1
//
//  Created by 云舟02 on 2018-12-27.
//  Copyright © 2018 云舟02. All rights reserved.
//

#import "ViewController.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
@interface ViewController ()
{
    GLuint vertexBufferID;
}

@property(nonatomic, strong) GLKBaseEffect *baseEffect;

@end
// 定义一个结构体,存储所有 vertex 的信息
typedef struct {
    GLKVector3 positionCoords;
} SenceVertex;

// 存储顶点信息
static const SenceVertex vertices[] = {
        {{-0.5, -0.5, 0}}, // 左下
        {{0.5, -0.5, 0}}, // 右下
        {{-0.5, 0.5, 0}} // 左上
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self begin];
}

- (void)begin {
    // 转换view 为GLKView
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"ViewController's View is Not a GLKView");
    // 创建上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置当前上下文
    [EAGLContext setCurrentContext:view.context];

    // 创建
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = YES;
    self.baseEffect.constantColor = GLKVector4Make(0.5, 0.0, 1.0, 1.0);
    // 背景颜色
    glClearColor(1.0, 1.0, 1.0, 1.f);
    // 创建buffer 绑定, 初始化
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    /**
     * 参数说明
     * 1. 初始化buffer contents
     * 2. 需要copy 的字节数
     * 3. 需要拷贝的数据地址
     * 4. 拷贝方式(cache in memory)
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];

    glClear(GL_COLOR_BUFFER_BIT);
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 启动顶点渲染操作

    glVertexAttribPointer(  // 告诉程序顶点数据在哪里, 以及怎么解释为顶点保存的数据
            GLKVertexAttribPosition, // 指示当前缓存数据包含每个顶点的位置信息
            3,   // 指示每个位置有三个部分
            GL_FLOAT, // 标识为每个部分保存一个浮点型的值
            GL_FALSE, // 小数点固定数据是否可以被改变
            sizeof(SenceVertex), // 步幅: 标识保存每个顶点信息需要多少字节;
            NULL); // 可以从当前绑定的顶点缓存的位置访问顶点数据

    glDrawArrays(GL_TRIANGLES, // 怎么处理绑定在顶点的数据
            0, // 第一个顶点的位置
            3); // 需要渲染的顶点的数量
}

- (void)viewDidUnload {
    [super viewDidUnload];
    GLKView *view = (GLKView *)self.view;
    // 创建上下文
    [EAGLContext setCurrentContext:view.context];
    if (vertexBufferID != 0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}


@end
#pragma clang diagnostic pop