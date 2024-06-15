//
//  SVGLogger.swift
//  SVGView
//
//  Created by Yuri Strot on 26.05.2022.
//

import Foundation

public final class SVGLogger: Sendable {

    public static let console = SVGLogger()

    public func log(message: String) {
        print(message)
    }

    public func log(error: Error) {
        log(message: error.localizedDescription)
    }

}
