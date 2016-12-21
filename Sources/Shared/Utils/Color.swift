import Foundation


struct Color {
    
//    @available (iOS 2.0, *)
//    static func color(name: String) -> UIColor {
//        if name.hasPrefix("#") {
//            return color(hexString: name)
//        } else if name.hasPrefix("rgb") {
//            return color(rgbString: name)
//        } else if let hexString = colorList[name] {
//            return color(hexString: hexString)
//        } else {
//            return UIColor.clear
//        }
//    }
    
    // https://github.com/hyperoslo/Hue/blob/master/Source/iOS/UIColor%2BHue.swift
//    static func color(hexString: String) -> UIColor {
//        var hex = hexString.hasPrefix("#")
//            ? String(hexString.characters.dropFirst())
//            : hexString
//        
//        guard hex.characters.count == 3 || hex.characters.count == 6
//            else {
//                return UIColor.white
//        }
//        
//        if hex.characters.count == 3 {
//            for (index, char) in hex.characters.enumerated() {
//                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
//            }
//        }
//        
//        return UIColor(
//            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
//            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
//            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
//    }
//    
//    static func color(rgbString: String) -> UIColor {
//        
//    }
}


extension CGColor {
    
    static func from(_ string: String) -> CGColor {
        if string.hasPrefix("#") {
            return self.from(hex: string)
        } else if string.hasPrefix("rgb") {
            return self.from(rgb: string)
        } else if let hexString = colorList[string] {
            return self.from(hex: hexString)
        } else {
            return CGColor.clear
        }
    }
    
    static func from(rgb string: String) -> CGColor {
        let string = string.replacingOccurrences(of: "rgb(", with: "")
            .replacingOccurrences(of: ")", with: "")
        let components: [CGFloat] = string.components(separatedBy: ",").map {
            return Utils.number(string: $0)
        }
        
        if components.count == 3 {
            return CGColor(red: components[0], green: components[1], blue: components[2], alpha: 1)
        } else {
            return CGColor.white
        }
    }
    
    static func from(hex string: String) -> CGColor {
        
        var hex = string.hasPrefix("#")
            ? String(string.characters.dropFirst())
            : string
        
        guard hex.characters.count == 3 || hex.characters.count == 6
            else {
                return CGColor.white
        }
        
        if hex.characters.count == 3 {
            for (index, char) in hex.characters.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        return CGColor(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
        
        
    }
    
    
}
