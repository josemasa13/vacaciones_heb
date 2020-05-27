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

    @IBOutlet weak var btnCerrarS: UIButton!
    
    @IBOutlet weak var btVerSolicitud: UIButton!
    
    @IBOutlet weak var btHistorialEmp: UIButton!
    
    @IBOutlet weak var btCrearSolicitud: UIButton!
    
    @IBOutlet weak var verMiHistorial: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnCerrarS.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btVerSolicitud.layer.cornerRadius = 15.0
        verMiHistorial.layer.cornerRadius = 15.0
        btCrearSolicitud.layer.cornerRadius = 15.0
        btHistorialEmp.layer.cornerRadius = 15.0
    }
    

    @IBAction func logOut(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "esAdmin")
        defaults.removeObject(forKey: "reportaA")
        defaults.removeObject(forKey: "saldo")
        defaults.removeObject(forKey: "uid")
        defaults.synchronize()
        Utility.backToPreviousScreen(self)

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
