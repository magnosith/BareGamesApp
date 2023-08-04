//
//  ProfileViewController.swift
//  bare-games
//
//  Created by Student on 27/07/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageCover: UIImageView!
    
    @IBOutlet weak var photoLiveOne: UIImageView!
    @IBOutlet weak var photoLiveTwo: UIImageView!
    @IBOutlet weak var photoLiveThree: UIImageView!
    @IBOutlet weak var photoLiveFour: UIImageView!
    @IBOutlet weak var coverButton: UIButton!
    
    var coverImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageSetLayout()
        addTapGesture()
        coverImagePickerController.delegate = self
    
    
}
    
    
    @IBAction func chooseCover(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Cover Photo", message: nil, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                        self.coverImagePickerController.sourceType = .camera
                        self.present(self.coverImagePickerController, animated: true, completion: nil)
                    }
                    alertController.addAction(cameraAction)
                }
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let photoLibraryAction = UIAlertAction(title: "Choose from Library Photo", style: .default) { action in
                        self.coverImagePickerController.sourceType = .photoLibrary
                        self.present(self.coverImagePickerController, animated: true, completion: nil)
                    }
                    alertController.addAction(photoLibraryAction)
                }
                
                alertController.popoverPresentationController?.sourceView = sender
                self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageTapped))
        self.imageProfile.isUserInteractionEnabled = true
        self.imageProfile.addGestureRecognizer(tap)
    }
    
    @objc func ImageTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction (title: "Choose from Library Photo", style: .default, handler: { action in
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = self.imageProfile
        self.present (alertController, animated: true, completion: nil)
       
    }
    
    func imageSetLayout() {
       
        imageProfile.layer.masksToBounds = false
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderWidth = 3
        imageProfile.layer.borderColor = UIColor.systemPink.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2

        
        photoLiveOne.layer.borderColor = UIColor.systemPink.cgColor
        photoLiveOne.layer.borderWidth = 2
        
        photoLiveTwo.layer.borderColor = UIColor.systemPink.cgColor
        photoLiveTwo.layer.borderWidth = 2
        
        photoLiveThree.layer.borderColor = UIColor.systemPink.cgColor
        photoLiveThree.layer.borderWidth = 2
        
        photoLiveFour.layer.borderColor = UIColor.systemPink.cgColor
        photoLiveFour.layer.borderWidth = 2
    }
    
    
}

//extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let picking = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        self.imageProfile.image = picking
//        dismiss(animated: true, completion: nil)
//    }
//}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picking = info[.editedImage] as? UIImage {
            if picker == coverImagePickerController {
                imageCover.image = picking
            } else {
                imageProfile.image = picking
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
