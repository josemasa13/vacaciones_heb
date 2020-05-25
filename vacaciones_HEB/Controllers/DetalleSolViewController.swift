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
protocol protocoloStatus {
    func actualizarEstatus(estat : String) -> Void
}

class DetalleSolViewController: UIViewController {

    @IBOutlet weak var lbIDSol: UILabel!
    
    @IBOutlet weak var lbIDEmpleado: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btRechazar: UIButton!
    
    @IBOutlet weak var btAceptar: UIButton!
    
    @IBOutlet weak var lbEstadoSol: UILabel!
    
    var solicitud : Solicitud!
    
    var delegado : protocoloStatus!
    
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
        var estado = lbEstadoSol.text!
        estado = "aprobado"
        delegado.actualizarEstatus(estat: estado)
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rechazar(_ sender: UIButton) {
        let docRef = db.collection("solicitudes").document(solicitud.solicitudID)
        docRef.updateData(["estatus": "rechazado"])
        var estado = lbEstadoSol.text!
        estado = "rechazado"
        delegado.actualizarEstatus(estat: estado)
       // dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
