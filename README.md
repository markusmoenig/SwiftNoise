# SwiftNoise

A library of tileable, procedural noise and pattern functions. Implemented in Swift and utilizes the [Surge Library](https://github.com/Jounce/Surge).

Based on [Procedural Tileable Shaders](https://github.com/tuxalin/procedural-tileable-shaders).

## Installation

Simply add the url of this Git to your Swift Packages.

## Current status

This library is work in progress, currently implemented functions are:

```swift

// 2D Value noise.
// @param scale Number of tiles, must be an integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf]
// @return Value of the noise, range: [-1, 1]
func noise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float

// 2D Gradient noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
func gradientNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float

// 2D Perlin noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
func perlinNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
```

