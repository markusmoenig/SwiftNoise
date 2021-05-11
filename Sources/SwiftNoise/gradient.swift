//
//  gradient.swift
//  
//
//  Created by Markus Moenig on 11/5/21.
//

import simd
import Surge

// Swift / Surge port by Markus Moenig

/*
 MIT License

 Copyright (c) 2021 Markus Moenig

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

// Tileable noises based on https://github.com/tuxalin/procedural-tileable-shaders

/*
 MIT License

 Copyright (c) 2019 Alin

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

// 2D Gradient noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
public func gradientNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
{
    let _pos = [pos.x * scale.x, pos.y * scale.y]

    // based on Modifications to Classic Perlin Noise by Brian Sharpe: https://archive.is/cJtlS
    //vec4 i = floor(pos).xyxy + vec2(0.0, 1.0).xxyy;
    let _pos_floor = Surge.floor(_pos)
    var i = Surge.add([_pos_floor[0], _pos_floor[1], _pos_floor[0], _pos_floor[1]], [0, 0, 1, 1])

    //vec4 f = (pos.xyxy - i.xyxy) - vec2(0.0, 1.0).xxyy;
    let f = Surge.sub(Surge.sub([_pos[0], _pos[1], _pos[0], _pos[1]], [i[0], i[1], i[0], i[1]]), [0,0,1,1])

    //i = mod(i, scale.xyxy) + seed
    i = Surge.add(Surge.mod(i, [scale.x, scale.y, scale.x, scale.y]), seed)
    
    // grid gradients
    var hashX: SIMD4<Float> = SIMD4<Float>(0,0,0,0)
    var hashY: SIMD4<Float> = SIMD4<Float>(0,0,0,0)
    
    permuteHash2D(SIMD4<Float>(i[0], i[1], i[2], i[3]), &hashX, &hashY)
    
    //vec4 gradients = hashX * f.xzxz + hashY * f.yyww;
    var gradients = Surge.elmul([hashX.x, hashX.y, hashX.z, hashX.w], [f[0], f[2], f[0], f[2]])
    gradients = Surge.add(gradients, Surge.elmul([hashY.y, hashY.y, hashY.w, hashY.w], [f[1], f[1], f[3], f[3]]))
    
    let u = noiseInterpolate(SIMD2<Float>(f[0], f[1]))
    //vec2 g = mix(gradients.xz, gradients.yw, u.x);
    let g = SIMD2<Float>(
        simd_mix(gradients[0], gradients[1], u.x),
        simd_mix(gradients[2], gradients[3], u.x)
    )
    return 1.4142135623730950 * simd_mix(g.x, g.y, u.y);
}
