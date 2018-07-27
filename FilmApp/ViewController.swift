//
//  ViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/24/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var newImage: UIImage!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBAction func cameraUpload(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savebutton(_ sender: Any) {
        CoreDataHelper.saveImage()
        self.performSegue(withIdentifier: "saveSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
           let destinationVC = segue.destination as! PhotoGalleryCollectionViewController
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraView.image = image
            let newImageObject = CoreDataHelper.newImage()
            let imageData = UIImagePNGRepresentation(image)
            newImageObject.image = imageData
            CoreDataHelper.saveImage()
        }
        else  {
            //error
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


