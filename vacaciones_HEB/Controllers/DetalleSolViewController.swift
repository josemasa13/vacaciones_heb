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
import BLTNBoard
protocol protocoloStatus {
    func actualizarEstatus(estat : String) -> Void
}
class JustificacionPageItem: BLTNPageItem {

    var textField: UITextField!
    
    override init(title: String) {
    super.init(title: "Justificacion rechazo")
     self.descriptionText = "Description"
     self.isDismissable = true
    self.presentationHandler = { (_ item: BLTNItem) in
        self.textField?.becomeFirstResponder() // para que se vea el teclado
        }
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
          var contentViews = [UIView]()
          
        let textField = interfaceBuilder.makeTextField(delegate: self as? UITextFieldDelegate)
              textField.returnKeyType = .done
              textField.placeholder = "motivo"
              contentViews.append(textField)
    
              self.textField = textField
        
          return contentViews
      }
}

class DetalleSolViewController: UIViewController {

    @IBOutlet weak var lbIDSol: UILabel!
    
    @IBOutlet weak var lbIDEmpleado: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btRechazar: UIButton!
    
    @IBOutlet weak var btAceptar: UIButton!
    
    @IBOutlet weak var lbEstadoSol: UILabel!
    
    @IBOutlet weak var lbDetalle: UILabel!
    
    @IBOutlet weak var viewEstado: UIView!
    
    @IBOutlet weak var viewInfo: UIView!
    var solicitud : Solicitud!
    
    var delegado : protocoloStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbIDSol.text = solicitud.solicitudID
        lbIDEmpleado.text = solicitud.nombreEmpleado
        lbEstadoSol.text = solicitud.estatus
        lbEstadoSol.font = UIFont.boldSystemFont(ofSize: lbEstadoSol.font.pointSize)
        lbDetalle.font = UIFont.boldSystemFont(ofSize: lbDetalle.font.pointSize)
        lbIDEmpleado.font = UIFont.boldSystemFont(ofSize: lbIDEmpleado.font.pointSize)
        lbIDSol.font = UIFont.boldSystemFont(ofSize: lbIDSol.font.pointSize)
        viewEstado.layer.cornerRadius = 15.0
        viewInfo.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
  lazy var bulletinJust: BLTNItemManager = {
      let rootItem: BLTNItem = getBulletinJust()
      return BLTNItemManager(rootItem: rootItem)}()
    
    func getBulletinJust() -> BLTNItem {
           let justificacion = JustificacionPageItem(title: "Justificacion rachazo")
           justificacion.descriptionText = "Escribe el motivo de rechazo de dicha solicitud"
           justificacion.actionButtonTitle = "Enviar"
            justificacion.actionHandler = { (item: BLTNActionItem) in
            print("Action button tapped")
            //envia justificacion
            self.solicitud.justifRechazo = justificacion.textField.text!
            print(justificacion.textField.text!)
            self.updateJustificacion()
            justificacion.manager?.dismissBulletin(animated:true)
            self.navigationController?.popViewController(animated: true)
        }
           return justificacion
       }
    
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
        bulletinJust.showBulletin(above: self)
    }
    func updateJustificacion() {
        //referencia doc
        let ref = db.collection("solicitudes").document(solicitud.solicitudID)
        ref.updateData(["justificacion": solicitud.justifRechazo])
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
