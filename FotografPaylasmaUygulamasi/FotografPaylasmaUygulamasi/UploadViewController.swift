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
            
            let imageReference = mediaFolder.child("image.jpg")
            
            imageReference.putData(data,metadata: nil) {(storagementData, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            print(imageUrl)
                        }
                    }
                }
            }
            
            
            
            
        }
            
        
        
    
    
    }
    
  

}
