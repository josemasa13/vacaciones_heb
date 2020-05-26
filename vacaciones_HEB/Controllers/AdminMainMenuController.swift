//
//  AdminMainMenuController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 11/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit

class AdminMainMenuController: UIViewController {
    
    @IBOutlet weak var viewU: UIView!
    var userID : String!
    @IBOutlet weak var btSolicitudPendiente: UIButton!
    
    @IBOutlet weak var btSolChecada: UIButton!
    
    @IBOutlet weak var lbBienvenido: UILabel!
    @IBOutlet weak var btCrearSol: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btSolChecada.layer.cornerRadius = 15.0
        btSolicitudPendiente.layer.cornerRadius = 15.0
        btCrearSol.layer.cornerRadius = 15.0
        lbBienvenido.font = UIFont.boldSystemFont(ofSize: lbBienvenido.font.pointSize)
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
