//
//  AdminMainMenuController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 11/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import BLTNBoard
let db = Firestore.firestore()

func getBoss(userID:String) -> String{

    var jefe : String = ""
    db.collection("users").document(userID).getDocument { (document, error) in
        if let document = document, document.exists {
            jefe = document.data()!["reportaA"] as! String

        } else {
            print("Document does not exist")
        }
    }
    return jefe
}

class AdminMainMenuController: UIViewController {
    
    var userID : String!
    
    var bossID : String!

    @IBOutlet weak var btnCerrarS: UIButton!
    
    @IBOutlet weak var btVerSolicitud: UIButton!
    
    @IBOutlet weak var btHistorialEmp: UIButton!
    
    @IBOutlet weak var btCrearSolicitud: UIButton!
    
    @IBOutlet weak var verMiHistorial: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    db.collection("users").document(self.userID).getDocument { (document, error) in
        
            if let document = document, document.exists {
                self.bossID = document.data()!["reportaA"] as? String

            } else {
                print("Document does not exist")
            }
        }

        
        if self.bossID == "" {
            self.btCrearSolicitud.isHidden = true
            
            self.verMiHistorial.isHidden = true
        }
        
            self.btnCerrarS.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.btVerSolicitud.layer.cornerRadius = 15.0
            self.verMiHistorial.layer.cornerRadius = 15.0
            self.btCrearSolicitud.layer.cornerRadius = 15.0
            self.btHistorialEmp.layer.cornerRadius = 15.0
    }
    

    @IBAction func logOut(_ sender: Any) {
        bulletinCerrar.showBulletin(above: self)
    }
    
    lazy var bulletinCerrar: BLTNItemManager = {
      let rootItem: BLTNItem = getBulletinCerrar()
      return BLTNItemManager(rootItem: rootItem)
    }()
    
    func getBulletinCerrar() -> BLTNItem {
        let blt = BLTNPageItem(title: "¿Cerrar Sesión?")
        blt.actionButtonTitle = "Salir"
        blt.appearance.actionButtonColor = UIColor.red
        blt.actionHandler = { (item: BLTNActionItem) in
            let defaults = UserDefaults.standard
            
            defaults.removeObject(forKey: "name")
            defaults.removeObject(forKey: "email")
            defaults.removeObject(forKey: "esAdmin")
            defaults.removeObject(forKey: "reportaA")
            defaults.removeObject(forKey: "saldo")
            defaults.removeObject(forKey: "uid")
            defaults.synchronize()
            blt.manager?.dismissBulletin()
            Utility.backToPreviousScreen(self)
        }
        return blt
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modificadas" || segue.identifier == "pendientes"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! AdminTableViewController
            vc.userID = self.userID
            let destination = segue.identifier == "modificadas" ? "modificadas" : "pendientes"
            vc.solicitudesACargar = destination
        } else if segue.identifier == "crearSolicitud"{
            let solicitudVC = segue.destination as! SolicitudViewController
            solicitudVC.userID = self.userID
            solicitudVC.bossID = self.bossID
            solicitudVC.isAdmin = true
        } else{
            let nav =  segue.destination as! UINavigationController
            let solicitudesVC = nav.topViewController as! EmployeeTableViewController
            solicitudesVC.isModal = true
            solicitudesVC.bossID = self.bossID
            solicitudesVC.userID = self.userID
        }
    }
}
