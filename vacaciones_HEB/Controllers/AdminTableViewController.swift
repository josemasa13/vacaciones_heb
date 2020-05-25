//
//  AdminTableViewController.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 22/04/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class Solicitud{
    var nombreEmpleado : String
    var nombreJefe : String
    var fechaInicio : Timestamp
    var fechaFin : Timestamp
    var estatus : String
    var solicitudID : String
    var justifRechazo : String
    
    init(nombreEmpleado:String, nombreJefe:String, fechaInicio :Timestamp, fechaFin:Timestamp, estatus : String, solicitudID : String){
        self.nombreEmpleado = nombreEmpleado
        self.nombreJefe = nombreJefe
        self.fechaFin = fechaFin
        self.fechaInicio = fechaInicio
        self.estatus = estatus
        self.solicitudID = solicitudID
        self.justifRechazo = ""
    }
    init(nombreEmpleado:String, nombreJefe:String, fechaInicio :Timestamp, fechaFin:Timestamp, estatus : String, solicitudID : String, justifRechazo : String){
        self.nombreEmpleado = nombreEmpleado
        self.nombreJefe = nombreJefe
        self.fechaFin = fechaFin
        self.fechaInicio = fechaInicio
        self.estatus = estatus
        self.solicitudID = solicitudID
        self.justifRechazo = justifRechazo
    }
}

class CustomTableViewCell: UITableViewCell {
    var solicitudC : Solicitud!
    
    @IBOutlet weak var lbIDSolicitud: UILabel!
    @IBOutlet weak var lbEstadoSol: UILabel!
    @IBOutlet weak var lbEmp: UILabel!


}

class AdminTableViewController: UITableViewController, protocoloStatus {
    func actualizarEstatus(estat: String) {
        solicitudes[selectedIndex].estatus = estat
        estatus.append(estat)
        tableView.reloadData()
    }
    
    let db = Firestore.firestore()
    
    var userID: String! = nil
    var estatus : [String] = []
    var fechasInicio : [Timestamp] = []
    var fechasFinal : [Timestamp] = []
    var empleados : [String] = []
    var solicitudes : [Solicitud] = []
    var selectedIndex : Int!
    var estado : String!
    
    var solicitudesACargar : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let solicitudesRef = db.collection("solicitudes")
        
        if solicitudesACargar == "modificadas"{
            
            solicitudesRef.whereField("idjefe", isEqualTo: userID!).whereField("estatus", in: ["aprobado", "rechazado"]).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let solicitud = Solicitud(nombreEmpleado : (document.data()["nombreempleado"]! as! String),nombreJefe:(document.data()["nombrejefe"]! as! String),fechaInicio: (document.data()["fechainicio"]! as! Timestamp),fechaFin: (document.data()["fechafinal"]! as! Timestamp),estatus: (document.data()["estatus"] as! String), solicitudID: document.documentID)
                            
                            self.solicitudes.append(solicitud)
                            
                        }
                    }
                    self.tableView.reloadData()
            }
        } else{
        solicitudesRef.whereField("idjefe", isEqualTo: userID!).whereField("estatus", isEqualTo: "pendiente").getDocuments() {
                (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let solicitud = Solicitud(nombreEmpleado : (document.data()["nombreempleado"]! as! String),nombreJefe:(document.data()["nombrejefe"]! as! String),fechaInicio: (document.data()["fechainicio"]! as! Timestamp),fechaFin: (document.data()["fechafinal"]! as! Timestamp),estatus: (document.data()["estatus"] as! String), solicitudID: document.documentID)
                            
                            self.solicitudes.append(solicitud)
                            
                        }
                    }
                    self.tableView.reloadData()
            }
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return solicitudes.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
       }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CustomTableViewCell
        
        cell.lbEmp?.text = solicitudes[indexPath.row].nombreEmpleado
        cell.lbEstadoSol?.text = solicitudes[indexPath.row].estatus
        cell.lbIDSolicitud?.text = solicitudes[indexPath.row].solicitudID
        
        

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vistaDetalle = segue.destination as! DetalleSolViewController
       
        let solicitud = Solicitud(nombreEmpleado: solicitudes[tableView.indexPathForSelectedRow!.row].nombreEmpleado, nombreJefe: solicitudes[tableView.indexPathForSelectedRow!.row].nombreJefe, fechaInicio: solicitudes[tableView.indexPathForSelectedRow!.row].fechaInicio, fechaFin: solicitudes[tableView.indexPathForSelectedRow!.row].fechaFin, estatus:  solicitudes[tableView.indexPathForSelectedRow!.row].estatus, solicitudID: solicitudes[tableView.indexPathForSelectedRow!.row].solicitudID)
        
        vistaDetalle.solicitud = solicitud
        vistaDetalle.delegado = self
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
