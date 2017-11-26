//
//  SalesmenTableViewController.swift
//  CRMClient
//
//  Created by Sergio López on 21/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class VisitsTableViewController: UITableViewController {
    
    var stringURL = ""
    var headerText = ""
    var visits: [Visits] = []
    var salesmanImg = [Int:UIImage]()
    
    @IBOutlet var navBar: UINavigationItem!
    
    //Necesitamos saber el tipo de petición. Por defecto, muestra todas las visitas
    var kindOfRequest: KindOfRequest = .AllVisits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.title = headerText
        
        getDataFromJSON()
        tableView.reloadData()
        
        
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
        
        //Actualizamos el texto de las celdas
        cell.textLabel?.text = visits[indexPath.row].Customer.name
        
        if kindOfRequest == .AllVisits {
            cell.detailTextLabel?.text = visits[indexPath.row].Salesman.fullname
        } else {
            let plannedFor = dateFormatter(visits[indexPath.row].plannedFor)
            cell.detailTextLabel?.text = plannedFor
        }
        cell.detailTextLabel?.textColor = UIColor.blue
        
        //Id del vendedor
        let salesmanId = visits[indexPath.row].Salesman.id
        
        //Si no hay URL de la foto, asignamos foto por defecto en el array
        guard let salesmanUrlStg = visits[indexPath.row].Salesman.Photo?.url else {
            cell.imageView?.image = UIImage(named: "head-512")
            return cell
        }
        
        //Si no existe la foto, te la descargas
        guard let img = salesmanImg[salesmanId]  else {
            getSalesmanImg(id: salesmanId, URLString: salesmanUrlStg, for: indexPath)
            return cell
        }
        
        //Siempre se cumple porque en la función getSalesmanImg haces reload de la celda
        
        //Asignas la foto del array a la celda
        cell.imageView?.image = img
        cell.imageView?.clipsToBounds = true
        
        cell.imageView?.isHighlighted = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Entre las fechas de inicio y final"
    }
    
    private func getDataFromJSON() {
        
        //Creamos cola global
        let session = URLSession.shared
        
        guard let url = URL(string: stringURL) else {
            print ("Error URL")
            return
        }
        
        //Siempre en MainThread
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    
        let task = session.dataTask(with: url) {(data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if (response as! HTTPURLResponse).statusCode != 200 {
                let alert = UIAlertController(title: "Error en la petición", message: "No se pudieron descargar los datos. Vuelve a intentarlo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default))
                self.present(alert,animated: true)
                return
            }
            
            //Creamos el decodificador de JSON
            let decoder = JSONDecoder()
            
            //Decodificamos de JSON
            guard let decodedVisits = try? decoder.decode([Visits].self, from: data!) else {
                print("JSON no decodificado")
                return
            }
            
            print("JSON Ok")
            //print(decodedVisits)
            
            //Añadimos al array
            DispatchQueue.main.async {
                self.visits = decodedVisits
                self.tableView.reloadData()
            }
 
        }
        task.resume()

    }
    
    private func getSalesmanImg(id: Int, URLString stgUrl: String, for indexPath: IndexPath) {
        let queue = DispatchQueue.global()
        
        queue.async {
            //Creamos la URL
            guard let url = URL(string: stgUrl) else {
                print("Error en la URL")
                return
            }
            
            //Usamos Data para la descarga
            guard let data = try? Data(contentsOf: url) else {
                print("Error en la descarga de la imagen")
                return
            }
            
            //Añadimos la imagen al diccionario
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.salesmanImg[id] = img
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            
        }
        
    }
    
    private func dateFormatter(_ date: String) -> String {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        let d = df.date(from: date)
        return ISO8601DateFormatter.string(from: d!, timeZone: .current, formatOptions: [.withFullDate])
        
    }
    
}
