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
    var bossID:String! = ""
    
    var savedUser: User!

    @IBOutlet weak var tfUsuario: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
    @IBOutlet weak var entrarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        entrarBtn.layer.cornerRadius = 15
        entrarBtn.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let defaults = UserDefaults.standard
        print(defaults.value(forKey: "uid"))
        if let name = defaults.value(forKey: "name") as? String,
            let email = defaults.value(forKey: "email") as? String,
            let esAdmin = defaults.value(forKey: "esAdmin") as? Bool,
            let reportaA = defaults.value(forKey: "reportaA") as? String,
            let saldo = defaults.value(forKey: "saldo") as? Int,
            let uid = defaults.value(forKey: "uid") as? String {
            if esAdmin {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "admin")
//                self.present(vc, animated: false)
                id = uid
                self.performSegue(withIdentifier: "admin", sender: nil)
            }else{
                id = uid
                bossID = reportaA
                self.performSegue(withIdentifier: "user", sender: nil)
            }
        }
    }
    
    func createUser(uid: String){
        let defaults = UserDefaults.standard
        let ref = db.collection("users").document(uid)
        ref.getDocument {(document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print(document.data()!["name"]!)
                defaults.set(document.data()!["name"]!, forKey:"name")
                defaults.set(document.data()!["email"]!, forKey:"email")
                defaults.set(document.data()!["esAdmin"]!, forKey:"esAdmin")
                defaults.set(document.data()!["reportaA"]!, forKey:"reportaA")
                defaults.set(document.data()!["saldo"]!, forKey:"saldo")
                defaults.set(uid, forKey:"uid")
            } else {
                print("Document does not exist")
            }
        }
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
                            self.createUser(uid: result.user.uid)
                            if (snapshot?.get("esAdmin") as! Bool) {
                                print("ES ADMIN")
                                self.performSegue(withIdentifier: "admin", sender: nil)
                            }else{
                                self.bossID = snapshot?.get("reportaA") as! String
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
            let nav = segue.destination as! AdminMainMenuController
            nav.userID = self.id
        }else {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! EmployeeTableViewController
            nav.modalPresentationStyle = .fullScreen
            vc.userID = self.id
            vc.bossID = self.bossID
        }
    }
    
}

