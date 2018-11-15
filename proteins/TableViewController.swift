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
    
    var names: [String] = []
    var filteredNames: [String] = []
    var allAtoms: [SCNNode] = []
    var allCoords = [[(x: Float, y: Float, z: Float)]]()
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    @IBAction func randProtein(_ sender: UIBarButtonItem) {
        getPDBDataAndShowProtein(proteinIndex: Int(arc4random_uniform(UInt32(filteredNames.count))))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredNames = names
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        backgroundView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = backgroundView
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
//        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        cell.backgroundColor = UIColor.clear
        cell.ligoldName.text = filteredNames[indexPath.row]
        cell.ligoldName.textColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        
        getPDBDataAndShowProtein(proteinIndex: indexPath.row)
    }
    
    func getPDBDataAndShowProtein(proteinIndex index: Int) {
        
//        print ("Index: \(index). Protein name: \(filteredNames[index])")
//        for name in 0...(filteredNames.count - 1) { print ("\(name) \(filteredNames[name])") }
        
        SVProgressHUD.show()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("ligolds.txt")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download("http://files.rcsb.org/ligands/view/\(filteredNames[index])_ideal.pdb", to: destination).response { response in
            if response.error == nil, let imagePath = response.destinationURL?.path {
                do {
                    var atomCord: [Atom] = []
                    let fullText = try String(contentsOfFile: imagePath, encoding: String.Encoding.utf8)
                    let textArr = fullText.components(separatedBy: .newlines)
                    for line in textArr {
                        if line.contains("ATOM"){
                            let elem = line.components(separatedBy: " ").filter({!$0.isEmpty})
                            let newAtom = Atom(elem[1], elem[6], elem[7], elem[8], elem[11])
                            atomCord.append(newAtom)
                            self.allAtoms.append(newAtom.makeAtom())
                        }
                        else if line.contains("CONECT"){
                            var coordinates:[(x: Float, y: Float, z: Float)] = []
                            let elem = line.components(separatedBy: " ").filter({!$0.isEmpty})
                            for i in 1...elem.count - 1{
                                let currConnect = atomCord[Int(elem[i])! - 1]
                                coordinates.append((x: currConnect.x, y: currConnect.y, z: currConnect.z))
                            }
                            self.allCoords.append(coordinates)
                        }
                    }
                    self.performSegue(withIdentifier: "goToScene", sender: self)
                    self.tableView.isUserInteractionEnabled = true
                } catch {
                    SVProgressHUD.dismiss()
                    self.tableView.isUserInteractionEnabled = true
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScene" {
            let destinationVC = segue.destination as! SceneViewController
            destinationVC.sceneData = allAtoms
            destinationVC.cordData = allCoords
            allAtoms = []
            allCoords = []
        }
        SVProgressHUD.dismiss()
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
            filteredNames = names.filter{$0.localizedCaseInsensitiveContains(searchBar.text!)}
        } else {
            filteredNames = names
        }
        tableView.reloadData()
    }
}







