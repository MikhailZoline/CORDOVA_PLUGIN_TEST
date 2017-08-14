//
//  CollisionParticle.swift
//  TEST_PLUGIN
//
//  Created by Mikhail Zoline on 8/13/17.
//  Copyright © 2017 MZ. All rights reserved.
//
//  Collision particle, in our case just position, raduis and velocity
//
import UIKit


internal class CollisionParticle{
    // Simplified collision particle have position, velocity and raduis
    internal var pRadii:CGFloat = 0.0
    internal var pVelocity = CGVector(dx: 0.0, dy: 0.0)
    internal var pImage:UIImageView = UIImageView()
    internal var pAnimated:Bool = false
    
    // Spawn a new particle of specified raduis at specified position with inital velocity
    init(with Radius: CGFloat = 1.0, initialVelocity: CGVector , initialPosition: CGPoint = CGPoint( x: 0.0, y: 0.0 ), color: UIColor = .black, view:UIView) {
        pRadii = Radius
        pVelocity = initialVelocity
        pImage.bounds = CGRect(x: 0, y: 0, width: pRadii*2,height: pRadii*2)
        pImage.center = initialPosition
        pImage.backgroundColor = color
        pImage.layer.borderWidth=1.0
        pImage.layer.masksToBounds = false
        pImage.layer.borderColor = UIColor.white.cgColor
        pImage.layer.cornerRadius = Radius
        pImage.clipsToBounds = true
        
        view.addSubview(pImage)
        
    }
    // set new velocity
    internal func set(velocity: CGVector ){
        pVelocity = velocity
    }
    // move the particle to the point
    internal func move(to point:CGPoint) -> Void {
        pImage.center = point
    }
    // primitive integration step
    internal func step(){
        pImage.center.x += pVelocity.dx
        pImage.center.y += pVelocity.dy
    }
    
}



