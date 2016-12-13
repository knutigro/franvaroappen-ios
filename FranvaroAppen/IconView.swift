//
//  Icon.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-13.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

@IBDesignable

class IconView: UIView {
    
    var stroke36Layer = CAShapeLayer()
    var stroke38Layer = CAShapeLayer()
    var stroke40Layer = CAShapeLayer()
    var stroke42Layer = CAShapeLayer()
    var stroke44Layer = CAShapeLayer()
    var stroke46Layer = CAShapeLayer()
    var stroke48Layer = CAShapeLayer()
    var stroke50Layer = CAShapeLayer()
    var stroke52Layer = CAShapeLayer()
    
    var strokeColor = UIColor(red: 0.988, green: 0.988, blue: 0.988, alpha: 1).cgColor
    var fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShapeLayer()
        setupPaths()
    }
    
    func animateDrawingPath() {
        let keyPath = "strokeEnd"
        let pathAnimation = CABasicAnimation(keyPath: keyPath)
        pathAnimation.duration = 3.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        
        let layers = [stroke36Layer,
                      stroke38Layer,
                      stroke40Layer,
                      stroke42Layer,
                      stroke44Layer,
                      stroke46Layer,
                      stroke48Layer,
                      stroke50Layer,
                      stroke52Layer
        ]
        
        for layer in layers {
            layer.add(pathAnimation, forKey: keyPath)
        }
    }

    func setupShapeLayer() {
        let layers = [stroke36Layer,
                     stroke38Layer,
                     stroke40Layer,
                     stroke42Layer,
                     stroke44Layer,
                     stroke46Layer,
                     stroke48Layer,
                     stroke50Layer,
                     stroke52Layer
                    ]

        for layer in layers {
            layer.lineWidth = 4;
            layer.strokeColor = strokeColor
            layer.fillColor = fillColor
            self.layer.addSublayer(layer)
        }
    }
    
    func setupPaths() {
        
        let stroke36 = UIBezierPath()
        stroke36.move(to: CGPoint(x: 88.036, y: 54.085))
        stroke36.addCurve(to: CGPoint(x: 49.949, y: 92.271), controlPoint1: CGPoint(x: 88.036, y: 75.175), controlPoint2: CGPoint(x: 70.983, y: 92.271))
        stroke36.addCurve(to: CGPoint(x: 11.861, y: 54.085), controlPoint1: CGPoint(x: 28.914, y: 92.271), controlPoint2: CGPoint(x: 11.861, y: 75.175))
        stroke36.addCurve(to: CGPoint(x: 49.949, y: 15.9), controlPoint1: CGPoint(x: 11.861, y: 32.996), controlPoint2: CGPoint(x: 28.914, y: 15.9))
        stroke36.addCurve(to: CGPoint(x: 88.036, y: 54.085), controlPoint1: CGPoint(x: 70.983, y: 15.9), controlPoint2: CGPoint(x: 88.036, y: 32.996))
        stroke36.addLine(to: CGPoint(x: 88.036, y: 54.085))
        stroke36.close()
        stroke36Layer.path = stroke36.cgPath

        let stroke38 = UIBezierPath()
        stroke38.move(to: CGPoint(x: 26.172, y: 47.569))
        stroke38.addCurve(to: CGPoint(x: 41.244, y: 47.569), controlPoint1: CGPoint(x: 30.335, y: 43.393), controlPoint2: CGPoint(x: 37.079, y: 43.393))
        stroke38Layer.path = stroke38.cgPath
    
        let stroke40 = UIBezierPath()
        stroke40.move(to: CGPoint(x: 58.349, y: 47.569))
        stroke40.addCurve(to: CGPoint(x: 73.422, y: 47.569), controlPoint1: CGPoint(x: 62.513, y: 43.393), controlPoint2: CGPoint(x: 69.256, y: 43.393))
        stroke40Layer.path = stroke40.cgPath
    
        let stroke42 = UIBezierPath()
        stroke42.move(to: CGPoint(x: 42.38, y: 72.94))
        stroke42.addCurve(to: CGPoint(x: 57.212, y: 72.94), controlPoint1: CGPoint(x: 46.481, y: 77.048), controlPoint2: CGPoint(x: 53.114, y: 77.048))
        stroke42Layer.path = stroke42.cgPath

        let stroke44 = UIBezierPath()
        stroke44.move(to: CGPoint(x: 12.144, y: 62.787))
        stroke44.addCurve(to: CGPoint(x: 5, y: 54.931), controlPoint1: CGPoint(x: 8.199, y: 62.787), controlPoint2: CGPoint(x: 5, y: 59.27))
        stroke44.addCurve(to: CGPoint(x: 12.144, y: 47.077), controlPoint1: CGPoint(x: 5, y: 50.594), controlPoint2: CGPoint(x: 8.199, y: 47.077))
        stroke44Layer.path = stroke44.cgPath

        let stroke46 = UIBezierPath()
        stroke46.move(to: CGPoint(x: 87.856, y: 62.787))
        stroke46.addCurve(to: CGPoint(x: 95, y: 54.931), controlPoint1: CGPoint(x: 91.803, y: 62.787), controlPoint2: CGPoint(x: 95, y: 59.27))
        stroke46.addCurve(to: CGPoint(x: 87.856, y: 47.077), controlPoint1: CGPoint(x: 95, y: 50.594), controlPoint2: CGPoint(x: 91.803, y: 47.077))
        stroke46Layer.path = stroke46.cgPath

        let stroke48 = UIBezierPath()
        stroke48.move(to: CGPoint(x: 43.453, y: 11.45))
        stroke48.addLine(to: CGPoint(x: 43.453, y: 24.349))
        stroke48Layer.path = stroke48.cgPath

        let stroke50 = UIBezierPath()
        stroke50.move(to: CGPoint(x: 56.509, y: 11.45))
        stroke50.addLine(to: CGPoint(x: 56.509, y: 24.349))
        stroke50Layer.path = stroke50.cgPath

        let stroke52 = UIBezierPath()
        stroke52.move(to: CGPoint(x: 49.981, y: 5))
        stroke52.addLine(to: CGPoint(x: 49.981, y: 24.349))
        stroke52Layer.path = stroke52.cgPath
    }
}

