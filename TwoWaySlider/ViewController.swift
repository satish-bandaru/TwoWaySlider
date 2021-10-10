//
//  ViewController.swift
//  TwoWaySlider
//
//  Created by Satish Bandaru on 10/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var twoWaySlider: UISlider!
    @IBOutlet var fillerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var fillerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var fillerView: UIView!
    
    let backgroundTint: UIColor = UIColor(white: 238 / 255, alpha: 1.0)
    let fillerTint: UIColor = UIColor(red: 0/255, green: 103/255, blue: 160/255, alpha: 1.0)
    
    var startValue: Float = 0
    var endValue: Float = 100
    
    var midValue: Float {
        (startValue + endValue) / 2
    }
    
    /// Calculates the scale of the slider to normalize the slider's range to the slider's width
    /// By dividing the width of the slider by its total range
    var sliderScale: Float {
        let range = endValue - startValue
        return Float(twoWaySlider.layer.frame.width) / range
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupSlider()
        
        fillerView.backgroundColor = fillerTint
        fillerView.layer.cornerRadius = 4
    }

    func setupSlider() {
        twoWaySlider.minimumValue = startValue
        twoWaySlider.maximumValue = endValue

        twoWaySlider.value = midValue // Start slider at the center

        twoWaySlider.maximumTrackTintColor = backgroundTint
        twoWaySlider.minimumTrackTintColor = backgroundTint
        twoWaySlider.thumbTintColor = fillerTint
        twoWaySlider.tintColor = backgroundTint

        twoWaySlider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        /// The thumb should snap to center, on reaching close to the center +-2.
        /// This is to indicate that it has been set back to starting value
        if (slider.value - midValue) > -2 && (slider.value - midValue) < 2 {
            slider.value = midValue
        }

        /// This is the distance between the slider's thumb and the center
        /// The `fillColorView`'s width should be equal to this distance multiplied by the scale of the slider
        let distanceFromCenter = slider.value - midValue
        let fillColorViewWidth = distanceFromCenter * sliderScale

        if slider.value > midValue {
            /// If the thumb is to the right of slider's center, then the leading constraint sticks to center
            /// The trailing constraint moves by a constant value of `fillColorViewWidth`
            self.fillerLeadingConstraint.constant = 0
            self.fillerTrailingConstraint.constant = CGFloat(fillColorViewWidth) - 5
        } else if slider.value < midValue {
            /// If the thumb is to the left of slider's center, then the trailing constraint sticks to center
            /// The leading constraint moves by a constant value of `fillColorViewWidth`
            self.fillerLeadingConstraint.constant = CGFloat(fillColorViewWidth) + 5
            self.fillerTrailingConstraint.constant = 0
        } else {
            self.fillerLeadingConstraint.constant = 0
            self.fillerTrailingConstraint.constant = 0
        }

        print(slider.value)
    }
}
