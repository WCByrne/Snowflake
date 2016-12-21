import Foundation
import CoreGraphics

extension Dictionary {
    
    func number(key: String) -> CGFloat? {
        if let key = key as? Key,
            let value = self[key] as? String {
            return Utils.number(string: value)
        }
        
        return nil
    }
    
    func string(key: String) -> String? {
        if let key = key as? Key {
            return self[key] as? String
        }
        
        return nil
    }
    
    func color(key: String) -> CGColor? {
        if let value = string(key: key) {
            return CGColor.from(value)
        }
        
        return nil
    }
    
    func merge(another: JSONDictionary) -> JSONDictionary {
        var result = JSONDictionary()
        
        self.forEach {
            if let key = $0 as? String {
                result[key] = $1
            }
        }
        
        another.forEach {
            result[$0] = $1
        }
        
        return result
    }
}

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var float : CGFloat {
        var number: Float = 0
        let scanner = Scanner(string: self)
        scanner.scanFloat(&number)
        return CGFloat(number)
    }
    
    var numbers : [CGFloat] {
        var number: Float = 0
        let scanner = Scanner(string: self)
        var numbers = [CGFloat]()
        
        repeat {
            let result = scanner.scanFloat(&number)
            if result {
                numbers.append(CGFloat(number))
            }
            if scanner.scanLocation < self.characters.count - 1 {
                if !result {
                    scanner.scanLocation += 1
                }
            }
            else { break }
        } while true
        return numbers
    }

    var isLowercase : Bool {
        return self == self.lowercased()
    }
    
    
}

extension CGPoint {
    func add(p: CGPoint) -> CGPoint {
        return CGPoint(x: x + p.x, y: y + p.y)
    }
    
    func add(x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: y)
    }
    
    func add(y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: self.y + y)
    }
    
    func subtract(p: CGPoint) -> CGPoint {
        return CGPoint(x: x - p.x, y: y - p.y)
    }
    
    func reflect(point: CGPoint, old: CGPoint) -> CGPoint {
        return CGPoint(x: 2*x - point.x + old.x, y: 2*y - point.y + old.y)
    }
    
    func reflect(around p: CGPoint) -> CGPoint {
        return CGPoint(x: p.x*2 - x, y: p.y*2 - y)
    }
}



extension CALayer {
    
    
    
    func applyStyle(_ style: Style) {
        self.opacity = Float(style.opacity)
        self.setAffineTransform(style.transform)
        
        if let shape = self as? CAShapeLayer {
//            shape.strokeColor = style.strokeColor
            shape.lineWidth = style.strokeWidth
//            shape.fillColor = style.fillColor
            
            if let fillRule = style.fillRule {
                shape.fillRule = fillRule
            }
            if let lineCap = style.lineCap {
                shape.lineCap = lineCap
            }
            if let lineJoin = style.lineJoin {
                shape.lineJoin = lineJoin
            }
            if let miterLimit = style.miterLimit {
                shape.miterLimit = miterLimit
            }
        }

    }
    
}



extension CGAffineTransform {
    
    
    static func from(string: String) -> CGAffineTransform {
        
        var transform = CGAffineTransform()
        
        let regex = try! NSRegularExpression(pattern: "\\b[\\w]+\\([, \\w]+\\)", options: [])
        let matches = regex.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
        
        for result in matches {
            let start = string.index(string.startIndex, offsetBy: result.range.location)
            let end = string.index(start, offsetBy: result.range.length)
            let string = string.substring(with: start..<end)
        
            if let r = string.range(of: "matrix(") {
                var sub = string.substring(from: r.upperBound)
                guard let r2 = sub.range(of: ")") else { return CGAffineTransform.identity }
                sub = sub.substring(to: r2.lowerBound)
                
                let numbers = sub.numbers
                guard numbers.count == 6 else { return CGAffineTransform.identity }
                transform = CGAffineTransform(a: numbers[0],
                                         b: numbers[1],
                                         c: numbers[2],
                                         d: numbers[3],
                                         tx: numbers[4],
                                         ty: numbers[5])
            }
            else if let r = string.range(of: "translate(") {
                var sub = string.substring(from: r.upperBound)
                guard let r2 = sub.range(of: ")") else { return CGAffineTransform.identity }
                sub = sub.substring(to: r2.lowerBound)
                
                let numbers = sub.numbers
                var deltaX : CGFloat = 0
                var deltaY : CGFloat = 0
                if numbers.count > 0 { deltaX = numbers[0] }
                if numbers.count == 2 { deltaY = numbers[1] }
                
                transform.translatedBy(x: deltaX, y: deltaY)
//                let t = CGAffineTransform(translationX: deltaX, y: deltaY)
//                transform = transform.concatenating(t)
            }
                
            else if let r = string.range(of: "scale(") {
                var sub = string.substring(from: r.upperBound)
                guard let r2 = sub.range(of: ")") else { return CGAffineTransform.identity }
                sub = sub.substring(to: r2.lowerBound)
                
                let numbers = sub.numbers
                var valueX : CGFloat = 0
                var valueY : CGFloat = 0
                if numbers.count > 0 { valueX = numbers[0] }
                if numbers.count == 2 { valueY = numbers[1] }
                
                
                transform.scaledBy(x: valueX, y: valueY)
//                let t = CGAffineTransform(scaleX: valueX, y: valueY)
//                transform = transform.concatenating(t)
            }
                
            else if let r = string.range(of: "rotate(") {
                var sub = string.substring(from: r.upperBound)
                guard let r2 = sub.range(of: ")") else { continue }
                sub = sub.substring(to: r2.lowerBound)
                
                let numbers = sub.numbers
                var valueX : CGFloat = 0
                var valueY : CGFloat = 0
                if numbers.count > 0 { valueX = numbers[0] }
                if numbers.count == 2 { valueY = numbers[1] }
                
                transform.rotated(by: numbers[0])
//                let t = CGAffineTransform(rotationAngle: numbers[0])
//                transform = transform.concatenating(t)
            }
            else {
                print("Unhandled transform: \(string)")
            }
        }
        
        return transform
        
        
    }

}

public extension CGRect {
    
    public var center : CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
        set {
            self.origin.x = newValue.x - (self.size.width/2)
            self.origin.y = newValue.y - (self.size.height/2)
        }
    }
    
    public func fitInRect(_ rect: CGRect, scaleUp: Bool = false) -> CGRect {
        
        if !scaleUp && self.size.width < rect.size.width && self.size.height < rect.size.height {
            let x = rect.midX - self.size.width / 2;
            let y = rect.midY - self.size.height / 2;
            return CGRect(x: x, y: y, width: self.size.width, height: self.size.height);
        }
        
        let s = self.scaleFactorAspectFitRectInRect(rect)
        let w = self.width * s;
        let h = self.height * s;
        let x = rect.midX - w / 2;
        let y = rect.midY - h / 2;
        return CGRect(x: x, y: y, width: w, height: h);
    }
    
    func scaleFactorAspectFitRectInRect(_ rect: CGRect) -> CGFloat {
        // first try to match width
        let s = rect.width / self.width;
        // if we scale the height to make the widths equal, does it still fit?
        if (self.height * s <= rect.height) {
            return s
        }
        // no, match height instead
        return rect.height / self.height;
    }
    
    public func fitAroundRect(_ rect: CGRect) -> CGRect {
        
        var s = rect.width / self.width;
        // if we scale the height to make the widths equal, does it still fit?
        if (self.height * s <= rect.height && self.height * s <= rect.height) {
            s = rect.height / self.height;
        }
        
        //        let s = 1 / self.scaleFactorAspectFitRectInRect(rect)
        let w = self.width * s;
        let h = self.height * s;
        let x = rect.midX - w / 2;
        let y = rect.midY - h / 2;
        return CGRect(x: x, y: y, width: w, height: h);
    }
}

public extension CGSize {
    
    func scaleFactorAspectFit(in size: CGSize) -> CGFloat {
        // first try to match width
        let s = size.width / self.width;
        // if we scale the height to make the widths equal, does it still fit?
        if (self.height * s <= size.height) {
            return s
        }
        // no, match height instead
        return size.height / self.height;
    }
    
    
    public func fitting(in size: CGSize, scaleUp: Bool = false) -> CGSize {
        if !scaleUp && self.width < size.width && self.height < size.height {
            return CGSize(width: self.width, height: self.height);
        }
        let s = self.scaleFactorAspectFit(in: size)
        let w = self.width * s;
        let h = self.height * s;
        return CGSize(width: w, height: h);
    }
    
}
