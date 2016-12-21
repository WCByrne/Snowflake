import Foundation
import Reindeer
import CoreGraphics

public class Group : Item {
    
    public let items: [Item]
    var rect = CGRect.zero
    
    public required init(element: Element) {
        var items: [Item] = []
        
        element.children().forEach {
            if let shape = Item.make(element: $0) {
                items.append(shape)
            }
        }
        self.items = items
        super.init(element: element)
    }
    
    
    override public func makeLayer(size: CGSize) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: size)
        for item in items {
            layer.addSublayer(item.makeLayer(size: size))
        }
        layer.applyStyle(style)
        return layer
    }
    
}
