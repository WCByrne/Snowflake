
//
public protocol ShapeAware {
  var style: Style { get }
  var path: CGPath { get }
}
//
//public extension ShapeAware {
//
//}


public class Shape : Item {
    
    public var path : CGPath { return CGMutablePath() }
    
    override public func makeLayer(size: CGSize) -> CALayer {
        let layer = CAShapeLayer()
        layer.path = path
        
        layer.applyStyle(style)
        
        return layer
    }
    
}
