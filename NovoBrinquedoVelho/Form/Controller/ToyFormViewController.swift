//
//  ToyFormViewController.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 02/01/22.
//

import UIKit

class ToyFormViewController: UIViewController {
    
    @IBOutlet weak var textFieldToyName: UITextField!
    @IBOutlet weak var segmentedControlToyState: UISegmentedControl!
    @IBOutlet weak var textFieldDonorAddres: UITextField!
    @IBOutlet weak var textFieldDonorTelephone: UITextField!
    @IBOutlet weak var textFieldDonorName: UITextField!
    @IBOutlet weak var imageViewToyPhoto: UIImageView!
    @IBOutlet weak var textViewToyDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonGravarEditar: UIButton!
    
    var toy: Toy?
    let ALTERAR_O_BRINQUEDO: String = "Alterar a doação do brinquedo"
       
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .interactive
        if let toy = toy {
            title = ALTERAR_O_BRINQUEDO
            textFieldToyName.text = toy.toyName
            segmentedControlToyState.selectedSegmentIndex = toy.toyState ?? 0
            if let image = toy.toyPhoto {
                let image64 = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                imageViewToyPhoto.image = UIImage(data: image64)
            }
            textFieldDonorAddres.text = toy.donorAddress
            textFieldDonorTelephone.text = String(toy.donorTelephone)
            textFieldDonorName.text = toy.donorName
            textViewToyDescription.text = toy.toyDescription
            buttonGravarEditar.setTitle(ALTERAR_O_BRINQUEDO, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {return}
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        super.viewWillAppear(animated)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar uma foto",
                                      message: "De onde você deseja escolher a foto?",
                                      preferredStyle: .actionSheet)
        
        // O if a seguir serve para prevenir o código de erros, pois não existe câmera no simulador
        // O código só vai funcionar se uma câmera for localizada
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera",
                                            style: .default) { _ in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos",
                                          style: .default) { _ in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum de fotos",
                                          style: .default) { _ in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker,
                animated: true,
                completion: nil)
    }
    
    @IBAction func saveToy(_ sender: UIButton) {
        if toy == nil {
            toy = Toy( donorTelephone: 0)
        }
        toy?.toyName = textFieldToyName.text
        toy?.toyState = segmentedControlToyState.selectedSegmentIndex
        toy?.toyPhoto = imageViewToyPhoto.image?.jpegData(compressionQuality: 0.0)?.base64EncodedString(options: .lineLength64Characters)
        toy?.donorAddress = textFieldDonorAddres.text
        toy?.donorTelephone = Int(textFieldDonorTelephone.text!) ?? 0
        toy?.donorName = textFieldDonorName.text
        toy?.toyDescription = textViewToyDescription.text
        if title == ALTERAR_O_BRINQUEDO {
            ToyAPI().editToy(toy: toy!)
        } else {
            ToyAPI().addToy(toy: toy!)
        }
        navigationController?.popViewController(animated: true)
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

extension ToyFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageViewToyPhoto.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
