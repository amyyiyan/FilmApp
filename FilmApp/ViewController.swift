//
//  ViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/24/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit
import CoreImage

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
//            cameraView.image = image
            let newImageObject = CoreDataHelper.newImage()
//            let imageData = UIImagePNGRepresentation(image)
            let uiImageFixedOrientation = fixOrientation(img: image)
            let fixedOrientation = CIImage(image: uiImageFixedOrientation)
            
            guard let sepiaFilter = CIFilter(name:"CISepiaTone",
                                             withInputParameters:
                [
                    kCIInputImageKey: fixedOrientation,
                    kCIInputIntensityKey: 0.5
                ]) else {
                    return
            }
            guard let sepiaCIImage = sepiaFilter.outputImage else {
                return
            }
            
            
            
            
            let outputImage = UIImage(ciImage: sepiaCIImage)
            
            newImageObject.image = sepiaCIImage.png(size: uiImageFixedOrientation.size)
            newImageObject.date = Date()
//            cameraView.image = UIImage(data: newImageObject.image!)
            
            CoreDataHelper.saveImage()
            print(newImageObject.image)
            print(newImageObject.date)
            cameraView.image = outputImage
        }
        else  {
            //error
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImageOrientation.up) { return img }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)   // QUALITY min = 0 / max = 1
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

extension CIImage {
    func png(size: CGSize) -> Data? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        UIImage(ciImage: self).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()?.png
    }
}
