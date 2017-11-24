//
//  MainTableViewController.swift
//  CRMClient
//
//  Created by Sergio López on 23/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var existsBeginDate = false
    var existsEndDate = false
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkUserDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Total"
        } else {
            return "Usuario"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Todas las visitas"
        }
            
        if indexPath.section == 1 {
            if indexPath.row == 0{
                cell.textLabel?.text = "Todas mis visitas"
            }
            
            if indexPath.row == 1 {
                cell.textLabel?.text = "Mis visitas favoritas"
            }
        }
        
        return cell
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToVisitsTVC" {
            if existsEndDate && existsBeginDate {
                return true
            } else {
                let alert = UIAlertController(title: "Oops...", message: "No has establecido las fechas. Tienes que seleccionarlas primero.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default))
                present(alert,animated: true)
                return false
            }
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let token = "6bac0f89326e4c92d000"
        let allVisitsURL = "https://dcrmt.herokuapp.com/api/visits/flattened?token="
        let myVisitsURL = "https://dcrmt.herokuapp.com/api/users/tokenOwner/visits/flattened?token="
        let myFavVisitsURL = "&favourites=1"
        
        
        let indexPath = tableView.indexPathForSelectedRow
        
        
        if segue.identifier == "goToVisitsTVC" {
            guard let vtvc = segue.destination as? VisitsTableViewController else {
                //UIAlert!
                return
            }
            
            if indexPath?.section == 0 {
                vtvc.stringURL = "\(allVisitsURL)\(token)"
                vtvc.headerText = "Todas las visitas"
                vtvc.kindOfRequest = .AllVisits
                return
            }
            
            if indexPath?.section == 1 {
                if indexPath?.row == 0 {
                    vtvc.stringURL = "\(myVisitsURL)\(token)"
                    vtvc.headerText = "Mis visitas"
                    vtvc.kindOfRequest = .MyVisits
                    return
                }
                if indexPath?.row == 1 {
                    vtvc.stringURL = "\(myVisitsURL)\(token)\(myFavVisitsURL)"
                    vtvc.headerText = "Mis visitas favoritas"
                    vtvc.kindOfRequest = .MyFavVisits
                    return
                }
                
            }
            
        }
        
    }
    
    @IBAction func goBackMain (_ segue: UIStoryboardSegue) {
        checkUserDefaults()
    }
    
    private func checkUserDefaults () {
        if let bDate = defaults.object(forKey: "beginDate") as? Date {
            beginDate = bDate
            existsBeginDate = true
        }
        
        if let eDate = defaults.object(forKey: "endDate") as? Date {
            endDate = eDate
            existsEndDate = true
        }
    }
    

}
