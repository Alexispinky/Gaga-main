//
//  PictViewController.swift
//  Gaga
//
//  Created by Jan Zelaznog on 20/05/22.
//

import UIKit

class PictViewController: UIViewController {
    var item:Item?
    var imageView = UIImageView()
    var a_i = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = self.view.frame.insetBy(dx: 20, dy: 20)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        a_i.style = .large
        a_i.color = .red
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
        self.view.addSubview(a_i)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let lItem = self.item else { return }
        // Obtener la imagen que se va a mostrar
        /* TÉCNICA BÁSICA:  1) obtener la URL del recurso
                            2) obtener el contenido del recurso en forma de arreglo de bytes
                                a. se puede obtener directamente (main thread)
                                b. se implementa una tarea con la clase URLSession
        */
        if (cargaImagenLocal(lItem.pict)){
            print("imagen cargada desde local")
        }
        else{
        if let url = URL(string:DataManager.instance.baseURL + "/" + lItem.pict) {
             
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            let tarea = sesion.dataTask(with: request as URLRequest, completionHandler: {
                datos, respuesta, error in
                if error != nil {
                    print("algo salio mal \(error?.localizedDescription)")
                }
                else{
                    do{
                        //print("Datos\n")
                        //print(datos)
                        //print("Respuesta\n")
                        //print(respuesta)
                        //let bytes = try Data(contentsOf: url)
                        let image = UIImage(data: datos!)
                        self.guardaImagen(datos!, lItem.pict)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.a_i.stopAnimating()
                        }
                        
                    }
                    catch{
                        print("algo salio mal")
                    }                }
                
            })
            a_i.startAnimating()
            tarea.resume()
            /*do {
                 let bytes = try Data(contentsOf: url)
                 let image = UIImage(data: bytes)
                 self.imageView.image = image
             }
             catch {
                 print ("ocurrio un error \(error.localizedDescription)")
             }*/
        }
        }
    }
    
    func cargaImagenLocal (_ nombre: String) -> Bool{
        //obtener ruta del documento
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        //comprobar si el archivo existe
        if(FileManager.default.fileExists(atPath: urlAlArchivo.path)){
            do{
                let bytes = try Data(contentsOf: urlAlArchivo)
                let image = UIImage(data: bytes)
                self.imageView.image = image
            }
            catch{
                print("Algo salio mal\(error.localizedDescription)")
            }
            return true
        }
        else{
            return false
        }
    }
    
    func guardaImagen(_ bytes:Data, _ nombre: String){
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        do{
            try bytes.write(to: urlAlArchivo)
        }
        catch {
            print("no se puede salvar la imagen\(error.localizedDescription)")
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

}
