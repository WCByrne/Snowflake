import Foundation

public class ClosePathCommand: Command {

  convenience init() {
    self.init(string: "", kind: .absolute)
  }

  public override func act(path: CGMutablePath, previousCommand: Command?) {
    path.closeSubpath()
  }
    
    public override var description: String {
        return "Close Path"
    }
}
