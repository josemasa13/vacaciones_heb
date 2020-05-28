//
//  ViewControllerCreditos.swift
//  vacaciones_HEB
//
//  Created by Monica Nava on 5/27/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit

class ViewControllerCreditos: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var txtDes: UITextView!
    
    @IBOutlet weak var txtCreditos: UITextView!
    
    @IBOutlet weak var txtDesarrollo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.layer.cornerRadius = 15.0
        txtDes.layer.cornerRadius = 15.0
        txtCreditos.text = "- Cocoapods \n -Sketch"
        txtCreditos.layer.cornerRadius = 15.0
        txtDesarrollo.text = "-José Marcial Sánchez \n-Ricardo Ramírez Arriaga \n-Monica Nava"
        txtDesarrollo.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
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
