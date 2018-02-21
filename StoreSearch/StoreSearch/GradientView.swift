//
//  GradientView.swift
//  StoreSearch
//
//  Created by Christian on 2/22/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        // ocaticty in center, and opactiy in outer edges
        let components: [CGFloat] = [ 0, 0, 0, 0.4, 0, 0, 0, 0.8 ]
        let locations: [CGFloat] = [ 0, 1 ]
        // 2
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)

        // 3
        let x = bounds.midX
        let y = bounds.midY
        let centerPoint = CGPoint(x: x, y : y)
        let radius = max(x, y)

        // 4
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: 0,
                                    endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
    }

}
