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
        dateComponents.timeZone = TimeZone(abbreviation: "CST") // Japan Standard Time
        dateComponents.hour = 0
        dateComponents.minute = 0

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let currDateTime = userCalendar.date(from: dateComponents)
        
        dpFechaInicio.minimumDate = currDateTime
        dpFechaFin.minimumDate = currDateTime
        
    }
    
    
    @IBAction func enviaDatos(_ sender: UIButton) {
        // Add a second document with a generated ID.
        //validating data
        
        ref = db.collection("solicitudes").addDocument(data: [
            "estatus": "pendiente",
            "fechainicio": dpFechaInicio.date,
            "fechafinal": dpFechaFin.date,
            "idempleado": userID,
            "idjefe": bossID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
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
