//
//  ViewController.swift
//  MInhas Viagens Aula
//
//  Created by Christian Rezende on 20/07/22.
//  Copyright © 2022 Christian Rezende. All rights reserved.
//

import UIKit

class TripsViewController: UITableViewController {

    var places:[Dictionary<String,String>] = []
    var navigationManager = "add"
    
    func updateTable(){
        places = StoreData().listTrips()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    navigationManager = "add"
       updateTable()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            StoreData().deleteTravel(index:indexPath.row)
            updateTable()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]["local"]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationManager = "list"
        performSegue(withIdentifier: "showLocal", sender: indexPath.row)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocal" {
            let viewControllerDestiny = segue.destination as! MapViewController
            
            if self.navigationManager == "list" {
                if let indexRecover = sender {
                    let index = indexRecover as! Int
                    viewControllerDestiny.travel = places[index]
                    viewControllerDestiny.selectedIndex = index
                }
            }else {
                viewControllerDestiny.travel = [:]
                viewControllerDestiny.selectedIndex = -1
            }
            
            
        }
    }
 

}

