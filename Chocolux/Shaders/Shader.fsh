//
//  Shader.fsh
//  Chocolux
//
//  Created by Maximilian Christ on 01/02/14.
//  Copyright (c) 2014 McZonk. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
