//
//  Math.swift
//  TEST_PLUGIN
//
//  Created by Mikhail Zoline on 8/13/17.
//  Copyright © 2017 MZ. All rights reserved.
//
// All math functions are defined here
//

import UIKit

// square funct
//var sqr = { x -> CGFloat in return x * x }
internal var sqr:(_ x:CGFloat)-> CGFloat = {
    x -> CGFloat in return x*x
}

// squared euclidian distance i.e. |w-v|^2 -  avoid a sqrt
internal var dist2:(_ v:CGPoint, _ w:CGPoint)-> CGFloat = {
    v,w -> CGFloat in
    return (sqr(v.x - w.x) + sqr(v.y - w.y))
}

// nomalize a vector
internal var normalize:(_ v:CGVector) -> CGVector = {
    v -> CGVector in
    let distance = sqrt(sqr(v.dx) + sqr(v.dy))
    return (CGVector(dx: v.dx/distance, dy: v.dy/distance))
}

// can't use generics with blocs i.e can't write: vDifference<T>:(_ v:T, _ w:T)
// that's why that one is for CGVectors
internal var vDifference:(_ v:CGVector, _ w:CGVector) -> CGVector = {
    v, w in return (CGVector(dx: v.dx - w.dx, dy: v.dy - w.dy))
}

// that one is for CGPoints
internal var pDifference:(_ v:CGPoint, _ w:CGPoint) -> CGVector = {
    v, w in return (CGVector(dx: v.x - w.x, dy: v.y - w.y))
}

// dot product
internal var vDotProd:(_ v:CGVector, _ w:CGVector) -> CGFloat = {
    v, w in return (v.dx * w.dx + v.dy * w.dy)
}

// squared distance from point P to the line segment v->w
// v = segment begins, w = segment ends, p = point so we want to know the shortest distance
internal var distToSegment: (_ p: CGPoint, _ v: CGPoint, _ w: CGPoint) -> CGFloat = {
    p, v, w -> CGFloat in
    
    // if v == w case
    if (v.x == w.x && v.y == w.y) {
        return dist2(p, v)
    }
    
    let l2 = dist2(v, w)
    
    //parameter  t repesenting the displacemnt on line segment can vary between 0 and 1
    //parameterized as v + t (w - v)
    var t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
    
    // Beyond the 'v' end of the segment
    if (t < 0 ){//if t is outside of segment bound v, the distance would be p-v
        return dist2(p,v)
    }
    
    // Beyond the 'w' end of the segment
    if (t > 1){//if t is outside of segment bound w, the distance would be p-w
        return dist2(p,w)
    }
    
    //t projection falls on the segment
    // shortest distance to line segment
    return (dist2(p,CGPoint(x: v.x + t * (w.x - v.x), y: v.y + t * (w.y - v.y))))
}

// either a segment v->w intersect with circle: p+->r
// v = segment begins, w = segment ends, p = circle center, r = circle radii
internal var intersectWithSegment : (_ v:CGPoint, _ w: CGPoint, _ p:CGPoint, _ r:CGFloat) ->Bool = {  v, w, p, r  -> Bool in
    return( distToSegment(p, v, w) < sqr(r))
}

// check if one of the edges of the rectangle intersects the circle
// and invert velocity accordinly
internal var intersectWithFrame: (_ frame: CGRect, _ circle: CollisionParticle ) -> Bool = {
    frame, circle ->Bool in
    //Get frame coordinates : A top left, B top right, C bottom right, D bottom left
    let A = CGPoint(x:frame.minX, y:frame.minY)
    let B = CGPoint(x:frame.maxX, y:frame.minY)
    let C = CGPoint(x:frame.maxX, y:frame.maxY)
    let D = CGPoint(x:frame.minX, y:frame.maxY)
    let P = circle.pImage.center
    let R = circle.pRadii
    
    if(intersectWithSegment(A, B, circle.pImage.center, circle.pRadii )){//segment case AB
        
        //if the circle in the corner it would intersect two segments
        if(intersectWithSegment(D, A, P, R)){// corner case A(top left)
            circle.pVelocity.dx *= -1 //invert velocity direction
            circle.pVelocity.dy *= -1
        }
        else {//intersect only AB segment
            circle.pVelocity.dy *= -1
        }
        
        return true
    }
    if(intersectWithSegment(B, C, P, R)){//segment case BC
        
        if(intersectWithSegment(C, D, P, R)){
            circle.pVelocity.dx *= -1 //invert velocity direction
            circle.pVelocity.dy *= -1
            
        }
        else{
            circle.pVelocity.dx *= -1
        }
        
        return true
    }
    if(intersectWithSegment(C, D, P, R)){//segment case CD
        
        if(intersectWithSegment(D, A, P, R)){
            circle.pVelocity.dx *= -1 //invert velocity direction
            circle.pVelocity.dy *= -1
        }
        else{
            circle.pVelocity.dy *= -1
        }
        
        return true
    }
    if(intersectWithSegment(D, A, P, R)){//segment case DA
        
        if(intersectWithSegment(C, D, P, R)){//corner case D
            circle.pVelocity.dx *= -1 //invert velocity direction
            circle.pVelocity.dy *= -1
        }
        else{
            circle.pVelocity.dx *= -1
        }
        
        return true
    }
    return false
}

// Check if Particle A intersects the Particle B
// Collisoon response is from https://en.wikipedia.org/wiki/Elastic_collision
internal var intersectWithCircle: (_ A: CollisionParticle, _ B: CollisionParticle) -> Bool = {
    A, B ->Bool in
    // cA = A.position, cB = B.position
    let cA = A.pImage.center
    let cB = B.pImage.center
    
    // dA_B = squared euclidian distance between A and B
    let dA_B = dist2(cA, cB)
    // A intersects with B, adjust the corresponding velocities
    if( dA_B <= sqr(A.pRadii + B.pRadii) ){
        
        // A_B = A.position - B.position and B_A = -A_B
        let A_B = pDifference(cA, cB)
        let B_A = CGVector(dx:-A_B.dx, dy:-A_B.dy)
        
        // vA_vB = A.velocity - B.velocity and vB_vA = -vA_vB
        let vA_vB = vDifference(A.pVelocity, B.pVelocity)
        let vB_vA = CGVector(dx:-vA_vB.dx, dy:-vA_vB.dy)
        
        // vA_vB_Dot_A_B = (A.velocity - B.velocity) dot ( A.position - B.position ) / distance(A.position, B.position)
        let vA_vB_Dot_A_B = vDotProd (vA_vB, A_B)/dA_B
        
        // Adjust velocities
        A.pVelocity.dx -= vA_vB_Dot_A_B * A_B.dx
        A.pVelocity.dy -= vA_vB_Dot_A_B * A_B.dy
        
        B.pVelocity.dx -= vA_vB_Dot_A_B * B_A.dx
        B.pVelocity.dy -= vA_vB_Dot_A_B * B_A.dy
        
        return true
    }
    return false
}
