//
//  EnlargedImageViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/31/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit
import Foundation

class EnlargedImageViewController: UIViewController {
    
    var image : UIImage!
    var date : Date!
    
    @IBOutlet weak var enlargedimageView: UIImageView!
    
    @IBOutlet weak var datelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        enlargedimageView.image = image
        datelabel.text = date.convertToFullString()
    }
    
    @IBAction func savePhotoButton(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(enlargedimageView.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your photo has been saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deletePhotoButton(_ sender: Any) {
        
    }

}

