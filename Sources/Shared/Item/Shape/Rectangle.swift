import Reindeer

public class Rectangle: Shape {
    
    public let frame: CGRect
    public let cornerRadius: CGPoint
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.frame = CGRect(x: attributes.number(key: "x") ?? 0,
                            y: attributes.number(key: "y") ?? 0,
                            width: attributes.number(key: "width") ?? 0,
                            height: attributes.number(key: "height") ?? 0)
        
        self.cornerRadius = CGPoint(x: attributes.number(key: "rx") ?? 0,
                                    y: attributes.number(key: "ry") ?? 0)
        
        super.init(element: element)
    }
    
    override public var path: CGPath { return _path }
    private lazy var _path: CGPath = {
        
        if self.cornerRadius == CGPoint.zero {
            return CGPath(rect: self.frame, transform: nil)
            //      return UIBezierPath(rect: self.frame)
        } else {
            return CGPath(roundedRect: self.frame, cornerWidth: self.cornerRadius.x, cornerHeight: self.cornerRadius.y, transform: nil)
            //      return UIBezierPath(roundedRect: self.frame,
            //                               byRoundingCorners: .allCorners,
            //                               cornerRadii: CGSize(width: self.cornerRadius.x, height: self.cornerRadius.y))
        }
    }()
}
