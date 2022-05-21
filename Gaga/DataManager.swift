//
//  DataManager.swift
//  Gaga
//
//  Created by Jan Zelaznog on 20/05/22.
//

import Foundation


// declaramos una estructura porque de esta forma es mas especifico el manejo de las propiedades de cada objeto que llegue desde Internet
// El protocolo Codable, permite codificar y decodificar, un objeto JSON a este tipo de estructura
struct Item: Codable {
    let pict: String
    let title: String
}

class DataManager: NSObject {
    
    static let instance = DataManager()
    
    override private init() {
        super.init()
        getInfo()
    }
    
    let baseURL = "http://janzelaznog.com/DDAM/iOS/gaga"
    // esto era cuando trabajabamos con diccionarios
    //var info = [[String : String]]()
    var info = [Item]()
    
    func getInfo() {
        /* TÉCNICA BÁSICA:  1) obtener la URL del recurso
                            2) obtener el contenido del recurso en forma de arreglo de bytes
                                a. se puede obtener directamente (main thread)
                                b. se implementa una tarea con la clase URLSession
        */
         if let url = URL(string: baseURL + "/info.json") {
             do {
                 let bytes = try Data(contentsOf: url)
                 /* Esto era cuando trabajabamos con diccionarios
                 let tmp = try JSONSerialization.jsonObject(with: bytes, options: .allowFragments)
                 self.info = tmp as! [[String:String]]
                 */
                 // el primer argumento es la clase de objeto, a que queremos convertir el arreglo de bytes que recibimos como respuesta tipo JSON
                 self.info = try JSONDecoder().decode([Item].self, from:bytes)
                 print (self.info)
             }
             catch {
                 print ("ocurrio un error \(error.localizedDescription)")
             }
        }
    }
}
