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
            cell.detailTextLabel?.text = visits[indexPath.row].plannedFor
        }
        
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
        
        
        return cell
    }
    
    //Usamos GCD para emplear otro Thread y Data para descargar el JSON
    private func getDataFromJSON() {
        
        //Creamos cola global
        let queue = DispatchQueue.global()
        
        //Activamos el indicador de red
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        queue.async {
            //Creamos la URL
            guard let url = URL(string: self.stringURL) else {
                print("Error en la URL")
                return
            }
            
            //Usamos Data para la descarga
            guard let data = try? Data(contentsOf: url) else {
                print("Error en la descarga del JSON")
                return
            }
            
            //Creamos el decodificador de JSON
            let decoder = JSONDecoder()
            
            //Decodificamos de JSON
            guard let decodedVisits = try? decoder.decode([Visits].self, from: data) else {
                print("JSON no decodificado")
                return
            }
            
            print("JSON Ok")
            //print(decodedVisits)
            
            //Añadimos al array
            DispatchQueue.main.async {
                print("Vuelta main")
                self.visits = decodedVisits
                self.tableView.reloadData()
            }
            
        }
        
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
    
}
