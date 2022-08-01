//
//  StoreData.swift
//  MInhas Viagens Aula
//
//  Created by Christian Rezende on 21/07/22.
//  Copyright © 2022 Christian Rezende. All rights reserved.
//

import Foundation
import UIKit

class StoreData  {
    
    let keyStore = "TRIPS"
    var trips:[Dictionary<String,String>] = []
    func getDefaults()->UserDefaults{
        return UserDefaults.standard
    }
    func saveTravel(travel:Dictionary<String,String>){
        
        trips = listTrips()
        trips.append(travel)
        getDefaults().set(trips, forKey: keyStore)
        
        //Force sync because store data is async
        getDefaults().synchronize()
    }
    
    func listTrips() -> [Dictionary<String,String>]{
        let data = getDefaults().object(forKey: keyStore)
        if data != nil {
            return data as! Array
        }else {
            return []
        }
    }
    
    func deleteTravel(index:Int){
        var list = self.listTrips()
        list.remove(at: index)
        
        getDefaults().set(list,forKey: keyStore)
        
        //Force sync because store data is async
        getDefaults().synchronize()
    }
}
