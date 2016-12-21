import Foundation

public class CurveToCommand: Command {
  public var controlPoint1: CGPoint = .zero
  public var controlPoint2: CGPoint = .zero
  public var endPoint: CGPoint = .zero

  public required init(string: String, kind: Kind) {
    super.init(string: string, kind: kind)

    let numbers = Utils.numbers(string: string)
    if numbers.count == 6 {
      controlPoint1 = CGPoint(x: numbers[0], y: numbers[1])
      controlPoint2 = CGPoint(x: numbers[2], y: numbers[3])
      endPoint = CGPoint(x: numbers[4], y: numbers[5])
    }
  }

  public override func act(path: CGMutablePath, previousCommand: Command?) {
    if kind == .relative {
      endPoint = path.currentPoint.add(p: endPoint)
      controlPoint1 = path.currentPoint.add(p: controlPoint1)
      controlPoint2 = path.currentPoint.add(p: controlPoint2)
    }
    path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
  }
    
    public override var description: String {
        return "Curve To: (\(endPoint.x), \(endPoint.y))"
    }
}
