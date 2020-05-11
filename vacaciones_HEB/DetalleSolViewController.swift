//
//  DetalleSolViewController.swift
//  vacaciones_HEB
//
//  Created by Monica Nava on 4/23/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//


import UIKit
import Firebase
import Foundation
/*let solicitudesRef = db.collection("solicitudes")
       solicitudesRef.whereField("idjefe", isEqualTo: userID!)
           .getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let solicitud = Solicitud(nombreEmpleado : (document.data()["nombreempleado"]! as! String),nombreJefe:(document.data()["nombrejefe"]! as! String),fechaInicio: (document.data()["fechainicio"]! as! Timestamp),fechaFin: (document.data()["fechafinal"]! as! Timestamp),estatus: (document.data()["estatus"] as! String), solicitudID: document.documentID)
                       
                       self.solicitudes.append(solicitud)
                       
                   }
*/

class DetalleSolViewController: UIViewController {

    @IBOutlet weak var lbIDSol: UILabel!
    
    @IBOutlet weak var lbIDEmpleado: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btRechazar: UIButton!
    
    @IBOutlet weak var btAceptar: UIButton!
    
    @IBOutlet weak var lbEstadoSol: UILabel!
    
    var solicitud : Solicitud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbIDSol.text = solicitud.solicitudID
        lbIDEmpleado.text = solicitud.nombreEmpleado
        lbEstadoSol.text = solicitud.estatus
        
        // Do any additional setup after loading the view.
    }
  
   /* func obtenerSolicitud (id: String){
    let roofRef = db.database().reference()
        roofRef.child(solicitud.solicitudID).childByAutoId().setValue(["estatus": "aprobado"])
    }*/
    
    @IBAction func aprobar(_ sender: UIButton) {
        let docRef = db.collection("solicitudes").document(solicitud.solicitudID)
        docRef.updateData(["estatus": "aprobado"])
        lbEstadoSol.text = "aprobada"
    }
    
    @IBAction func rechazar(_ sender: UIButton) {
        let docRef = db.collection("solicitudes").document(solicitud.solicitudID)
        docRef.updateData(["estatus": "rechazado"])
        lbEstadoSol.text = "rechazado"
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
