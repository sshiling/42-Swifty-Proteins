//
//  TableViewController.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/13/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import SVProgressHUD

class TableViewController: UITableViewController {
    
    var data: [String] = []
    var tempData: [String] = []
    let url = "http://rest.rcsb.org/rest/ligands/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempData = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        let headers: HTTPHeaders = ["Accept": "application/json"]
        Alamofire.request(self.url + tempData[indexPath.row], method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                let parsedData = JSON(response.value!)
                print(parsedData)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToScene", sender: self)
            case .failure:
                SVProgressHUD.dismiss()
                self.showAlertController("Error getting data")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if !tempData[indexPath.row].isEmpty {
            cell.ligoldName.text = tempData[indexPath.row]
        }
        return cell
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Search bar methods
extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            tempData = data.filter{$0.localizedCaseInsensitiveContains(searchBar.text!)}
        } else {
            tempData = data
        }
        tableView.reloadData()
    }
}







