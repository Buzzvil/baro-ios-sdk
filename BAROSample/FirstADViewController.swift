//
//  FirstADViewController.swift
//  BAROSample
//
//  Created by MinJun KOO on 31/07/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit
import BARO
import ToastSwiftFramework

class FirstADViewController: UIViewController {
  
  @IBOutlet weak var adView: BNAdView!
  @IBOutlet weak var containerAdView: UIView!
  
  var date: Date?
  var gender: BNUserGender = BNUserGender.unknown
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func fetchAds(_ sender: Any) {
    var birthday: Date?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = self.date { birthday = date }
    
    let adLoader = BNAdLoader(unitId: "298291760569861")
    adLoader.loadAd(userProfile: BNUserProfile(birthday: birthday, gender: self.gender)) { [weak self] (ad, error) in
      if let ad = ad {
        self?.adView.delegate = self
        self?.adView.renderAd(ad)
      } else {
        //Handle error
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "selectDate" {
      let viewController: DateSelectorViewController = segue.destination as! DateSelectorViewController
      viewController.delegate = self
    }
    if segue.identifier == "selectGender" {
      let viewController: GenderSelectorViewController = segue.destination as! GenderSelectorViewController
      viewController.delegate = self
    }
  }
}

extension FirstADViewController: BNAdViewDelegate {
  func adViewDidImpressed(adView: BNAdView) {
    self.view.makeToast("Impressed!")
  }
  
  func adViewDidClicked(adView: BNAdView) {
    self.view.makeToast("Clicked!")
  }
}

extension FirstADViewController: DateSelectorDelegate {
  func dateSelector(_ dateSelector: DateSelectorViewController, didSelectDate date: Date) {
    self.date = date
    
    if let date = self.date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let toastStr: String = "Change Date : " + dateFormatter.string(from: date)
      
      self.view.makeToast(toastStr)
    }
  }
}

extension FirstADViewController: GenderSelectorDelegate {
  func genderSelector(_ dateSelector: GenderSelectorViewController, didSelectGender gender: String) {
    switch (gender) {
    case "Male":
      self.gender = BNUserGender.male
      break
    case "Female":
      self.gender = BNUserGender.female
      break
    default:
      self.gender = BNUserGender.unknown
    }
    
    let toastStr: String = "Change Gender : " + gender
    self.view.makeToast(toastStr)
  }
}
