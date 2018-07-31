//
//  EnlargedImageViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/31/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class EnlargedImageViewController: UIViewController {
    
    var image : UIImage!
    
    @IBOutlet weak var enlargedimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enlargedimageView.image = image
    }
}
