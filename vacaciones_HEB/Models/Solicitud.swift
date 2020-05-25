//
//  Solicitud.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 23/04/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Foundation

class Solicitud: NSObject {
    var nombreEmpleado : String
    var nombreJefe : String
    var fechaInicio : Timestamp
    var fechaFin : Timestamp
    var estatus : String
    var solicitudID : String
    
    init(nombreEmpleado:String, nombreJefe:String, fechaInicio :Timestamp, fechaFin:Timestamp, estatus : String, solicitudID : String){
        self.nombreEmpleado = nombreEmpleado
        self.nombreJefe = nombreJefe
        self.fechaFin = fechaFin
        self.fechaInicio = fechaInicio
        self.estatus = estatus
        self.solicitudID = solicitudID
    }
}
