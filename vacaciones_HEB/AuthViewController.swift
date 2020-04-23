//
//  AuthViewController.swift
//  vacaciones_HEB
//
//  Created by Jose Alberto Marcial Sánchez on 21/04/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthViewController: UIViewController {
    
    let db = Firestore.firestore()
    var id: String!

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
                    print("\(result.user.uid)->>>>  FUNCIONA")
                    self.id = result.user.uid
                    self.db.collection("users").document(result.user.uid).addSnapshotListener() { (snapshot, error) in
                        if error == nil {
                            if (snapshot?.get("reportaA") as! String == "" ) {
                                print("ES ADMIN")
                                self.performSegue(withIdentifier: "admin", sender: nil)
                            }else{
                                print("ES EMPLEADO")
                                self.performSegue(withIdentifier: "user", sender: nil)
                            }
                        }
                        }
                    
                }else {
                    let alert = UIAlertController(title: "Error", message: "Error al iniciar sesion", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "admin" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! AdminTableViewController
            vc.userID = self.id
        }else {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! EmployeeViewController
            vc.userID = self.id
        }
    }
    
}

