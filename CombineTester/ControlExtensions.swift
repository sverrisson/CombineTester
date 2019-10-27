//
//  ControlExtensions.swift
//  CombineTester
//
//  Created by Hannes Sverrisson on 27/10/2019.
//  Copyright © 2019 Hannes Sverrisson. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension CombineCompatible where Self: UISwitch {
    func publisher() -> ControlPublisher<UISwitch> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}

extension CombineCompatible where Self: UIButton {
    func publisher() -> ControlPublisher<UIButton> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}

extension CombineCompatible where Self: UISegmentedControl {
    func publisher() -> ControlPublisher<UISegmentedControl> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}

extension CombineCompatible where Self: UITextField {
    func publisher() -> ControlPublisher<UITextField> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}

extension CombineCompatible where Self: UISlider {
    func publisher() -> ControlPublisher<UISlider> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}

extension CombineCompatible where Self: UIStepper {
    func publisher() -> ControlPublisher<UIStepper> {
        ControlPublisher(control: self, events: .primaryActionTriggered)
    }
}
