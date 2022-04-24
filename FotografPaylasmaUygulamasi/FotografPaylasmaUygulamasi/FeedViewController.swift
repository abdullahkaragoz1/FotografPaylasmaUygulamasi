//
//  FeedViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdullah Karagöz on 13.04.2022.
//

import UIKit
import Firebase

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var postDizisi = [Post]()
    /*
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    
        firebaseVerileriAl()
    }
    
    func firebaseVerileriAl() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { snapshot, error in
        
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.postDizisi.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        // let documentId = document.documentID
                        
                        if let gorselUrl = document.get("gorselUrl") as? String {
                            
                            if let yorum = document.get("yorum") as? String {
                            
                                if let email = document.get("email") as? String {
                                    let post = Post(email: gorselUrl, yorum: yorum, gorselUrl: email)
                                    self.postDizisi.append(post)
                                }
                            }
                        }
                     
                        
                        
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.image = UIImage(named: "698394-icon-130-cloud-upload-512")
        return cell
        
    }

   

}
