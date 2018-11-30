//
//  SecondADViewController.swift
//  BAROSample
//
//  Created by MinJun KOO on 31/07/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import UIKit
import BARO

class SecondADViewController: UITableViewController {
  var adLoader: BAROAdLoader!

  override func viewDidLoad() {
    super.viewDidLoad()
    adLoader = BAROAdLoader(unitId: "158465089741792", preloadEnabled: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    tableView.estimatedRowHeight = 500
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

      customCell.adView.renderAd(nil)

      adLoader.loadAd(
        with: BAROUserProfile(birthday: birthday, gender: BAROUserGenderMale),
        location: BAROLocation(latitude: 37.53457, longitude: 128.23423) // optional
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

extension SecondADViewController: BAROAdViewDelegate {
  func baroAdViewDidImpressed(_ adView: BAROAdView) {
    self.parent?.view.makeToast("Impressed!")
  }

  func baroAdViewDidClicked(_ adView: BAROAdView) {
    self.parent?.view.makeToast("Clicked!")
  }
}
