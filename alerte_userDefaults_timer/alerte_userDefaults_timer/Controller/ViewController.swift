//
//  ViewController.swift
//  alerte_userDefaults_timer
//
//  Created by Caroline Zaini on 05/06/2020.
//  Copyright © 2020 Caroline Zaini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var alertBtn: UIButton!
    
    /// va montrer une donnée qu'on a sauvegardé dans l'app :
    @IBOutlet weak var dataLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var actionSheetBtn: UIButton!
    
    /// pour accéder à userDefaults, il nous faut l'accès à la classe :
    let userDefaults = UserDefaults.standard
    
    var timer = Timer()
    var timeRemaining = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLbl.text = getData() 
        
    }
    // MARK: - timer
    
    func setupTimer() {
        actionSheetBtn.isEnabled = false
        /// 1 action toutes les 1 s
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
            self.timeRemaining -= 1
            self.timeLbl.text = String(self.timeRemaining)
            /// pour ne pas avoir de chiffre négatif
            if self.timeRemaining <= 0 {
                self.stopTimer()
            }
        })
    }
    
    func stopTimer() {
        /// on arrête le timer
        timer.invalidate()
    }
    
    @IBAction func startBtn(_ sender: Any) {
        actionSheetBtn.isEnabled = true
        setupTimer()
    }
    
    @IBAction func stopBtn(_ sender: Any) {
        stopTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// pour avoir le clavier qui rentre lorsqu'on appuie n'importe où sur l'écran
        view.endEditing(true)
    }
    
    // MARK: - userDefaults
    
    // il faudra une KEY & une VALUE
    func saveData(string: String?) {
        /// value: Any, forKey: String. forKey sera notre clef pour récupérer plus tard notre valeur
        userDefaults.set(string, forKey: "Text")
    }
    
    func getData() -> String {
        /// si on n'arrive pas à récupérer la clef on affiche "Aucune données"
        userDefaults.string(forKey: "Text") ?? "Aucune données"
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let text = textField.text, text != "" {
            saveData(string: text)
            dataLbl.text = getData()
        }
    }
    
    // MARK: - Alerts Action

    @IBAction func alertButton(_ sender: Any) {
        
        let controller = UIAlertController(title: "User Defaults", message: "Vous avez sauvegardé la String : \(getData())", preferredStyle: .alert)
        
        let reset = UIAlertAction(title: "Remise à zéro", style: .destructive) { (action) in
            self.saveData(string: nil)
            self.dataLbl.text = self.getData()
        }
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        controller.addAction(reset)
        controller.addAction(cancel)
        
//        /// bouton pour fermer la pop-up. handler => que va t-il se passer quand on appuie sur le bouton :
//        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
//        /// ajoute ce bouton au controller :
//        controller.addAction(close)
//
//        /// pour montrer plusieurs boutons dans la pop-up avec handler:
//        let destructive = UIAlertAction(title: "Color red", style: .destructive) { (action) in
//            self.alertBtn.tintColor = .red
//        }
//        controller.addAction(destructive)
//
//        let defaultAction = UIAlertAction(title: "Color green", style: .default) { (action) in
//            self.alertBtn.tintColor = .green
//        }
//        controller.addAction(defaultAction)
        
        /// montrer le controller :
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func actionSheetButton(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "Action Sheet", message: "Ma première action sheet", preferredStyle: .actionSheet)
        
        let five = UIAlertAction(title: "5 secondes", style: .default) { (action) in
            self.timeRemaining = 5
            self.timeLbl.text = String(self.timeRemaining)
        }
        
        let ten = UIAlertAction(title: "10 secondes", style: .default) { (action) in
            self.timeRemaining = 10
            self.timeLbl.text = String(self.timeRemaining)
        }
        
//        let blue = UIAlertAction(title: "Blue", style: .default) { (action) in
//            self.view.backgroundColor = .systemBlue
//        }
//
//        let yellow = UIAlertAction(title: "Yellow", style: .default) { (action) in
//            self.view.backgroundColor = .systemYellow
//        }
//        let purple = UIAlertAction(title: "Purple", style: .default) { (action) in
//            self.view.backgroundColor = .systemPurple
//        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
//        controller.addAction(blue)
//        controller.addAction(yellow)
//        controller.addAction(purple)

        controller.addAction(five)
        controller.addAction(ten)
        controller.addAction(cancel)
        
        // vérification pour l'iPad :
        /// si je suis sur un iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            /// A quel endroit il va être montré, ici dans ma view principale
            controller.popoverPresentationController?.sourceView = self.view
            controller.popoverPresentationController?.sourceRect = sender.frame
            
            /// style de la popOver
            controller.popoverPresentationController?.permittedArrowDirections = .down
        }
        
        present(controller, animated: true, completion: nil)
    }
    
}

