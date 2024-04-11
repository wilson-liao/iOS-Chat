//
//  LayerEXT.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/10.
//

import UIKit

extension CALayer {
    func addWaghaBorder(edge: UIRectEdge, color: CGColor, thickness: CGFloat, width: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: -30, y: -10, width: width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: -30, y: 40, width: width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - 1, y: 0, width: 1, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color;
        self.addSublayer(border)
    }
}
