//
//  AuthViewController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 21/04/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var tfUsuario: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnEntrar(_ sender: UIButton) {
        if let usuario = tfUsuario.text, let contraseña = tfContraseña.text {
            Auth.auth().signIn(withEmail: usuario, password: contraseña){ (result, error) in
                if let result = result, error == nil {
                    // show next page
                    print("->>>>  FUNCIONA")
                }else {
                    let alert = UIAlertController(title: "Error", message: "Error al iniciar sesion", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

