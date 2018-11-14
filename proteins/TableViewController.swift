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
import SceneKit
import ChameleonFramework

class TableViewController: UITableViewController {
    
    var data: [String] = []
    var tempData: [String] = []
    var atomData: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempData = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        atomData = []
        SVProgressHUD.show()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("ligolds.txt")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download("http://files.rcsb.org/ligands/view/\(tempData[indexPath.row])_ideal.pdb", to: destination).response { response in
            if response.error == nil, let imagePath = response.destinationURL?.path {
                do {
                    print(imagePath)
                    let fullText = try String(contentsOfFile: imagePath, encoding: String.Encoding.utf8)
                    print(fullText)
                    let textaArr = fullText.components(separatedBy: .newlines)
                    for line in textaArr {
                        if line.contains("ATOM"){
                            let elem = line.components(separatedBy: " ").filter({!$0.isEmpty})
                            let newAtom = Atom(elem[1], elem[6], elem[7], elem[8], elem[11])
                            self.atomData.append(newAtom.makeAtom())
                        }
                    }
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToScene", sender: self)
                } catch {
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScene" {
            let destinationVC = segue.destination as! SceneViewController
            destinationVC.sceneData = atomData
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







