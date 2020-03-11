//
//  ViewControllerRegistro.swift
//  RegistroLogin
//
//  Created by Miguel Angel Jimenez Melendez on 3/10/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewControllerRegistro: UIViewController {
    @IBOutlet weak var txtnombre: UITextField!
    @IBOutlet weak var txtpsw: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    //variables que se utilizaran como apuntadores en la BD
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Se crea la base de datos
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteRegistro.sqlite")
        //Comprueba si se crea BD
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se creo DB")
            return
        }
        //Se compruba que se cree la tabla user
        let tableusuario = "Create Table If Not Exists usuario(email Text Primary Key, nombre Text, password Text)"
        if sqlite3_exec(db, tableusuario, nil, nil, nil) != SQLITE_OK {
            alerta(title: "Error", message: "No se creo Tuser")
            return
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnGuardar(_ sender: UIButton) {
        //se comprueba que las Tfiel no exten vacios
        if txtnombre.text!.isEmpty || txtemail.text!.isEmpty || txtpsw.text!.isEmpty {
            alerta(title: "Falta Informaciòn", message: "Complete el formulario")
            txtnombre.becomeFirstResponder()
        }else{ //Variables donde se almacenara el contenido de las cajas de texto, dando el formato NSString para no tener problemas al guardar en la BD
            let email = txtemail.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let nombre = txtnombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let psw = txtpsw.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            //Condiciones que comprueban que se guarden los datos de cada una de las variables
            let query = "Insert Into usuario(email, nombre, password) Values(?, ?, ?)"
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                alerta(title: "Error", message: "No se puede ligar query")
                return
            }
            if sqlite3_bind_text(stmt, 1, email.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error campo email")
                return
            }
            if sqlite3_bind_text(stmt, 2, nombre.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error campo nombre")
                return
            }
            if sqlite3_bind_text(stmt, 3, psw.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error campo psw")
                return
            }
            //Se comprueba que se haya ejecutado correctamente el insert para proceder a cambiarnos de vController
            if sqlite3_step(stmt) != SQLITE_OK {
                self.performSegue(withIdentifier: "Sinicio", sender: self)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //funcion para cambiarnos de vcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Sinicio" {
            _ = segue.destination as! ViewController
        }
    }
    //funcion para lanzar nuestras alertas
     func alerta(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
}
