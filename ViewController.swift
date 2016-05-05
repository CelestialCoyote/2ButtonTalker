//
//  ViewController.swift
//  2ButtonTalker
//
//  Created by Paul Stearns on 4/15/16.
//  Copyright © 2016 Coyote. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    
    let positiveKey: String = "positiveKey"
    let negativeKey: String = "negativeKey"
    
    let swipeRec            = UITapGestureRecognizer()
    var swipeIndex          = 0;
    
    let smileFace: String   = "\n🙂"
    let frownFace: String   = "\n🙁"
    
    let synthVoice = AVSpeechSynthesizer()
    var synthSpeak = AVSpeechUtterance(string: "")
    
    private func possibleAnswersMap() -> [[String : String]] {
        return [
            [
                positiveKey: "Yes" + smileFace,
                negativeKey: "No" + frownFace
            ],
            [
                positiveKey: "Like" + smileFace,
                negativeKey: "Don't Like" + frownFace
            ],
            [
                positiveKey: "More" + smileFace,
                negativeKey: "Done" + frownFace
            ],
            [
                positiveKey: "Happy" + smileFace,
                negativeKey: "Sad" + frownFace
            ]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Mark:  Set button style.
        
        positiveButton.layer.cornerRadius           = 15.0
        positiveButton.layer.borderWidth            = 5.0
        positiveButton.layer.borderColor            = UIColor.whiteColor().CGColor
        
        negativeButton.layer.cornerRadius           = 15.0
        negativeButton.layer.borderWidth            = 5.0
        negativeButton.layer.borderColor            = UIColor.whiteColor().CGColor

        
        // Mark:  Set button text properties.
        
        let answersMap = possibleAnswersMap();
        
        let positiveResponse = answersMap[0][positiveKey]
        let negativeResponse = answersMap[0][negativeKey]
        
        positiveButton.setTitle(positiveResponse, forState: UIControlState.Normal)
        positiveButton.titleLabel?.textAlignment    = NSTextAlignment.Center
        
        negativeButton.setTitle(negativeResponse, forState: UIControlState.Normal)
        negativeButton.titleLabel?.textAlignment    = NSTextAlignment.Center


        // MARK: Add swipe gesture recognizer.
        
        let swipeGestureDown: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen))
        let swipeGestureUp: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen))
        let swipeGestureLeft: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen))
        let swipeGestureRight: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(swipeScreen))
        
        swipeGestureDown.numberOfTouchesRequired    = 1
        swipeGestureUp.numberOfTouchesRequired      = 1
        swipeGestureLeft.numberOfTouchesRequired    = 1
        swipeGestureRight.numberOfTouchesRequired   = 1
        
        swipeGestureDown.direction      = .Down
        swipeGestureUp.direction        = .Up
        swipeGestureLeft.direction      = .Left
        swipeGestureRight.direction     = .Right
        
        self.view.addGestureRecognizer(swipeGestureDown)
        self.view.addGestureRecognizer(swipeGestureUp)
        self.view.addGestureRecognizer(swipeGestureLeft)
        self.view.addGestureRecognizer(swipeGestureRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Mark:  Change StackView axis by device orientation.
    
    override func viewDidLayoutSubviews()
    {
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
    
    
    // Mark:  Swipe Actions
    
    func swipeScreen(gesture: UISwipeGestureRecognizer) -> Void {
        print("Gesture: \(gesture)")
        
        let maxOffset = possibleAnswersMap().count - 1
        
        // Reset going up.
        if (swipeIndex < 0) {
            swipeIndex = 0;
        }
        
        // Reset going down.
        if (swipeIndex > maxOffset) {
            swipeIndex = -1;
        }
        
        switch (gesture.direction) {
        case UISwipeGestureRecognizerDirection.Up:
            swipeIndex -= 1
            
            if (swipeIndex < 0) {
                swipeIndex = maxOffset
            }
            break
            
        case UISwipeGestureRecognizerDirection.Down:
            swipeIndex += 1
            
            if (swipeIndex > maxOffset) {
                swipeIndex = 0
            }
            break
            
        case UISwipeGestureRecognizerDirection.Left:
            swipeIndex += 1
            
            if (swipeIndex > maxOffset) {
                swipeIndex = 0
            }
            break
            
        case UISwipeGestureRecognizerDirection.Right:
            swipeIndex -= 1
            
            if (swipeIndex < 0) {
                swipeIndex = maxOffset
            }
            break
            
        default:
            break
        }
        // Determine the direction swiped, and if at the beginning or end of the answers array map.
        let checkOffset = min(max(maxOffset, swipeIndex), swipeIndex);
        
        positiveButton.setTitle(possibleAnswersMap()[checkOffset][positiveKey],
                                forState: UIControlState.Normal)
        negativeButton.setTitle(possibleAnswersMap()[checkOffset][negativeKey],
                                forState: UIControlState.Normal)
        print("offsets: check: \(checkOffset) -> swipeIndex: \(swipeIndex)")
        
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
        
        customAnimation.repeatCount     = 1.0
        customAnimation.duration        = 0.75
        customAnimation.autoreverses    = true
        customAnimation.delegate        = self
        customAnimation.values          = [fromAlpha, toAlpha]
        
        customAnimation.calculationMode = kCAAnimationPaced;
        
        button.layer.addAnimation(customAnimation, forKey: "buttonAnimation")
    }


    // MARK: Button Actions
    
    @IBAction func positiveButtonAction(sender: UIButton) {
        let firstAlpha:  Float  = 1.0
        let secondAlpha: Float  = 0.3
        
        self.animatedButton(sender, fromAlpha: firstAlpha, toAlpha: secondAlpha)
        
        let buttonText      = positiveButton.currentTitle!
        let noSmileText     = buttonText.stringByReplacingOccurrencesOfString(smileFace, withString: "")
        
        self.textToSpeech(sender, speakText: noSmileText)
    }
    
    @IBAction func negativeButtonAction(sender: UIButton) {
        let firstAlpha:  Float  = 1.0
        let secondAlpha: Float  = 0.3
        
        self.animatedButton(sender, fromAlpha: firstAlpha, toAlpha: secondAlpha)
        
        let buttonText      = negativeButton.currentTitle!
        let noFrownText     = buttonText.stringByReplacingOccurrencesOfString(frownFace, withString: "")
        
        self.textToSpeech(sender, speakText: noFrownText)
    }
    
    
    // Mark:  Button speak.
    
    func textToSpeech(button: UIButton, speakText: String) -> Void {
        synthSpeak          = AVSpeechUtterance(string: speakText)
        synthSpeak.rate     = 0.375
        synthVoice.speakUtterance(synthSpeak)
    }
    
    
    func swipedView(){
        let tapAlert = UIAlertController(title: "Swiped",
                                         message: "You just swiped the swipe view",
                                         preferredStyle: UIAlertControllerStyle.Alert)
        
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }

}

