//
//  ViewController.swift
//  CombineTester
//
//  Created by Hannes Sverrisson on 24/10/2019.
//  Copyright © 2019 Hannes Sverrisson. All rights reserved.
//

import UIKit
import Combine
import UICombine

class ViewController: UIViewController {
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var subscriptions: Set<AnyCancellable> = []
    private var pickerSource = PickerSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CombineTester"
        
        let stringPublisher = ["hello", "world"].publisher
        stringPublisher
            .delay(for: 0.0, scheduler: RunLoop.main)
            .map{$0.capitalized}
            .sink(receiveCompletion: { (completion) in
                print("Stringpublisher Completion: \(completion)")
            }) { (string) in
                print("Stringpublisher: \(string)")
        }.store(in: &subscriptions)
        
        print("Barbutton")
        barButton.publisher()
            .sink{ (item) in
                print("Barbutton tapped: \(item)")
        }.store(in: &subscriptions)
        
        // Test interaction
        print("Button")
        button.publisher()
            .print("B")
            .sink { (button) in
            print("Button tapped: \(button.titleLabel?.text ?? "")")
        }.store(in: &subscriptions)
        
        print("Switch")
        toggle.publisher().sink { (toggle) in
            print("Switch set: \(toggle.isOn)")
        }.store(in: &subscriptions)
        
        print("SegmentedControl")
        segmentedControl.publisher().sink { (segment) in
            print("SegmentedControl selected: \(segment.titleForSegment(at: segment.selectedSegmentIndex) ?? "")")
        }.store(in: &subscriptions)
        
        print("TextField")
        textField.publisher().sink { (textField) in
            print("TextField text: \(textField.text ?? "")")
            textField.resignFirstResponder()
        }.store(in: &subscriptions)
        
        textField.keyboardDidShow()
            .sink { (notification) in
            print("TextField Keyboard did appear: \(notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] ?? "")")
        }.store(in: &subscriptions)
        
        textField.keyboardWillHide().sink { (notification) in
            print("TextField Keyboard did hide: \(notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] ?? "")")
        }.store(in: &subscriptions)
        
        print("PasswordField")
        passwordField.publisher().sink { (textField) in
            print("Password Keyboard text: \(textField.text ?? "")")
            textField.resignFirstResponder()
        }.store(in: &subscriptions)
        
        passwordField.keyboardDidShow()
            .sink { (notification) in
            print("Password Keyboard did appear: \(notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] ?? "")")
        }.store(in: &subscriptions)
        
        passwordField.keyboardWillHide().sink { (notification) in
            print("Password Keyboard did hide: \(notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] ?? "")")
        }.store(in: &subscriptions)
        
        print("Slider")
        slider.publisher()
            .debounce(for: 0.1, scheduler: RunLoop.current)
            .sink { (slider) in
                print("Slider value: \(slider.value)")
        }.store(in: &subscriptions)
        
        print("Stepper")
        stepper.publisher().sink { (stepper) in
            print("Stepper value: \(stepper.value)")
        }.store(in: &subscriptions)
        
        print("PickerView")
        pickerView.dataSource = pickerSource
        pickerView.delegate = pickerSource
        pickerSource.$selected
            .removeDuplicates()
            .sink { (pickerData) in
                print("Picker selected: \(pickerData)")
        }.store(in: &subscriptions)
        
        print("Testing")
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
    }
}
