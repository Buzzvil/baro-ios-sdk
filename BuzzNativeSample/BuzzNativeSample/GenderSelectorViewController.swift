//
//  GenderSelectorViewController.swift
//  BuzzNativeSample
//
//  Created by MinJun KOO on 03/08/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit

protocol GenderSelectorDelegate {
  func genderSelector(_ dateSelector: GenderSelectorViewController, didSelectGender gender: String)
}

class GenderSelectorViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genderPicker: UIPickerView!
  @IBOutlet weak var saveButton: UIButton!
  
  var pickerData: [String] = []
  var delegate: GenderSelectorDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.genderPicker.delegate = self
    self.genderPicker.dataSource = self
    
    pickerData = ["None", "Male", "Female"]
  }
  
  @IBAction func saveGender(_ sender: Any) {
    let gender = pickerData[genderPicker.selectedRow(inComponent: 0)]
    delegate?.genderSelector(self, didSelectGender: gender)
    
    dismiss(animated: true)
  }
}

extension GenderSelectorViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
}

extension GenderSelectorViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
}
