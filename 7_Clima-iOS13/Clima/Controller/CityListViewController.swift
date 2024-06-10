//
//  CityListViewController.swift
//  Clima
//
//  Created by 中佐徹也 on 2024/06/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!
    
    private let headerArray: [String] = ["山手線", "東横線", "田園都市線", "常磐線"]
        private let yamanoteArray: [String] = ["渋谷", "新宿", "池袋"]
        private let toyokoArray: [String] = ["自由ヶ丘", "日吉"]
        private let dentoArray: [String] = ["溝の口", "二子玉川"]
        private let jobanArray: [String] = ["上野"]

        private lazy var items = [
            rail(isShown: true, railName: self.headerArray[0], stationArray: self.yamanoteArray),
            rail(isShown: false, railName: self.headerArray[1], stationArray: self.toyokoArray),
            rail(isShown: false, railName: self.headerArray[2], stationArray: self.dentoArray),
            rail(isShown: false, railName: self.headerArray[3], stationArray: self.jobanArray)
        ]
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.dataSource = self
        cityTableView.delegate = self
        
    }
    
    // UITableViewDataSourceプロトコルの必須メソッド
    func numberOfSections(in tableView: UITableView) -> Int {
            return items.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
       cell.textLabel?.text = items[indexPath.section].stationArray[indexPath.row]
       return cell
   }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return items[section].railName
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //isShownの値によって、表示数を変更
            if items[section].isShown {
                return items[section].stationArray.count
            } else {
                return 0
            }
    }

}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UITableViewHeaderFooterView()
           //UITapGestureを定義する。Tapされた際に、headertappedを呼ぶようにしています。
           let gesture = UITapGestureRecognizer(target: self,
                                                action: #selector(headertapped(sender:)))
           //ここで、実際に、HeaderViewをセットします。
           headerView.addGestureRecognizer(gesture)

           headerView.tag = section
           return headerView
    }
    
  
    
    @objc func headertapped(sender: UITapGestureRecognizer) {
            //tagを持っていない場合は、guardします。
           guard let section = sender.view?.tag else {
               return
           }
           //値を反転させます。
           items[section].isShown.toggle()

           //これ以降で表示、非表示を切り替えます。
           cityTableView.beginUpdates()
           cityTableView.reloadSections([section], with: .automatic)
           cityTableView.endUpdates()
    }
        
    
    
}
