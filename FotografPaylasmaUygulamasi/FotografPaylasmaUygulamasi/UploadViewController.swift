//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdullah Karagöz on 13.04.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
      
    }
    
    @objc func gorselSec() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
    
        let storage  = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let  uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data,metadata: nil) {(storagementData, error) in
                if error != nil {
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız Tekrar Deneyin!")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                         
                            if let imageUrl = imageUrl {
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost =
                                [
                                    "gorselUrl":imageUrl,
                                    "yorum":self.yorumTextField.text,
                                    "email":Auth.auth().currentUser?.email,
                                    "tarih":FieldValue.serverTimestamp()
                                ] as [String:Any]

                                firestoreDatabase.collection("post").addDocument(data: firestorePost) {
                                    (error) in
                                    if error != nil {
                                        self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız Tekrar Deneyiniz")
                                    }
                                    else {
                                      //  self.imageView.image = UIImage(named: "square.and.arrow.up")
                                        self.yorumTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
  
    func hataMesajiGoster (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }

}
