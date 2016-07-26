//
//  GLKContext.m
//  
//

#import "AGLKContext.h"

@implementation AGLKContext

/////////////////////////////////////////////////////////////////
// This method sets the clear (background) RGBA color.
// The clear color is undefined until this method is called.
- (void)setClearColor:(GLKVector4)clearColorRGBA
{
   clearColor = clearColorRGBA;
   
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glClearColor(
      clearColorRGBA.r, 
      clearColorRGBA.g, 
      clearColorRGBA.b, 
      clearColorRGBA.a);
}


/////////////////////////////////////////////////////////////////
// Returns the clear (background) color set via -setClearColor:.
// If no clear color has been set via -setClearColor:, the 
// return clear color is undefined.
- (GLKVector4)clearColor
{
   return clearColor;
}


/////////////////////////////////////////////////////////////////
// This method instructs OpenGL ES to set all data in the
// current Context's Render Buffer(s) identified by mask to
// colors (values) specified via -setClearColor: and/or
// OpenGL ES functions for each Render Buffer type.
- (void)clear:(GLbitfield)mask
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glClear(mask);
}


/////////////////////////////////////////////////////////////////
// 
- (void)enable:(GLenum)capability;
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
   
   glEnable(capability);
}


/////////////////////////////////////////////////////////////////
// 
- (void)disable:(GLenum)capability;
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glDisable(capability);
}

/// 示的 效果 示 iOS Core Ani- mation  的基本 理。 个Core Animation  使用一个对应的 OpenGL ES 的  颜色  缓存   存  颜色数据。 个 的  颜色数据   一个 OpenGL ES 纹理缓存,  纹理缓存 使用 glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_ SRC_ALPHA)  数   帧缓存混合在一 。

/////////////////////////////////////////////////////////////////
// 
- (void)setBlendSourceFunction:(GLenum)sfactor 
   destinationFunction:(GLenum)dfactor;
{
   glBlendFunc(sfactor, dfactor);
}
  
@end
