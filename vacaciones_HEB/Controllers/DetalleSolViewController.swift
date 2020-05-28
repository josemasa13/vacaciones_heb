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
    
    @IBOutlet weak var lbIDEmpleado: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btRechazar: UIButton!
    @IBOutlet weak var btAceptar: UIButton!
    @IBOutlet weak var lbEstadoSol: UILabel!
    
    var solicitud : Solicitud!
    
    @IBOutlet weak var viewEstado: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewCreada: UIView!
    @IBOutlet weak var viewInicio: UIView!
    @IBOutlet weak var viewFin: UIView!
    
    @IBOutlet weak var lbCreada: UILabel!
    @IBOutlet weak var lbInicio: UILabel!
    @IBOutlet weak var lbFin: UILabel!
    var delegado : protocoloStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbIDEmpleado.text = solicitud.nombreEmpleado
        lbEstadoSol.text = solicitud.estatus
        lbCreada.text = getDateFormatted(date: solicitud.fechaCreacion.dateValue())
        lbInicio.text = getDateFormatted(date: solicitud.fechaInicio.dateValue())
        lbFin.text = getDateFormatted(date: solicitud.fechaFin.dateValue())
        viewEstado.layer.cornerRadius = 15.0
        viewEstado.clipsToBounds = true
        viewInfo.layer.cornerRadius = 15.0
        viewInfo.clipsToBounds = true
        btAceptar.layer.cornerRadius = 15
        btAceptar.clipsToBounds = true
        btRechazar.layer.cornerRadius = 15
        btRechazar.clipsToBounds = true
        
        viewCreada.layer.cornerRadius = 15
        viewCreada.clipsToBounds = true
        
        viewInicio.layer.cornerRadius = 15
        viewInicio.clipsToBounds = true
        
        viewFin.layer.cornerRadius = 15
        viewFin.clipsToBounds = true
        
        btAceptar.backgroundColor = .systemGreen
        btRechazar.backgroundColor = .systemRed
        
//        btAceptar.layer.borderWidth = 1
//        btAceptar.layer.borderColor = UIColor.systemGreen.cgColor
//        btAceptar.setTitleColor(UIColor.systemGreen, for: .normal)
//
//        btRechazar.layer.borderWidth = 1
//        btRechazar.layer.borderColor = UIColor.systemRed.cgColor
//        btRechazar.setTitleColor(UIColor.systemRed, for: .normal)
        
    }
    lazy var bulletinAceptada: BLTNItemManager = {
        let rootItem: BLTNItem = getBulletinAceptada()
        return BLTNItemManager(rootItem: rootItem)
    }()
    func getBulletinAceptada() -> BLTNItem{
        let recordatorio = BLTNPageItem(title: "Solicitud de vacaciones aceptada")
        recordatorio.descriptionText = "Se ha aceptado la solicitud de vacaciones, puedes modificarlo visitando el historial de solicitudes"
        recordatorio.actionButtonTitle = "De acuerdo"
        recordatorio.image = UIImage(named: "IntroCompletion")?.withTintColor(.systemGreen)
        recordatorio.appearance.actionButtonColor = .systemGreen
        recordatorio.actionHandler = { (item: BLTNActionItem) in
            recordatorio.manager?.dismissBulletin(animated: true)
            Utility.backToPreviousScreen(self)
        }
        recordatorio.requiresCloseButton = false
        recordatorio.isDismissable = false
        return recordatorio
    }
    
    func getDateFormatted(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
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
            if justificacion.textField.text != "" {
                self.solicitud.justifRechazo = justificacion.textField.text!
                print(justificacion.textField.text!)
                self.updateJustificacion()
                justificacion.manager?.dismissBulletin(animated: true)
                self.navigationController?.popViewController(animated: true)
                self.updateSaldo()
            }
        }
        justificacion.isDismissable = false
        justificacion.requiresCloseButton = false
           return justificacion
       }
    
    @IBAction func aprobar(_ sender: UIButton) {
        let docRef = db.collection("solicitudes").document(solicitud.solicitudID)
        docRef.updateData(["estatus": "aprobado"])
        var estado = lbEstadoSol.text!
        estado = "aprobado"
        delegado.actualizarEstatus(estat: estado)
        //dismiss(animated: true, completion: nil)
        bulletinAceptada.showBulletin(above: self)
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
    
    func updateSaldo() {
        let ref = db.collection("users").document(solicitud.userID)
        let diasVacaciones = Double(solicitud.fechaFin.dateValue().timeIntervalSince(solicitud.fechaInicio.dateValue()) / 86400)
        ref.updateData(["saldo": FieldValue.increment(diasVacaciones + 1)])
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
