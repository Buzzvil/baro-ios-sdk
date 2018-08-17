//
//  DateSelectorViewController.swift
//  BuzzNativeSample
//
//  Created by MinJun KOO on 03/08/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit

protocol DateSelectorDelegate {
  func dateSelector(_ dateSelector: DateSelectorViewController, didSelectDate date: Date)
}

class DateSelectorViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var saveDateButton: UIButton!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var delegate: DateSelectorDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func saveDateAction(_ sender: Any) {
    if let date: Date = datePicker?.date {
      delegate?.dateSelector(self, didSelectDate: date)
    }
    dismiss(animated: true)
  }
}
