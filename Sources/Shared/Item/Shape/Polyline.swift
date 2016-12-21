import Reindeer

public class Polyline: Shape {
    
    public let points: [CGPoint]
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.points = Utils.points(string: attributes.string(key: "points"))
        
        super.init(element: element)
    }
    
    override public var path: CGPath { return _path }
    private lazy var _path: CGPath = {
        let path = CGMutablePath()
        if let first = self.points.first {
            path.move(to: first)
            
            self.points.dropFirst().forEach {
                path.addLine(to: $0)
            }
        }
        return path
    }()
}
