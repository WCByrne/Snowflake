import Foundation
import Reindeer
import QuartzCore









public class SVG {
    
    
    
    
    public let references : [Item]
    public let items: [Item]
    
    public let size: CGSize
    
    public init(element: Element) {
        
        if let width = element.attributes.number(key: "width"),
            let height = element.attributes.number(key: "height") {
            self.size = CGSize(width: width, height: height)
        }
        else if let viewBox = element.attributes.string(key: "viewBox") {
            let comps = viewBox.components(separatedBy: CharacterSet(charactersIn: ", "))
            let width = Utils.number(string: comps[2])
            let height = Utils.number(string: comps[3])
            self.size = CGSize(width: width, height: height)
        }
        else {
            self.size = CGSize.zero
        }
        
        //    self.size = CGSize(width: element.attributes.number(key: "width") ?? 0,
        //                       height: element.attributes.number(key: "height") ?? 0)
        
        var _refs = [Item]()
        var _items = [Item]()
        for e in element.children() {
            if let i = Item.make(element: e) {
                _items.append(i)
            }
//            self.items = [Item.make(element: element)!]
        }
        self.references = _refs
        self.items = _items
    }
}

public extension SVG {
    
    //  func view(size: CGSize) -> UIView {
    //    let view = UIView()
    //    view.frame.size = size
    //

    //    for layer in layers(size: size) {
    //      view.layer.addSublayer(layer)
    //    }
    //
    //    return view
    //  }
    
    func layer(size: CGSize) -> CALayer {
        
        let layer = CALayer()
        
//        for item in items {
//        
//            return item.makeLayer(size: size)
        
        /*
        let originalSize = Utils.bounds(layers: layers).size
        let ratio = Utils.ratio(from: originalSize, to: size)
        let scale = CGAffineTransform(scaleX: ratio, y: ratio)
        Utils.transform(layers: layers, transform: scale)
        
        let scaledBounds = Utils.bounds(layers: layers)
        let translate = CGAffineTransform(translationX: -scaledBounds.origin.x, y: -scaledBounds.origin.y)
        Utils.transform(layers: layers, transform: translate)
        
        retur
         n layers
 */
        return layer
    }
}
