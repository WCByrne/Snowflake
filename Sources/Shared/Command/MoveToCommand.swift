import Foundation

public class MoveToCommand: Command {
  public var point: CGPoint = .zero

  public required init(string: String, kind: Kind) {
    super.init(string: string, kind: kind)

    let numbers = Utils.numbers(string: string)
    if numbers.count == 2 {
      point = CGPoint(x: numbers[0], y: numbers[1])
    }
  }

  public override func act(path: CGMutablePath, previousCommand: Command?) {
    if kind == .relative {
      point = path.currentPoint.add(p: point)
    }

    path.move(to: point)
  }
    
    public override var description: String {
        return "MoveTo: (\(point.x), \(point.y))"
    }
    
    
}

