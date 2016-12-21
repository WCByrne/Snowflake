//
//  LinearGradient.swift
//  Pods
//
//  Created by Wesley Byrne on 12/20/16.
//
//

import Reindeer
import Foundation
import QuartzCore


public protocol Stroke {
    func stroke(_ layer: CALayer)
}

public protocol Fill {
    func fill(_ layer: CALayer)
}

extension CGColor: Fill, Stroke {
    public func fill(_ layer: CALayer) {
        layer.backgroundColor = self
    }
    
    public func stroke(_ layer: CALayer) {
        layer.borderColor = self
    }
}




class LinearGradient : Item, Fill, Stroke {
    
    required init(element: Element) {
        super.init(element: element)
    }
    
    func fill(_ layer: CALayer) {
        
    }
    
    func stroke(_ layer: CALayer) {
        
    }
    
    
}


class RadialGradient : Item, Fill, Stroke {
    
    required init(element: Element) {
        super.init(element: element)
    }
    
    func fill(_ layer: CALayer) {
        
    }
    
    func stroke(_ layer: CALayer) {
        
    }
    
}
