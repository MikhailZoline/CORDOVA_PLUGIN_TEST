//
//  ScreenSaverController.swift
//  TEST_PLUGIN
//
//  Created by Mikhail Zoline on 8/13/17.
//  Copyright © 2017 MZ. All rights reserved.
//
/**
 
 It is a screen saver with 'fake', that is to say a very simplistic behavior of the collisions between objects
 
 */

import UIKit

// Initialisation constants
fileprivate let paRadius : CGFloat = 55.0
fileprivate let pbRadius : CGFloat = 45.0

fileprivate let paInitPosition = CGPoint(x: 275.0, y: 225.0)
fileprivate let pbInitPosition = CGPoint(x: 275.0, y: 75.0)

fileprivate let paInitialVelocity = CGVector(dx: 0.050, dy: 0.090)
fileprivate let pbInitialVelocity = CGVector(dx: 0.00, dy: 0.00)

class ScreenSaverController: UIViewController {
    
    var timer = Timer()
    var pA:CollisionParticle! = nil
    var pB:CollisionParticle! = nil
    
    var circleMode:Bool = false
    var aPath:UIBezierPath = UIBezierPath()
    var aLayer:CAShapeLayer = CAShapeLayer()
    var cRadius: Float = 60.0
    var pOne:CGPoint = CGPoint()
    var pTwo:CGPoint = CGPoint()
    
    let colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the particles with raduis, position and velocity
        pA = CollisionParticle (with: paRadius, initialVelocity: paInitialVelocity, initialPosition: paInitPosition, color: UIColor.red, view: view)
        pB = CollisionParticle (with: pbRadius, initialVelocity: pbInitialVelocity, initialPosition: pbInitPosition, color: UIColor.blue, view: view)
        
        // Init color animation of particles
        colorKeyframeAnimation.values = [UIColor.red.cgColor,
                                         UIColor.green.cgColor,
                                         UIColor.blue.cgColor,
                                         UIColor.orange.cgColor,
                                         UIColor.magenta.cgColor,
                                         UIColor.cyan.cgColor]
        colorKeyframeAnimation.keyTimes = [0, 0.5, 1, 1.5, 2, 2.5]
        colorKeyframeAnimation.duration = 3
        
        // Start Animation
        startTimer()
    }
    
    func startTimer(){
        
        // Run Animation Loop
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(ScreenSaverController.animation), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    //
    func animation(){
        
        // Move A and B according to their velocities
        pA?.step()
        pB?.step()
        
        // Detect the collision between particle A and B and view frame
        if(pA != nil ){
            _ = intersectWithFrame(view.bounds, pA!)
        }
        if(pB != nil ){
            _ = intersectWithFrame(view.bounds, pB!)
        }
        
        // Detect the collision between particles
        if(pB != nil && pA != nil){
            
            let collision:Bool = intersectWithCircle(pB!,pA!)
            
            if collision {
                // start color animation
                if (pA?.pAnimated)! {
                    pA?.pAnimated = false
                    pB?.pAnimated = true
                    pA?.pImage.layer.removeAllAnimations()
                    pB?.pImage.layer.add(colorKeyframeAnimation, forKey: "colors")
                }
                else{
                    pB?.pAnimated = false
                    pA?.pAnimated = true
                    pB?.pImage.layer.removeAllAnimations()
                    pA?.pImage.layer.add(colorKeyframeAnimation, forKey: "colors")
                }
            }
        }
    }
    
}
