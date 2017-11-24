//
//  DateSelectorsViewController.swift
//  CRMClient
//
//  Created by Sergio López on 24/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class DateSelectorsViewController: UIViewController {

    
    @IBOutlet var beginDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bDate = defaults.object(forKey: "beginDate") as? Date {
            beginDatePicker.date = bDate
        }
        
        if let eDate = defaults.object(forKey: "endDate") as? Date {
            endDatePicker.date = eDate
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goBackMain" {
            if endDatePicker.date > beginDatePicker.date {
                return true
            } else {
                let alert = UIAlertController(title: "Oops...", message: "La fecha final es previa a la incial. Selecciona otra fecha", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default))
                present(alert,animated: true)
                return false
            }
        }
        return true
    }
 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackMain" {
            defaults.set(beginDatePicker.date, forKey: "beginDate")
            defaults.set(endDatePicker.date, forKey: "endDate")
            defaults.synchronize()
            
        }
    }
    

}
