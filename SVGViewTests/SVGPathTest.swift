//
//  File.swift
//  
//
//  Created by chenyungui on 2023/5/23.
//

import Foundation
import XCTest
import CommonKit

@testable import SVGView

class SVGPathTests: XCTestCase {
    
    let svgString = "M45.3125-73.4375C43.3105-73.4375 41.6992-75.0977 41.6992-77.0508C41.6992-79.0039 43.3105-80.6152 45.3125-80.6152C47.3145-80.6152 48.9258-79.0039 48.9258-77.0508C48.9258-75.0977 47.3145-73.4375 45.3125-73.4375Z"
    
    func testSVGToBezierPath() {
        let reader = PathReader(input: svgString)
        let segments = reader.read()
        let path = segments.toBezierPath()
        let view = path.debugView.retain()
        print(view)
    }
}
