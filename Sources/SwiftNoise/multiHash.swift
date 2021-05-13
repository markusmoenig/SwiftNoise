//
//  multiHash.swift
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

extension SwiftNoise {
    
    // based on GPU Texture-Free Noise by Brian Sharpe: https://archive.is/Hn54S
    func permutePrepareMod289(_ x : SIMD3<Float>) -> SIMD3<Float> { return x - floor(x * (1.0 / 289.0)) * 289.0 }
    func permutePrepareMod289(_ x : SIMD4<Float>) -> SIMD4<Float> { return x - floor(x * (1.0 / 289.0)) * 289.0 }
    func permuteResolve(_ x : SIMD4<Float>) -> SIMD4<Float> { return fract( x * (7.0 / 288.0 )) }
    func permuteHashInternal(_ x : SIMD4<Float>) -> SIMD4<Float> { return fract(x * ((34.0 / 289.0) * x + (1.0 / 289.0))) * 289.0 }

    // generates a random number for each of the 4 cell corners
    func permuteHash2D(_ cellIn: SIMD4<Float>) -> SIMD4<Float>
    {
        let cell = permutePrepareMod289(cellIn * 32.0)
        let c1 = SIMD4<Float>(cell.x, cell.z, cell.x, cell.z)//cell.xzxz
        let c2 = SIMD4<Float>(cell.y, cell.y, cell.w, cell.w)//cell.yyww
        return permuteResolve(permuteHashInternal(permuteHashInternal(c1) + c2));
    }

    // generates 2 random numbers for each of the 4 cell corners
    func permuteHash2D(_ cellIn: SIMD4<Float>,_ hashX: inout SIMD4<Float>,_ hashY: inout SIMD4<Float>)
    {
        let cell = permutePrepareMod289(cellIn)
        let c1 = SIMD4<Float>(cell.x, cell.z, cell.x, cell.z)//cell.xzxz
        let c2 = SIMD4<Float>(cell.y, cell.y, cell.w, cell.w)//cell.yyww
        hashX = permuteHashInternal(permuteHashInternal(c1) + c2)
        hashY = permuteResolve(permuteHashInternal(hashX))
        hashX = permuteResolve(hashX)
    }
}
