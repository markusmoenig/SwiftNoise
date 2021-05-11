//
//  perlin.swift
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

// 2D Perlin noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
func perlinNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
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
    var gradientX: SIMD4<Float> = SIMD4<Float>(0,0,0,0)
    var gradientY: SIMD4<Float> = SIMD4<Float>(0,0,0,0)
    
    permuteHash2D(SIMD4<Float>(i[0], i[1], i[2], i[3]), &gradientX, &gradientY)
    gradientX -= 0.49999
    gradientY -= 0.49999
    
    func invSqrt(_ x: Float) -> Float {
        let halfx = 0.5 * x
        var y = x
        var i : Int32 = 0
        memcpy(&i, &y, 4)
        i = 0x5f3759df - (i >> 1)
        memcpy(&y, &i, 4)
        y = y * (1.5 - (halfx * y * y))
        return y
    }

    // perlin surflet
    //vec4 gradients = inversesqrt(gradientX * gradientX + gradientY * gradientY) * (gradientX * f.xzxz + gradientY * f.yyww);
    var gradients : SIMD4<Float> = SIMD4<Float>(
        (invSqrt(gradientX.x * gradientX.x + gradientY.x * gradientY.x)) * (gradientX.x * f[0] + gradientY.x * f[1]),
        (invSqrt(gradientX.y * gradientX.y + gradientY.y * gradientY.y)) * (gradientX.y * f[2] + gradientY.y * f[1]),
        (invSqrt(gradientX.z * gradientX.z + gradientY.z * gradientY.z)) * (gradientX.z * f[0] + gradientY.z * f[3]),
        (invSqrt(gradientX.w * gradientX.w + gradientY.w * gradientY.w)) * (gradientX.w * f[2] + gradientY.w * f[3])
        )
    
    // normalize: 1.0 / 0.75^3
    gradients *= 2.3703703703703703703703703703704
    var lengthSq = Surge.elmul(f, f)
    //lengthSq = lengthSq.xzxz + lengthSq.yyww
    lengthSq = Surge.add([lengthSq[0], lengthSq[2], lengthSq[0], lengthSq[2]], [lengthSq[1], lengthSq[1], lengthSq[3], lengthSq[3]])
    var xSq = 1.0 - min(SIMD4<Float>(1.0, 1.0, 1.0, 1.0), _a2f4(lengthSq))
    xSq = xSq * xSq * xSq
    return dot(xSq, gradients)
}

