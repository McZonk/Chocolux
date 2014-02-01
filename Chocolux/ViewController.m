#import "ViewController.h"

char *vsh="\
varying vec3 s[4];\
void main(){\
gl_Position=gl_Vertex;\
s[0]=vec3(0);\
s[3]=vec3(sin(abs(gl_Vertex.x*.0001)),cos(abs(gl_Vertex.x*.0001)),0);\
s[1]=s[3].zxy;\
s[2]=s[3].zzx;\
}";

char *fsh="\
varying vec3 s[4];\
void main(){\
float t,b,c,h=0;\
vec3 m,n,p=vec3(.2),d=normalize(.001*gl_FragCoord.rgb-p);\
for(int i=0;i<4;i++){\
t=2;\
for(int i=0;i<4;i++){\
b=dot(d,n=s[i]-p);\
c=b*b+.2-dot(n,n);\
if(b-c<t)if(c>0){m=s[i];t=b-c;}\
}\
p+=t*d;\
d=reflect(d,n=normalize(p-m));\
h+=pow(n.x*n.x,44.)+n.x*n.x*.2;\
}\
gl_FragColor=vec4(h,h*h,h*h*h*h,h);\
}";

@interface ViewController () {
	NSTimeInterval _time;
	GLuint _program;
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
    
	_time = 2.5; // must be at least 1.0, but 2.5 is a nicer starting point
	
    glEnableVertexAttribArray(0);
	
	_program = glCreateProgram();
	
	GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertexShader, 1, (const GLchar **)(&vsh), NULL);
	glCompileShader(vertexShader);
	glAttachShader(_program, vertexShader);

	GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, (const GLchar **)(&fsh), NULL);
	glCompileShader(fragmentShader);
	glAttachShader(_program, fragmentShader);
	
	glLinkProgram(_program);
	glUseProgram(_program);
}

- (void)dealloc
{    
	if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
	}
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	_time += self.timeSinceLastDraw * 0.2;
	
	glClear(GL_COLOR_BUFFER_BIT);
	
	glUseProgram(_program);
	
	float data[8] = {
		 _time,  _time,
		-_time,  _time,
		-_time, -_time,
		 _time, -_time
	};
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, data);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

@end
