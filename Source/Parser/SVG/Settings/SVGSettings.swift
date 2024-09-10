//
//  SVGSettings.swift
//  SVGView
//
//  Created by Yuri Strot on 29.05.2022.
//

import Foundation
import CoreGraphics

public struct SVGSettings: Sendable {

    public static let `default` = SVGSettings()

    public let linker: SVGLinkerProtocol
    public let logger: SVGLogger
    public let fontSize: CGFloat
    public let ppi: Double

    public init(
        linker: SVGLinkerProtocol = SVGLinker(),
        logger: SVGLogger = .console,
        fontSize: CGFloat = 16,
        ppi: CGFloat = 96
    ) {
        self.linker = linker
        self.logger = logger
        self.fontSize = fontSize
        self.ppi = ppi
    }

    func linkIfNeeded(to svgURL: URL) -> SVGSettings {
        if linker is SVGURLLinker {
            return self
        } else {
            return SVGSettings(
                linker: SVGURLLinker(relativeTo: svgURL),
                logger: logger,
                fontSize: fontSize,
                ppi: ppi
            )
        }
    }
}
