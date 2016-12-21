
import Reindeer

public class Circle: Shape {
    
    public let center: CGPoint
    public let radius: CGFloat
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.center = CGPoint(x: attributes.number(key: "cx") ?? 0,
                              y: attributes.number(key: "cy") ?? 0)
        self.radius = attributes.number(key: "r") ?? 0
        
        super.init(element: element)
    }
    
    override public var path: CGPath { return _path }
    private lazy var _path: CGPath = {
        let path = CGMutablePath()
        path.addArc(center: self.center,
                    radius: self.radius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * CGFloat(2),
                    clockwise: true)
        return path
    }()
}
