import UIKit
import Snowflake

class ListController: UITableViewController {
  
  var items: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let path = Bundle.main.resourcePath,
      let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
      items = contents.flatMap { content in
        if content.hasSuffix("svg") {
          return content.replacingOccurrences(of: ".svg", with: "")
        }
        
        return nil
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    cell?.textLabel?.text = items[indexPath.row]
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = ViewController()
    controller.item = items[indexPath.row]
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

class ViewController: UIViewController {
    
    var item: String!
    var scale : CGFloat = 1
    
    var svgView : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        edgesForExtendedLayout = []
        navigationController?.navigationBar.isTranslucent = false
        
        title = item
        load()
    }
    
    func load() {
        guard let path = Bundle.main.path(forResource: item, ofType: "svg"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let document = Snowflake.Document(data: data)
            else { return }
        
        self.svgView?.removeFromSuperview()
        
        
        let size = 300 * scale
        let svgView = document.svg.view(size: CGSize(width: size, height: size))
        self.view.addSubview(svgView)
        self.svgView = svgView
        
        
        let mag = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        self.view.addGestureRecognizer(mag)
    }
    
    func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        
        self.scale = sender.scale
        
        //        let size = scale * 300
        
        let transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        self.svgView?.layer.setAffineTransform(transform)
        
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.subviews.forEach {
            $0.center = view.center
        }
    }
}
