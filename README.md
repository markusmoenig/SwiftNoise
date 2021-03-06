# SwiftNoise

A library of tileable, procedural noise and pattern functions. Implemented in Swift and utilizes the [Surge](https://github.com/Jounce/Surge) library.

Normally you would implement noise and similar functionality on the GPU, however in my specific use case, a heavily multi-threaded, permutative and recursive node system, a CPU implementation made more sense. Hope this Swift library is useful to others.

Based on [Procedural Tileable Shaders](https://github.com/tuxalin/procedural-tileable-shaders).

## Installation

Simply add the url of this Git to your Swift Packages.

## Usage

All the functions listed below are member functions of the *SwiftNoise* class which you have to instantiate first. As these noises / patterns are tileable, only use the scale parameter to subdivide the noise into more tiles. Scaling the uv / pos parameter will not provide correct results.

This library is work in progress, currently implemented functions are:

```swift
// 2D Value noise.
// @param scale Number of tiles, must be an integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf]
// @return Value of the noise, range: [-1, 1]
func noise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
```

!["Perlin2D"](Images/Value2D.png)


```swift
// 2D Gradient noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
func gradientNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
```

!["Perlin2D"](Images/Gradient2D.png)


```swift
// 2D Perlin noise.
// @param scale Number of tiles, must be  integer for tileable results, range: [2, inf]
// @param seed Seed to randomize result, range: [0, inf], default: 0.0
// @return Value of the noise, range: [-1, 1]
func perlinNoise(pos: SIMD2<Float>, scale: SIMD2<Float>, seed: Float) -> Float
```

!["Perlin2D"](Images/Perlin2D.png)

