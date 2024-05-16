//
//  ProfilePic.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/24.
//

import UIKit

class ProfilePic: UIImageView {
    
    init(img: UIImage) {
        super.init(image: img)
//        self.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor(named: "black")?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupHexagonMask(lineWidth: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        
        let imgb = self.image?.size
        
        let path = UIBezierPath(roundedPolygonPathInRect: bounds, lineWidth: lineWidth, sides: 6, cornerRadius: cornerRadius, rotationOffset: CGFloat.pi / 2.0).cgPath

        let mask = CAShapeLayer()
        mask.path = path
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        layer.mask = mask

        let border = CAShapeLayer()
        border.path = path
        border.lineWidth = lineWidth
        border.strokeColor = color.cgColor
        border.fillColor = UIColor.clear.cgColor
        layer.addSublayer(border)
    }
}


extension UIBezierPath {
    convenience init(roundedPolygonPathInRect rect: CGRect, lineWidth: CGFloat, sides: NSInteger = 6, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0) {
        self.init()
        
        drawHexagon(rect: rect)

//        let theta: CGFloat = 2.0 * CGFloat.pi / CGFloat(sides) // How much to turn at every corner
//        let width = rect.size.width       // Width of the squarelet
//        
//        let height =  rect.size.height
//        let center = CGPoint(x: rect.origin.x + (width / 2.0), y: rect.origin.y + (height / 2.0))
//        let center = CGPoint(x: 0, y: 0)

        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
//        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 4.0
//        let radius = (width - lineWidth) / 2.0

        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
//        var angle = CGFloat(rotationOffset)
//
//        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//        move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        
        
//        for _ in 0 ..< sides {
//            angle += theta
//
//            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
//            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
//            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
//        
//            
//            addLine(to: start)
//            addQuadCurve(to: end, controlPoint: tip)
//        }

//        close()
    }
    
    func drawHexagon(rect: CGRect){
        let width = rect.size.width
        let height = rect.size.height
        let orx = rect.origin.x
        let ory = rect.origin.y
        
        
        let t1 = CGPoint(x: orx + (width / 2.0), y: ory)
        let t2 = CGPoint(x: orx+width, y: ory + height / 4.0)
        let t3 = CGPoint(x: orx+width, y: ory + height * 3.0 / 4.0)
        let t4 = CGPoint(x: orx + (width / 2.0), y: ory + height)
        let t5 = CGPoint(x: orx, y: ory + height * 3.0 / 4.0)
        let t6 = CGPoint(x: orx, y: ory + height / 4.0)
        move(to: t6)
        addLine(to: t1)
        addLine(to: t2)
        addLine(to: t3)
        addLine(to: t4)
        addLine(to: t5)
        close()
    }
}
