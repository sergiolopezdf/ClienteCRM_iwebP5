//
//  SalesmenTableViewController.swift
//  CRMClient
//
//  Created by Sergio López on 21/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class AllVisitsTableViewController: UITableViewController {
    
    let token = "6bac0f89326e4c92d000"
    let targetURL = "https://dcrmt.herokuapp.com/api/visits/flattened?token="
    var stringURL = ""
    var visits: [Visits] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        stringURL = "\(targetURL)\(token)"
        guard let salesmen = getDataFromJSON() else {
            print("No data from JSON")
            return
        }
        
        self.visits = salesmen
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsCell", for: indexPath)
        
        cell.textLabel?.text = visits[indexPath.row].Customer.name
        cell.detailTextLabel?.text = visits[indexPath.row].Salesman.fullname
        cell.imageView?.image = UIImage(named: "head-512")
        
        return cell
    }
 
    private func getDataFromJSON() -> [Visits]? {
        guard let url = URL(string: stringURL)  else {
            print("Error en la URL")
            return nil
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error en la descarga del JSON")
            return nil
        }

        let decoder = JSONDecoder()
    
        guard let decodedSalesman = try? decoder.decode([Visits].self, from: data) else {
            print("JSON no decodificado")
            return nil
        }
        
        return decodedSalesman
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
