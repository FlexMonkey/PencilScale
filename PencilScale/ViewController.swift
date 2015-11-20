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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.darkGrayColor()
        
        view.addSubview(zeroButton)
        view.addSubview(nixieDigitDisplay)
        
        nixieDigitDisplay.setValue(string: "--------")
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
        guard let touch = touches.first else //  where touch.type == UITouchType.Stylus else
        {
            return
        }
        
        nixieDigitDisplay.setValue(float: 100 * Float(drand48()))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch = touches.first else //  where touch.type == UITouchType.Stylus else
        {
            return
        }
        
        nixieDigitDisplay.setValue(float: 100 * Float(drand48()))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        nixieDigitDisplay.setValue(string: "--------")
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

