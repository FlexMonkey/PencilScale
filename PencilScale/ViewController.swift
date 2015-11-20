//
//  ViewController.swift
//  PencilScale
//
//  Created by Simon Gladman on 20/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let nixieDigitDisplay = FMNixieDigitDisplay(numberOfDigits: 8)
    let zeroButton = ZeroButton()
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.darkGrayColor()
        
        view.addSubview(zeroButton)
        view.addSubview(nixieDigitDisplay)
        
        shapeLayer.fillColor = nil
        shapeLayer.lineDashPattern = [10]
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.yellowColor().CGColor
        view.layer.addSublayer(shapeLayer)
        
        zeroButton.enabled = false
        zeroButton.addTarget(self, action: "zeroWeight", forControlEvents: UIControlEvents.TouchDown)
        
        weight = 0
    }

    override func viewDidLayoutSubviews()
    {
        nixieDigitDisplay.frame = CGRect(x: view.frame.width / 2 - nixieDigitDisplay.intrinsicContentSize().width / 2,
            y: view.frame.height - nixieDigitDisplay.intrinsicContentSize().height,
            width: nixieDigitDisplay.intrinsicContentSize().width,
            height: nixieDigitDisplay.intrinsicContentSize().height)
        
        zeroButton.frame = CGRect(x: view.frame.width - zeroButton.intrinsicContentSize().width - 10,
            y: view.frame.height - zeroButton.intrinsicContentSize().height - 10,
            width: zeroButton.intrinsicContentSize().width,
            height: zeroButton.intrinsicContentSize().height)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch = touches.first where touch.type == UITouchType.Stylus else
        {
            return
        }
        
        zeroButton.enabled = true
        
        update(weight: touch.force, touchLocation: touch.locationInView(view))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch = touches.first where touch.type == UITouchType.Stylus else
        {
            return
        }
        
        update(weight: touch.force, touchLocation: touch.locationInView(view))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        zeroButton.enabled = false
        
        update(weight: 0, touchLocation: nil)
    }
    
    func zeroWeight()
    {
        baseWeight = weight
        
        update(weight: weight, touchLocation: touchLocation)
    }
    
    func update(weight weight: CGFloat, touchLocation: CGPoint?)
    {
        self.weight = weight
        self.touchLocation = touchLocation
    }
    
    var baseWeight: CGFloat = 0
    
    var weight: CGFloat = 0
    {
        didSet
        {
            if weight == 0
            {
               nixieDigitDisplay.setValue(string: "--------")
            }
            else
            {
                nixieDigitDisplay.setValue(string: String(format: "%.1f", max(0, (weight - baseWeight) * 140)))
            }
        }
    }
    
    var touchLocation: CGPoint?
    {
        didSet
        {
            guard let touchLocation = touchLocation else
            {
                shapeLayer.path = nil
                return
            }
            
            let bezierPath = UIBezierPath(ovalInRect: CGRect(x: touchLocation.x - 100,
                y: touchLocation.y - 100,
                width: 200,
                height: 200))
            
            shapeLayer.path = bezierPath.CGPath
        }
    }
    
}

class ZeroButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setTitle("Zero", forState: UIControlState.Normal)
        titleLabel?.font = UIFont.boldSystemFontOfSize(36)
        
        setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: super.intrinsicContentSize().width + 20,
            height: super.intrinsicContentSize().height + 10)
    }
}

