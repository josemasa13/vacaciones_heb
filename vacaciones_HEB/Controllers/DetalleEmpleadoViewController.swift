//
//  DetalleEmpleadoViewController.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 26/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit

class DetalleEmpleadoViewController: UIViewController {
    
    var solicitud: Solicitud! = nil

    @IBOutlet weak var viewFechaCreada: UIView!
    @IBOutlet weak var viewInicio: UIView!
    @IBOutlet weak var viewFin: UIView!
    @IBOutlet weak var viewJefe: UIView!
    @IBOutlet weak var viewEstatus: UIView!
    @IBOutlet weak var viewJustificacion: UIView!
    
    @IBOutlet weak var lbFechaCreada: UILabel!
    @IBOutlet weak var lbFechaInicio: UILabel!
    @IBOutlet weak var lbFechaFin: UILabel!
    @IBOutlet weak var lbNombreJefe: UILabel!
    @IBOutlet weak var lbEstatus: UILabel!
    @IBOutlet weak var lbJustificacion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners(view: viewFechaCreada)
        roundCorners(view: viewInicio)
        roundCorners(view: viewFin)
        roundCorners(view: viewJefe)
        roundCorners(view: viewEstatus)
        roundCorners(view: viewJustificacion)
        setUpLabels()
        
        

        // Do any additional setup after loading the view.
    }
    func roundCorners(view: UIView) {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    func setUpLabels(){
        lbFechaCreada.text = getDateFormatted(date: solicitud.fechaInicio.dateValue())
        lbFechaInicio.text = getDateFormatted(date: solicitud.fechaInicio.dateValue())
        lbFechaFin.text = getDateFormatted(date: solicitud.fechaFin.dateValue())
        lbNombreJefe.text = solicitud.nombreJefe
        lbEstatus.text = solicitud.estatus
        if solicitud.justifRechazo != "" {
            lbJustificacion.text = solicitud.justifRechazo
        }else{
            lbJustificacion.text = "Solicitud pendiente"
        }
    }
    
    func getDateFormatted(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
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
