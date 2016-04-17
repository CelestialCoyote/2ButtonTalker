//
//  ViewController.swift
//  2ButtonTalker
//
//  Created by Paul Stearns on 4/15/16.
//  Copyright © 2016 Coyote. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let buttonStack                     = UIStackView()
    
    let positiveButton                  = UIButton()
    let negativeButton                  = UIButton()
    
    let swipeRec = UITapGestureRecognizer()
    
    // Could only get text from dictionary with one key, one value.
    var positiveResponses = [
        "positive1": "Yes",
        "positive2": "Like",
        "positive3": "Done",
        "positive4": "Happy"
    ]
    
    var negativeResponses = [
        "negative1": "No",
        "negative2": "Don't Like",
        "negative3": "More",
        "negative4": "Sad"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonStack)
        
        view.backgroundColor                = UIColor.blackColor()
        buttonStack.backgroundColor         = UIColor.blackColor()
        
        positiveButton.backgroundColor      = UIColor.greenColor()
        positiveButton.layer.cornerRadius   = 15.0
        positiveButton.layer.borderWidth    = 5.0
        positiveButton.layer.borderColor    = UIColor.whiteColor().CGColor
        positiveButton.addTarget(self, action: #selector(ViewController.positiveButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        negativeButton.backgroundColor      = UIColor.redColor()
        negativeButton.layer.cornerRadius   = 15.0
        negativeButton.layer.borderWidth    = 5.0
        negativeButton.layer.borderColor    = UIColor.whiteColor().CGColor
        negativeButton.addTarget(self, action: #selector(ViewController.negativeButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //let positiveText = NSLocalizedString("ANSWER_YES", comment: "Yes")
        let negativeText = NSLocalizedString("ANSWER_NO", comment: "No")
        
        // Mark:  Setup buttons for initial startup.
        
        // Would still like to have button text be as large as possible,
        // but cannot get it to work correctly.
        // Would also like text to always be two lines.
        // Top line would be text from dictionary or user set text.
        // Bottom line would be emoji smiley face or frowning face.
        
        positiveButton.setTitle(positiveResponses["positive1"], forState: UIControlState.Normal)
        //positiveButton.titleLabel?.font = UIFont.boldSystemFontOfSize(28)
        positiveButton.titleLabel?.numberOfLines = 1
        positiveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        positiveButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByClipping
        positiveButton.accessibilityLabel       = positiveResponses["positive1"]
        positiveButton.isAccessibilityElement   = true
        
        negativeButton.setTitle(negativeText, forState: UIControlState.Normal)
        negativeButton.accessibilityLabel       = negativeText
        negativeButton.isAccessibilityElement   = true
        
        buttonStack.addArrangedSubview(positiveButton)
        buttonStack.addArrangedSubview(negativeButton)
        
        buttonStack.axis                    = UILayoutConstraintAxis.Vertical
        buttonStack.distribution            = UIStackViewDistribution.FillEqually
        buttonStack.spacing                 = 20
        
        // MARK: Add swipe gesture recognizer.
        
        // Found some examples online.
        // Not sure it is being implemented correctly.

/*      let swipeView: UIView
        swipeView.addTarget(self, action: #selector(ViewController.swipeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        swipeRec.addTarget(self, action: #selector(ViewController.swipedView))
        swipeView.addGestureRecognizer(swipeRec)
        swipeView.userInteractionEnabled = true
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        let top = topLayoutGuide.length
        let bottom = bottomLayoutGuide.length
        
        buttonStack.frame = CGRect(
            x: 0,
            y: top,
            width: view.frame.width,
            height: view.frame.height - top - bottom
            ).insetBy(dx: 20, dy: 20)
        
        dispatch_async(dispatch_get_main_queue())
        {
            if self.view.frame.height > self.view.frame.width
            {
                self.buttonStack.axis   = UILayoutConstraintAxis.Vertical
            }
            else
            {
                self.buttonStack.axis   = UILayoutConstraintAxis.Horizontal
            }
        }
    }
    
    
    // MARK: CAAnimation Delegate
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            print("Animation completed!")
            
            self.positiveButton.enabled                 = true
            self.negativeButton.enabled                 = true
            
            self.positiveButton.userInteractionEnabled  = true
            self.negativeButton.userInteractionEnabled  = true
            
            print("Animation Debug Description: \(anim.debugDescription)")
        }
    }
    
    
    // MARK: Animation
    
    func animatedButton(button: UIButton, fromAlpha: Float, toAlpha: Float) -> Void {
        button.userInteractionEnabled = false;
        
        self.positiveButton.enabled     = (button == self.positiveButton)
        self.negativeButton.enabled     = (button == self.negativeButton)
        
        let customAnimation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        
        customAnimation.repeatCount     = 3.0
        customAnimation.duration        = 0.3
        customAnimation.autoreverses    = true
        customAnimation.delegate        = self
        customAnimation.values          = [fromAlpha, toAlpha]
        
        customAnimation.calculationMode = kCAAnimationPaced;
        
        button.layer.addAnimation(customAnimation, forKey: "buttonAnimation")
    }


    // MARK: Button Actions
    
    func positiveButtonAction(sender: UIButton) {
        let firstAlpha:  Float          = 1.0
        let secondAlpha: Float          = 0.3
        
        self.animatedButton(sender, fromAlpha: firstAlpha, toAlpha: secondAlpha)
    }
    
    func negativeButtonAction(sender: UIButton) {
        let firstAlpha:  Float          = 1.0
        let secondAlpha: Float          = 0.3
        
        self.animatedButton(sender, fromAlpha: firstAlpha, toAlpha: secondAlpha)
    }
    
    func swipedView(){
        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    
    // Mark:  Swipe Actions
    
    func swipeAction() {
        // SwipeRight in portrait or SwipeDown in landscape -
        //      Get previous button response text from dictionary.
        // SwipeLeft in portrait or SwipeUp in landscape -
        //      Get next button response text from dictionary.
    }
}

