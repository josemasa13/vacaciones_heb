//
//  SolicitudViewController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 22/04/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class SolicitudViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var userID : String = ""
    var bossID : String = ""
    var nombreEmpleado : String = ""
    var nombreJefe : String = ""
    var ref: DocumentReference? = nil
    

    
    @IBOutlet weak var dpFechaInicio: UIDatePicker!
    @IBOutlet weak var dpFechaFin: UIDatePicker!
    @IBOutlet weak var btnEnviar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currDate = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currDate)
        let month = calendar.component(.month, from: currDate)
        let year = calendar.component(.year, from: currDate)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "CST") 
        dateComponents.hour = 0
        dateComponents.minute = 0

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let currDateTime = userCalendar.date(from: dateComponents)
        
        dpFechaInicio.minimumDate = currDateTime
        dpFechaFin.minimumDate = currDateTime
        
        db.collection("users").document(bossID).getDocument { (document, error) in
            if let document = document, document.exists {
                let jefeAux = document.data()!["name"] as! String
                self.nombreJefe = jefeAux
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let empleadoAux = document.data()!["name"] as! String
                self.nombreEmpleado = empleadoAux
            } else {
                print("Document does not exist")
            }
        }
        
    }
    //init
    //inicilizar fecha con doc reference??
    /*init(userID : String, fechaCreada :String, estado: String){
        self.userID = userID
        self.fechaCreada =  fechaCreada
        self.estado = estado
    }*/
    
    @IBAction func enviaDatos(_ sender: UIButton) {
        // Add a second document with a generated ID.
        //validating data
        print(nombreJefe)
        print(nombreEmpleado)
        
        ref = db.collection("solicitudes").addDocument(data: [
            "estatus": "pendiente",
            "fechainicio": dpFechaInicio.date,
            "fechafinal": dpFechaFin.date,
            "idempleado": userID,
            "idjefe": bossID,
            "nombrejefe": nombreJefe,
            "nombreempleado":nombreEmpleado,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
                // create the alert
                let alert = UIAlertController(title: "Solicitud Enviada", message: "Tu solicitud se ha enviado a tu suprior", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
