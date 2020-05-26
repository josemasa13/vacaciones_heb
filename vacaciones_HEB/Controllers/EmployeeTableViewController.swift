//
//  EmployeeTableViewController.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 12/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class EmployeeTableViewController: UITableViewController {
    
    let db = Firestore.firestore()

    var userID: String! = nil
    var bossID: String! = nil
    var estatus : [String] = []
    var fechasInicio : [Timestamp] = []
    var fechasFinal : [Timestamp] = []
    var empleados : [String] = []
    var solicitudes : [Solicitud] = []
    var selectedIndex : Int!
    var solicitudesACargar : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CeldaTableViewCell", bundle: nil), forCellReuseIdentifier: "newCell")
        getSolicitudes()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return solicitudes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! CeldaTableViewCell
        cell.nameLabel.text = solicitudes[indexPath.row].nombreEmpleado
        cell.statusLabel.text = solicitudes[indexPath.row].estatus
        cell.dateLabel.text = getDateFormatted(start: solicitudes[indexPath.row].fechaInicio.dateValue(), end: solicitudes[indexPath.row].fechaFin.dateValue())
        switch solicitudes[indexPath.row].estatus {
        case "rechazado":
            cell.statusView.backgroundColor = UIColor.red
        case "aprobado":
            cell.statusView.backgroundColor = UIColor.green
        case "pendiente":
            cell.statusView.backgroundColor = UIColor.yellow
        default:
            cell.statusView.backgroundColor = UIColor.blue
        }

        return cell
    }
    func getDateFormatted(start: Date, end: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        if start == end {
            return formatter.string(from: end) + " 2020"
        }
        return formatter.string(from: start) + " al " + formatter.string(from: end) + " 2020"
    }
    
    func getLongAgo(firstDate: Date, secondDate: Date) -> Int{
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    
    func getSolicitudes(){
        let solicitudesRef = db.collection("solicitudes")
        solicitudesRef.whereField("idempleado", isEqualTo: userID!).getDocuments() { (querySnapshot, err) in
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
    

    @IBAction func cerrarSesion(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "esAdmin")
        defaults.removeObject(forKey: "reportaA")
        defaults.removeObject(forKey: "saldo")
        defaults.removeObject(forKey: "uid")
        defaults.synchronize()
        let nav = UINavigationController()
        Utility.backToLogin(self)

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let nav = segue.destination as! SolicitudViewController
        
        
        nav.userID = self.userID
        nav.bossID = self.bossID
        
    }
}
