//
//  ViewController.swift
//  RegistroLogin
//
//  Created by Miguel Angel Jimenez Melendez on 3/10/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {
    //apuntadores que usamos para nuestra BD
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // se crea y comprueba que se cree la BD
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteRegistro.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se creo DB")
            return
        }
        //Se crea la tabla user
        let tableusuario = "Create Table If Not Exists usuario(email Text Primary Key, nombre Text, password Text)"
        if sqlite3_exec(db, tableusuario, nil, nil, nil) != SQLITE_OK {
            alerta(title: "Error", message: "No se creo Tuser")
            return
        }
        //condiciones para loguear un usuario en la app
        let query = "Select email From usuario"
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db))
            alerta(title: "Error", message: "Error en \(error)")
            return
        }
        // condiciòn para extrer los datos de nuestro select, de no cumplierse se manda al vcontroller registro
        if sqlite3_step(stmt) == SQLITE_ROW {
            let email = String(cString: sqlite3_column_text(stmt, 0))
            alerta(title: "Bienvenido", message: "Hola \(email)")
        }else{
            self.performSegue(withIdentifier: "Sregistro", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    //funcion para dirigir a otro vcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Sregistro" {
            _ = segue.destination as! ViewControllerRegistro
            }
    }
    //funcion para arrojar alertas
    func alerta(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

