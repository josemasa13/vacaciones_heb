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

protocol CalendarDelegate {
    func didUpdatedDates(_ startDate: Date?, _ endDate: Date?,_ dateRanges: String)
}

class SolicitudViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var userID : String = ""
    var bossID : String = ""
    var nombreEmpleado : String = ""
    var nombreJefe : String = ""
    var ref: DocumentReference? = nil
    

    var startDate: Date? = nil
    var endDate: Date? = nil
    
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var lbrangeDates: UILabel!
    @IBOutlet weak var btnFecha: UIButton!
    
    var dateSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFecha.titleLabel?.text = "Elegir Fechas"
        
        btnFecha.layer.cornerRadius = 15
        btnFecha.layer.masksToBounds = true
        btnEnviar.layer.cornerRadius = 15
        btnEnviar.layer.masksToBounds = true
        
        btnEnviar.isEnabled = false
        btnEnviar.backgroundColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1)
        btnEnviar.setTitleColor(UIColor(red:102/255, green:102/255, blue:102/255, alpha:1), for: .normal)
        
        btnFecha.layer.borderWidth = 1
        btnFecha.layer.borderColor = UIColor.red.cgColor
        btnFecha.setTitleColor(UIColor.red, for: .normal)
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
            "fechainicio": startDate,
            "fechafinal": endDate,
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
    
    func checkSend(){
        if dateSelected {
            btnEnviar.isEnabled = true
            btnEnviar.backgroundColor = UIColor.red
            btnEnviar.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCalendar" {
            let vc = segue.destination as! DateSelectionViewController
            vc.delegate = self
        }
    }
    

}

extension SolicitudViewController: CalendarDelegate {
    func didUpdatedDates(_ startDate: Date?,_ endDate: Date?,_ dateRanges: String) {
        self.startDate = startDate!
        self.endDate = endDate!
        self.lbrangeDates.text = dateRanges
        self.dateSelected = true
        self.btnFecha.titleLabel?.text = "Cambiar fecha"
        self.checkSend()
    }
}
