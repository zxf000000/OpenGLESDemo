# OpenGL ES 应用开发实践指南 iOS卷(2)

## 第二章 让硬件为你工作

### 2.1 使用 OpenGL ES 绘制一个 Core Animation 层

> 系统不会让应用直接向前帧缓存或者后帧缓存绘图,也不会让应用直接控制前帧缓存和后帧缓存之间的切换. 操作系统为自己保留了这些操作,以便随时可以使用Core Animation合成器来控制显示的最终外观.

Core Animation 包含层的概念. 同一时刻可以有任意数量的层. Core Animation 合成器会联合这些层,并在后帧缓存中产生最终的像素颜色.然后切换缓存.

下图为此过程: 

![](http://zhouxiaofei-image.oss-cn-hangzhou.aliyuncs.com/18-12-27/40394441.jpg)

一个应用提供的层和操作系统提供的层混合起来可以产生最终的显示外观.  

层会保存所有绘制操作的结果.  

帧缓存会保存 OpenGL ES 的渲染结果, 因此为了渲染到一个Core Animation 层上,程序需要一个链接到某一个层的帧缓存. 简言之,每个程序用足够的内存配置一个层来保存像素颜色数据, 之后创建一个使用层的内存来保存渲染的图像的帧缓存.

下图为 OpenGL ES 帧缓存与层之间的关心: 

![](http://zhouxiaofei-image.oss-cn-hangzhou.aliyuncs.com/18-12-27/22219158.jpg)

上图显示了一个像素颜色渲染缓存 (pixel color render buffer) 和另外两个标识为其他渲染缓存(color render buffer) 的缓存. 除了像素颜色数据, OpenGL ES 和GPU 有时会以渲染的副产品的形式产生一些有用的数据.  

与层分享数据的帧缓存必须要有一个像素颜色渲染缓存,其他的都是可选的.  

### 2.2 结合 Cocoa Touch

第一个示例应用  

#### 2.2.1 Cocoa Touch

#### 2.2.2 使用Apple 开发者工具

Xcode 运行在 Mac OS X 上面, 包含可识别语法的代码编辑器,编译器,调试器,性能工具,以及一个文件管理用户界面.

##### 2.2.3 Cocoa Touch 应用架构

![](http://zhouxiaofei-image.oss-cn-hangzhou.aliyuncs.com/18-12-27/68573139.jpg)

* UIApplication : 每个应用都包含单一的 UIApplication 类的实例.一个Objc Cocoa  Touch 对象,提供了应用与iOS 之间的双向通信. UIApplicaiton 与一个或者多个Cocoa Touch UIWindow 实例通信.还会与一个用于路由用户输入事件到正确的对象的委托(delegate)通信.
* 应用委托 (application delegate): 委托对象提供了一个响应另一个对象的变化或者影响另一个对象的行为的机会.基本思路是两个对象协调解决一个问题. 对象是非常常见的并可以在各种情况下重用的.它保存了一个对于另一个对象(他的委托)的引用.
* UIWindow : Cocoa Touch 应用总是有至少一个自动创建的覆盖整个屏幕的UIWindow 实例,UIWindow 实例控制屏幕的矩形区域, 并且他们能够被重叠和分层以便一个窗口覆盖另一个窗口,除了覆盖整个屏幕的窗口,Cocoa Touch应用很少直接访问窗口. Cocoa Touch 会按需自动使用其他的UIWindows 来向用户显示警告和状态信息.
* 根视图控制器: 每个窗口都有一个可选的根试图控制器. 试图控制器是Cocoa Touch UIViewController类的实例并把大部分iOS 的应用的设计联系起来.试图控制器会调节一个相关的试图的外观并支持在设备方向变化时旋转视图.根视图控制器指定填充了整个窗口的UIView 实例, UIViewController 类的默认行为控制了iOS 应用的标准可视化效果. GLKViewController 类是支持OpenGL ES特有行为和动画计时的内建子类.
* GLKView: 是 Cocoa Touch UIView 类的内建子类, GLKView 简化了通过用 CoreAnimation 层来自动创建并管理帧缓存和渲染缓存共享内存所需要做的工作.

### 2.3 代码
新建项目
#### 2.3.1 interface 修改

```objc
// .h
@interface ViewController : GLKViewController


@end

// .m
@interface ViewController ()
{
    GLuint vertexBufferID;
}

@property(nonatomic, strong) GLKBaseEffect *baseEffect;

@end
```

 `vertexBufferID` 变量保存了用于盛放本项目中用到的顶点数据的缓存和 OpenGL ES 标识符. `ViewController` 类的实现代码解释了缓存标识符的初始化和使用.
 
 `baseEffect` 属性声明了一个 `GLKBaseEffect`的实例的指针.
 
 ### 2.3.4 ViewController 类的实现
 
 实现三个方法: 
 
 ```objc
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

 ```
 
 暂时使用标准的访问器就够了,有特殊处理或者属性值得变化需要调用自定义应用逻辑的时候才需要显示的编写访问器.  
 
  定义一个结构体,用`GLKVector3`类型保存三个坐标 X, Y ,Z
  
  ```objc
  // 定义一个结构体,存储所有 vertex 的信息
typedef struct {
    GLKVector3 positionCoords;
} SenceVertex;

  ```
  
  用一个C 数组存储顶点数据: 
  
  ```objc
  
// 存储顶点信息
static const SenceVertex vertices[] = {
        {{-0.5, -0.5, 0}}, // 左下
        {{0.5, -0.5, 0}}, // 右下
        {{-0.5, 0.5, 0}} // 左上
};
  ```
  
  从左到右三个数值依次是 X, Y, Z 的值,
  
  ![](http://zhouxiaofei-image.oss-cn-hangzhou.aliyuncs.com/18-12-27/30893865.jpg)
  
  1. viewDidLoad

  在这个方法中为 OpenGL ES 提供三角形的顶点数据.  
  `setCurrentContext` 可以设置为当前使用的上下文  
  
  `initWithAPU:`方法声明了当前使用的 OpenGL ES 版本.  
  `baseEffect` 的属性设置  ,下面代码中使用一个恒定不变的白色来渲染三角形  
  `constantColor` 的赋值中定义的四个颜色元素值的C 数据结构体 GLKVector4 来设置这个恒定的颜色;  
  `glClearColor` 函数设置当前OpenGL ES 的上下文 '清除颜色"  
  缓存操作的前三个步骤见注释:
  
```objc
  - (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"ViewController's View is Not a GLKView");

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    [EAGLContext setCurrentContext:view.context];

    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = YES;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    // 背景颜色
    glClearColor(0.0, 0.0, 0.0, 1.f);
    // 创建buffer 绑定, 初始化
    // 生成一个唯一标识符
    glGenBuffers(1, &vertexBufferID); // 第一个参数: 生成缓存标识符的数量,2. 指针
    // 为接下来的运算绑定缓存,指定标识符缓存到当前缓存
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID); // 任意时刻每种类型智能绑定一个缓存.
    // 赋值数据到缓存中
        /**
     * 参数说明
     * 1. 初始化buffer contents
     * 2. 需要copy 的字节数
     * 3. 需要拷贝的数据地址
     * 4. 拷贝方式(cache in memory)
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);   
}
```
  
  `glBindBuffer` 第一个参数是常量,用于指定需要绑定哪一种类型的缓存. OpenGL ES 2 只支持2中类型`GL_ARRAY_BUFFER` 和`GL_ELEMENT_ARRAY_BUFFER` ,前者用于指定一个顶点属性数组.第二个参数是要绑定的缓存的标识符.  
  
  第三步中 `glBufferData` 函数复制应用顶点的数据到当前上下文, 参数:  
  第一个 指定更新上下文绑定的是哪一个缓存, 第二个 是这定要复制进这个缓存的字节的数量,第三个是地址,第四个是可能会被怎样使用
  
  2. -glkView: drawRect:
  
  每当一个GLKView 实例需要被重绘时, 都会让保存在试图的上下文属性中的 OpenGL ES 的上下文称为当前上下文. 如果需要的话, GLKView 实例会绑定与一个Core Animation 层分享的帧缓存,执行其他的标准OpenGL ES 配置,并发送一个消息来调用 glk: drawRect: 方法, 这个方法是 GLKView 的代理方法.
  
  **代码:**
  
```objc
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

```
帧缓存被清除之后,用存储在当前绑定的 OpenGL ES 的GL_ARRAY_BUFFER 类型的缓存中的顶点数据绘制三角形. 使用缓存的前三步已经在 `viewDidLoad` 中执行了, `glkView: drawRect:` 方法会执行剩下的几步: 
  
  * 启动
  * 设置指针
  * 绘图
  
> 小数点固定类型是 OpenGL ES 支持的对于浮点型的一种替代, 小数点固定类型用牺牲精度的方法来节省内存. 所有现代 GPU 都对浮点数的使用做了优化,并且小数点固定数据在使用之前最终都会被转换成浮点数,因此坚持的使用浮点数可以减少 GPU 的运算量并提高精度
  
  
3. `-viewDidUnload`  
	释放相关资源  
	
```objc
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
```

### 2.4 GLKView 是怎么工作的

#### 自定义一个AGLKView 模拟GLKView的工作过程


```objc
// .h
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
@class EAGLContext;
@protocol AGLKViewDelegate;

@interface AGLKView : UIView {
    EAGLContext *_context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLint drawableWidth;
    GLint drawableHeight;
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
```

```objc
// .m
@implementation AGLKView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}
@end
```

每一个UIView 都有一个相关联的被 Cocoa Touch 按需自动创建的 Core Animation 层. Cocoa Touch 会调用 `+layerClass` 方法来确定要创建什么类型的层.  

`CAEAGLLayer` 是 Core Animation 提供的标准层类之一, CAEAGLLayer 会与一个 OpenGL ES 的帧缓存共享他的像素颜色仓库.  

```objc
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

```

初始化的时候使用一个临时的 NSDictionary 实例来设置 eaglLayewr 的drawableProperties 属性.  

* `kEAGLDrawablePropertyRetainedBacking` 的值设置为 `NO` 
* `kEAGLDrawablePropertyColorFormat` 设置为 `kEAGLColorFormatRGBA8`  

不使用 **保留背景** 的意思是告诉 Core Animation 不要试图保留任何以前绘制的图像留作以后重用, 颜色格式 `RGBA8` 是 告诉 Core Animation 用8 位来保存层内的每个像素的每个颜色元素的值  

因为 AGLKView 需要创建和配置一个帧缓存和一个像素颜色渲染缓存来与视图 的 Core Animation 层一起使用,所以设置上下文会引起一些副作用. 由于上下文保存缓存,因此修改视图的上下文会导致先前创建的所有缓存全部失效,并需要创建和配置新的缓存.  

会受缓存操作影响的上下文实在调用 OpenGL ES 函数之前设定为当前上下文

下面的 `-display` 方法设置视图的上下文为当前上下文,告诉OpenGL ES 让渲染填满整个帧缓存, 调用View 的 `-drawRect:` 方法来实现用OpenGL ES 函数进行真正的绘图,然后让上下文调整外观并使用 Core Animation 合成器把帧缓存的像素颜色渲染缓存与其他相关层混合起来.

```objc

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

```

视图大小更改的时候,Cocoa Touch 调用下面的 `-layoutSubviews` 方法.  
视图附属的帧缓存和像素颜色缓存取决于视图的尺寸, 视图会自动调整相关层的尺寸. 上下文的 `-renderbufferStorage:fromDrawable:` 方法会调整视图的缓存的尺寸以匹配层的新尺寸.

```objc

- (void)layoutSubviews {
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);

    GLenum status = glCheckFramebufferStatus(GL_RENDERBUFFER);

    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"fail to make complete frame buffer object %x",status);
    }
}

```

`drawableWidth` 和 `drawableHeight` 被实现用来通过 OpenGL ES 的 `glGetRenderbufferParameteriv()` 方法 获取和放回当前上下文的帧缓存的像素颜色渲染缓存的尺寸.

```objc

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
```

`-dealloc` 方法中释放context

```objc
- (void)dealloc {
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}
```

GLKViewController 使用一个 Core Animation CADisplayLink 对象来调度和执行与控制器相关联的视图的周期性重绘. CADisplayLink 本质上是一个用于显示更新的同步计时器,它能够被设置用来在每个显示更新或者其他更新时发送一个消息. CADisplayLink 计时器的周期是以显示更新来计量的/  

显示更新频率通常是由嵌入设备的硬件决定的,它代表一个帧缓存的内容每秒组多能够被屏幕上通过的像素显示出来的次数. 因此来自CADisplayLink 的消息为重新渲染一个场景提供了理想的触发器. 渲染速度如果快于显示刷新频率就是一种浪费, 因为用户永远看不到两次刷新之间的额外的帧缓存的更新  

### 2.5 对于GLKit 的推断

GLKit 类封装并简化了 Cocoa Touch 应用和 OpenGL ES 之间的常见交互. 

上一个例子实现了: 

* 清除帧缓存
* 使用一个顶点 数组缓存来绘图	






  

  