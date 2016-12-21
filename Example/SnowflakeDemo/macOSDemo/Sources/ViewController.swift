 //
//  ViewController.swift
//  macOSDemo
//
//  Created by Wesley Byrne on 12/19/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import Cocoa
import AppKit
import CBCollectionView
import Snowflake

class ViewController: NSViewController, CBCollectionViewDataSource, CBCollectionViewDelegate {

    @IBOutlet weak var collectionView : CBCollectionView!
    @IBOutlet weak var svgView: SVGView!
    
    
    var resources = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListCell.register(collectionView)
        
        let layout = CBCollectionViewListLayout()
        layout.itemHeight = 44
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.allowsEmptySelection = false
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.allowsEmptySelection = false
        
        self.resources = Bundle.main.urls(forResourcesWithExtension: "svg", subdirectory: nil) ?? []
        
        self.collectionView.reloadData()
        
        self.collectionView.selectItemAtIndexPath(IndexPath.Zero, animated: false)
        
        
    }
    
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func numberOfSectionsInCollectionView(_ collectionView: CBCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: CBCollectionView, numberOfItemsInSection section: Int) -> Int {
        return resources.count
    }
    
    func collectionView(_ collectionView: CBCollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> CBCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! ListCell
        cell.highlightedBackgroundColor = NSColor(white: 0, alpha: 0.05)
        cell.style = .basic
        cell.titleLabel.stringValue = resources[indexPath._item].deletingPathExtension().lastPathComponent
        
        return cell
    }
    
    func collectionView(_ collectionView: CBCollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let url = resources[indexPath._item]
        self.url = url
        svgView.load(url)
    }
    
    var url : URL?
    
    @IBAction func openSource(_ sender: Any?) {
        guard let u = url else { return }
        NSWorkspace.shared().openFile(u.path, withApplication: "Atom")
    }
    
}




class SVGView : NSView {
    
    var document: Document?
    private(set) var magnification : CGFloat = 1
    private(set) var rotation : CGFloat = 0
    
    let contentLayer = CALayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var isFlipped: Bool { return true }
    
    private func setup() {
        self.wantsLayer = true
        self.layer?.addSublayer(contentLayer)
        
        let rotation = NSRotationGestureRecognizer(target: self, action: #selector(rotationGesture(_:)))
        self.addGestureRecognizer(rotation)
        
        let gesture = NSMagnificationGestureRecognizer(target: self, action: #selector(magnificationGesture(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    
    var _startMag : CGFloat = 1
    var _startRotation : CGFloat = 0
    func magnificationGesture(_ sender : NSMagnificationGestureRecognizer) {
        
        if sender.state == .began {
            _startMag = self.magnification
        }
        
        var scale = _startMag + sender.magnification
        
        if scale < 1 { scale = 1 }
        if scale > 4 { scale = 4 }
        self.magnification = scale

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.updateTransform()
        CATransaction.commit()
    }
    
    func rotationGesture(_ sender: NSRotationGestureRecognizer) {
        if sender.state == .began {
            _startRotation = self.rotation
        }
        
        let rot = _startRotation - (sender.rotation * 2)
        
//        if rot < 1 { scale = 1 }
//        if rot > 4 { scale = 4 }
        self.rotation = rot
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.updateTransform()
        CATransaction.commit()
        
    }
    
    func updateTransform() {
        
        let rotation = CGAffineTransform(rotationAngle: self.rotation)
        let scale = CGAffineTransform(scaleX: self.magnification, y: self.magnification)
        
        self.contentLayer.setAffineTransform(rotation.concatenating(scale))
        
    }
    
    func load(_ url: URL) {
        
        if let subs = contentLayer.sublayers {
            for l in subs { l.removeFromSuperlayer() }
        }
        
        guard let doc = Document(url: url) else {
            return
        }
        
        self.document = doc
        
        
        let _size = doc.svg.size.fitting(in: self.bounds.size)
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let l = doc.svg.layer(size: _size)
        contentLayer.addSublayer(l)
        
        self.magnification = 1
        self.rotation = 0
        self.updateTransform()
        
        var rect = CGRect(origin: CGPoint.zero, size: _size)
        rect.origin.x = (self.bounds.size.width/2) - (_size.width/2)
        rect.origin.y = (self.bounds.size.height/2) - (_size.height/2)
        self.contentLayer.frame = rect
        
        
//        let mask = CALayer()
//        
//        let m1 = CAShapeLayer()
//        m1.path = CGPath(rect: CGRect(x:0, y:50, width: rect.size.width, height: 200), transform: nil)
//        let m2 = CATextLayer()
//        m2.fontSize = 22
//        m2.alignmentMode = kCAAlignmentCenter
//        m2.string = "This is a test of the layer masking"
//        m2.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: 50)
//        
//        mask.addSublayer(m1)
//        mask.addSublayer(m2)
//        
//        contentLayer.mask = mask
//        mask.frame = contentLayer.bounds
        
        CATransaction.commit()
    }
    
    
    
    
}
