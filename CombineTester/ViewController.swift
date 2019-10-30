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
            print("Switch set: \(toggle.isOn)")
        }.store(in: &subscriptions)
        
        segmentedControl.publisher().sink { (segment) in
            print("SegmentedControl selected: \(segment.titleForSegment(at: segment.selectedSegmentIndex) ?? "")")
        }.store(in: &subscriptions)
        
        textField.publisher().sink { (textField) in
            print("TextField text: \(textField.text ?? "")")
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
        
        Just("Testing")
            .merge(with:
               button.publisher().map{ "Button: \($0.titleLabel?.text ?? "")" },
               toggle.publisher().map{ "Switch: \($0.isOn)" },
               segmentedControl.publisher().map{ "SegmentedControl: \($0.titleForSegment(at: $0.selectedSegmentIndex) ?? "")" },
               textField.publisher().map {
                    $0.resignFirstResponder()
                    return "TextField: \($0.text ?? "")"
               },
               slider.publisher().debounce(for: 0.1, scheduler: RunLoop.current).map{ "Slider: \($0.value)" },
               stepper.publisher().map{ "Stepper: \($0.value)" },
               pickerSource.$selected.removeDuplicates().map { "Picker: \($0)" }
            )
            .sink { (string) in
                print(string)
        }.store(in: &subscriptions)
        
        pickerView.dataSource = pickerSource
        pickerView.delegate = pickerSource
    }
}
