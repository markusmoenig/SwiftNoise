    import XCTest
    @testable import SwiftNoise

    final class SwiftNoiseTests: XCTestCase {
        func testValueNoise2D() {
            XCTAssertEqual(SwiftNoise().noise(pos: SIMD2<Float>(0.5, 0.5), scale: SIMD2<Float>(2,2), seed: 1), 0.3163414)
        }
    }
