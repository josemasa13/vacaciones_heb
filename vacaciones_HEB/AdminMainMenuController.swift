//
//  AdminMainMenuController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 11/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit

class AdminMainMenuController: UIViewController {
    
    var userID : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nav = segue.destination as! UINavigationController
        let vc = nav.topViewController as! AdminTableViewController

        vc.userID = self.userID
        
        if segue.identifier == "modificadas"{
            vc.solicitudesACargar = "modificadas"
        } else{
            vc.solicitudesACargar = "pendientes"
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
