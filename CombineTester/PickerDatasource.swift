//
//  PickerDatasource.swift
//  CombineTester
//
//  Created by Hannes Sverrisson on 27/10/2019.
//  Copyright © 2019 Hannes Sverrisson. All rights reserved.
//

import Foundation
import UIKit

typealias pickerDataType = String

class PickerSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    @Published var selected: pickerDataType
    var components: [[pickerDataType]] = [["Cupertino", "San Francisco", "London", "Paris"]]
    
    override init() {
        selected = components[0][0]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        components[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        components[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = components[component][row]
    }
}
