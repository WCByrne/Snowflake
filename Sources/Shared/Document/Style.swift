import Foundation
import QuartzCore




public struct Style {
    public var stroke: Stroke?
    public let strokeWidth: CGFloat
    public var fill: Fill
    
    public let opacity: CGFloat
    public var fillRule: String?
    public var lineCap: String?
    public var lineJoin: String?
    public var miterLimit: CGFloat?
    
    public var overflow: CGFloat?
    public var transform = CGAffineTransform.identity
    
    
    public init(attributes: JSONDictionary) {
        var attributes = attributes
        
        if let string = attributes.string(key: "style") {
            attributes = attributes.merge(another: Style.parse(string: string))
        }
        
        self.strokeWidth = attributes.number(key: "stroke-width") ?? 1
        
        var _fill : Fill?
        
        if let c = attributes.color(key: "fill") {
            _fill = c
        }
        else {
            
        }
        
        self.fill = _fill ?? CGColor.black
        
//        self.strokeColor = attributes.color(key: "stroke")
        self.opacity = attributes.number(key: "opacity") ?? 1
        self.fillRule = Style.parse(fillRule: attributes.string(key: "fill-rule"))
        self.lineCap = Style.parse(lineCap: attributes.string(key: "stroke-linecap"))
        self.lineJoin = Style.parse(lineJoin: attributes.string(key: "stroke-linejoin"))
        self.miterLimit = attributes.number(key: "stroke-miterlimit")
        
        if let t = attributes.string(key: "transform") {
            self.transform = CGAffineTransform.from(string: t)
        }
    }
    
    
    
    // MARK: - Helpers
    /*-------------------------------------------------------------------------------*/
    private static func parse(string: String) -> JSONDictionary {
        var attributes: JSONDictionary = JSONDictionary()
        
        string.components(separatedBy: ";").map {
            return $0.replacingOccurrences(of: " ", with: "")
            }.forEach {
                let components: [String] = $0.components(separatedBy: ":")
                if components.count == 2 {
                    attributes[components[0]] = components[1]
                }
        }
        
        return attributes
    }
    
    private static func parse(fillRule: String?) -> String? {
        guard let fillRule = fillRule else { return nil }
        let mapping: [String: String] = [
            "nonzero": kCAFillRuleNonZero,
            "evenodd": kCAFillRuleEvenOdd
        ]
        return mapping[fillRule]
    }
    
    private static func parse(lineCap: String?) -> String? {
        guard let lineCap = lineCap else { return nil }
        if ["butt", "square", "round"].contains(lineCap) {
            return lineCap
        } else {
            return nil
        }
    }
    
    private static func parse(lineJoin: String?) -> String? {
        guard let lineJoin = lineJoin else { return nil }
        if ["bevel", "miter", "round"].contains(lineJoin) {
            return lineJoin
        } else {
            return nil
        }
    }
}
