//
//  ToyViewController.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 02/01/22.
//

import UIKit
import SwiftUI

class ToyViewController: UIViewController {
    
    @IBOutlet weak var imageViewToyPhoto: UIImageView!
    @IBOutlet weak var labelToyName: UILabel!
    @IBOutlet weak var labelStateToy: UILabel!
    @IBOutlet weak var labelDonorAddres: UILabel!
    @IBOutlet weak var labelDonorTelephone: UILabel!
    @IBOutlet weak var labelDonorName: UILabel!
    @IBOutlet weak var textViewToyDescription: UITextView!
    
    var toy: Toy?
    
    @ObservedObject
    private var toyAPI = ToyAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyFormViewController = segue.destination as? ToyFormViewController {
            toyFormViewController.toy = toy
        }
    }
    
    func prepareScreen() {
        if let toy = toy {
            toyAPI.loadToy(toy: toy) { [weak self] result in
                switch result {
                case .success(let toy):
                    self?.labelToyName.text = toy.toyName
                    self?.labelStateToy.text = toy.toyStateName
                    if let image = toy.toyPhoto {
                        let image64 = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                        self?.imageViewToyPhoto.image = UIImage(data: image64)
                    }
                    self?.labelDonorAddres.text = toy.donorAddress
                    self?.labelDonorTelephone.text = String(toy.donorTelephone)
                    self?.labelDonorName.text = toy.donorName
                    self?.textViewToyDescription.text = toy.toyDescription
                default:
                    print("Erro!!!!!!!!!!")
                }
            }
        }
    }


}
