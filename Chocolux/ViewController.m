#import "ViewController.h"

@interface ViewController () {
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [EAGLContext setCurrentContext:self.context];
    
    glEnableVertexAttribArray(0);
}

- (void)dealloc
{    
	if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
	}
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
}

@end
