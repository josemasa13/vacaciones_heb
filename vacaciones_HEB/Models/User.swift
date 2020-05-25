//
//  User.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 24/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import Foundation

class User: Codable {
    var name: String
    var uid: String
    var esAdmin: Bool
    var reportaA: String
    var saldo: Int
    var email: String
    init(name: String, uid: String, esAdmin: Bool, reportaA: String, saldo: Int, email: String) {
        self.name = name
        self.uid = uid
        self.esAdmin = esAdmin
        self.reportaA = reportaA
        self.saldo = saldo
        self.email = email
    }
        
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    //  Class Methods
    
    // 1
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        //2
        if writeToUserDefaults {
            //3
            if let data = try? JSONEncoder().encode(user) {
                //4
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
        }
        _current = user
    }
}
