//
//  SecondADViewController.swift
//  BAROSample
//
//  Created by MinJun KOO on 31/07/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit
import BARO
import SwiftyJSON

class SecondADViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowCount = 100
    return rowCount + (rowCount / 4) // 광고가 4개당 1개의 광고 보여줌
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if(((indexPath.row - 1) % 10 == 3) || ((indexPath.row - 1) % 10 == 8)){
      let customCell = tableView.dequeueReusableCell(withIdentifier: "NativeADcell", for: indexPath) as! CustomTableViewCell
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let birthday = dateFormatter.date(from: "1988-02-28")
      
      let adLoader = BRAdLoader(unitId: "298291760569861")
      adLoader.loadAd(
        userProfile: BRUserProfile(birthday: birthday, gender: .male),
        location: BRLocation(latitude: 37.53457, longitude: 128.23423) // optional
        ) { [weak self] (ad, error) in
        if let ad = ad {
          customCell.adView.delegate = self // optional
          customCell.adView.renderAd(ad)
        } else {
          // Handle error
        }
      }
      return customCell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
      cell.textLabel?.text = "Content"
      cell.detailTextLabel?.text = String((indexPath.row) - (indexPath.row / 5))
      
      return cell
    }
  }
}

extension SecondADViewController: BRAdViewDelegate {
  func adViewDidImpressed(adView: BRAdView) {
    self.parent?.view.makeToast("Impressed!")
  }
  
  func adViewDidClicked(adView: BRAdView) {
    self.parent?.view.makeToast("Clicked!")
  }
}
