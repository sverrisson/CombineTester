//
//  ViewController.swift
//  CombineTester
//
//  Created by Hannes Sverrisson on 24/10/2019.
//  Copyright © 2019 Hannes Sverrisson. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var subscriptions: Set<AnyCancellable> = []
    private var pickerSource = PickerSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test interaction
        button.publisher().sink { (button) in
            print("Button tapped: \(button.titleLabel?.text ?? "")")
        }.store(in: &subscriptions)
        
        toggle.publisher().sink { (toggle) in
            print("Switch: \(toggle.isOn)")
        }.store(in: &subscriptions)
        
        segmentedControl.publisher().sink { (segment) in
            print("Segment: \(segment.titleForSegment(at: segment.selectedSegmentIndex) ?? "")")
        }.store(in: &subscriptions)
        
        textField.publisher().sink { (textField) in
            print("TextField: \(textField.text ?? "")")
            textField.resignFirstResponder()
        }.store(in: &subscriptions)
        
        slider.publisher()
            .debounce(for: 0.1, scheduler: RunLoop.current)
            .sink { (slider) in
                print("Slider value: \(slider.value)")
        }.store(in: &subscriptions)
        
        stepper.publisher().sink { (stepper) in
            print("Stepper value: \(stepper.value)")
        }.store(in: &subscriptions)
        
        pickerView.dataSource = pickerSource
        pickerView.delegate = pickerSource
        pickerSource.$selected
            .removeDuplicates()
            .sink { (pickerData) in
                print("Picker selected: \(pickerData)")
        }.store(in: &subscriptions)
    }
}
