//
//  OpenGLES_Ch2_1ViewController.m
//  OpenGLES_Ch2_1
//

#import "OpenGLES_Ch2_1ViewController.h"

@implementation OpenGLES_Ch2_1ViewController

@synthesize baseEffect;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
   GLKVector3  positionCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] = 
{
   {{-0.5f, -0.5f, 0.0}}, // lower left corner
   {{ 0.5f, -0.5f, 0.0}}, // lower right corner
   {{-0.5f,  0.5f, 0.0}}  // upper left corner
};


/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Verify the type of view created automatically by the
   // Interface Builder storyboard
   GLKView *view = (GLKView *)self.view;
   NSAssert([view isKindOfClass:[GLKView class]],
      @"View controller's view is not a GLKView");
   
   // Create an OpenGL ES 2.0 context and provide it to the
   // view
   view.context = [[EAGLContext alloc] 
      initWithAPI:kEAGLRenderingAPIOpenGLES2];
   
   // Make the new context current
   [EAGLContext setCurrentContext:view.context];
   
   // Create a base effect that provides standard OpenGL ES 2.0
   // Shading Language programs and set constants to be used for 
   // all subsequent rendering
    //GLKBaseEffect 类提供了不依赖于所使用的 OpenGL ES 版本的控制 OpenGL ES 渲染的方法
   self.baseEffect = [[GLKBaseEffect alloc] init];
   self.baseEffect.useConstantColor = GL_TRUE;
   self.baseEffect.constantColor = GLKVector4Make(
      0.0f, // Red
      1.0f, // Green
      1.0f, // Blue
      1.0f);// Alpha
   //设置当前 OpenGL ES 的上下文的“清除颜色”为不透明黑色
   // Set the background color stored in the current context 
   glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color
   
   // Generate, bind, and initialize contents of a buffer to be 
   // stored in GPU memory
    //标识符被生成,并保存在 vertexBufferID 实例变量中
   glGenBuffers(1,                // STEP 1
      &vertexBufferID);
    //绑定用于指定标识符的缓存到当前缓存
   glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
      vertexBufferID); 
   glBufferData(                  // STEP 3
      GL_ARRAY_BUFFER,  // Initialize buffer contents 用于指定要更新当前上下文中所绑定的是哪一个缓 存
      sizeof(vertices), // Number of bytes to copy 要复制进这个缓存的字节的数量
      vertices,         // Address of bytes to copy 要复制的字节的地 址
      GL_STATIC_DRAW);  // Hint: cache in GPU memory 提示了缓存在未来的运算中可能将会被怎样使用
}


/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
   
   // Clear Frame Buffer (erase previous drawing)
   glClear(GL_COLOR_BUFFER_BIT);
   
   // Enable use of positions from bound vertex buffer
    //通过调用 glEnableVertexAttrib-Array() 来启动顶点缓存渲染操作
   glEnableVertexAttribArray(      // STEP 4
      GLKVertexAttribPosition);
      
   glVertexAttribPointer(          // STEP 5
      GLKVertexAttribPosition, //第一个参 数指示当前绑定的缓存包含每个顶点的位置信息
      3,                   // three components per vertex 第二个参数指示每个位置有 3 个部分。
      GL_FLOAT,            // data is floating point    第三个参数告诉 OpenGL ES 每个部分都保存为一个浮点类型的值。
      GL_FALSE,            // no fixed point scaling    第四个参数告 诉 OpenGL ES 小数点固定数据是否可以被改变。
      sizeof(SceneVertex), // no gaps in data   第五个参数叫做“步幅”,它指定了每个顶点的保存需要多少个字节。换句话说,\
                                步幅指定了 GPU 从一个顶点的内存开始位置转到下一个顶点的内存开始位置需要跳过 多少字节。
      NULL);               // NULL tells GPU to start at 最后一个参数是 NULL,这告诉 OpenGL ES 可以从当前 \
                                绑定的顶点缓存的开始位置访问顶点数据。
                           // beginning of bound buffer
                                   
   // Draw triangles using the first three vertices in the 
   // currently bound vertex buffer
    //第一个参数 会告诉 GPU 怎么处理在绑定的顶点缓存内的顶点数据
    //第二个参数和第三个参数分别指定缓存内的需要渲染的 第一个顶点的位置和需要渲染的顶点的数量
   glDrawArrays(GL_TRIANGLES,      // STEP 6
      0,  // Start with first vertex in currently bound buffer
      3); // Use three vertices from currently bound buffer
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view 
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [EAGLContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   if (0 != vertexBufferID)
   {
      glDeleteBuffers (1,          // STEP 7 
                       &vertexBufferID);  
      vertexBufferID = 0;
   }
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}

@end
