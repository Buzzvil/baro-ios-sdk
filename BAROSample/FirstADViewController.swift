//
//  FirstADViewController.swift
//  BAROSample
//
//  Created by MinJun KOO on 31/07/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit
import BARO

class FirstADViewController: UIViewController {

  @IBOutlet weak var adView: BAROAdView!
  @IBOutlet weak var containerAdView: UIView!

  var date: Date?
  var gender: BAROUserGender = BAROUserGenderUnknown

  var adLoader: BAROAdLoader!

  override func viewDidLoad() {
    super.viewDidLoad()

    adLoader = BAROAdLoader(unitId: "158465089741792", preloadEnabled: false)
  }

  @IBAction func fetchAds(_ sender: Any) {
    var birthday: Date?

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = self.date { birthday = date }

    adLoader.loadAd(with: BAROUserProfile(birthday: birthday, gender: self.gender), location: nil) { [weak self] (ad, error) in
      if let ad = ad {
        self?.adView.delegate = self
        self?.adView.renderAd(ad)
      } else {
        //        Handle error
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

extension FirstADViewController: BAROAdViewDelegate {
  func baroAdViewDidImpressed(_ adView: BAROAdView) {
    self.view.makeToast("Impressed!")
  }

  func baroAdViewDidClicked(_ adView: BAROAdView) {
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
      self.gender = BAROUserGenderMale
      break
    case "Female":
      self.gender = BAROUserGenderFemale
      break
    default:
      self.gender = BAROUserGenderUnknown
    }

    let toastStr: String = "Change Gender : " + gender
    self.view.makeToast(toastStr)
  }
}
