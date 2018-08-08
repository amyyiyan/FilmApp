//
//  ImageWithAttributes.swift
//  FilmApp
//
//  Created by Amy Liu on 8/7/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension ImageWithAttributes {
    var image: UIImage {
        get {
        //get url from doc folder
        let fileManager = FileManager.default
        
        let documentUrl = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        
        let imageUrl = documentUrl.appendingPathComponent(self.imagePath!)
        
        //get data from url
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)!
        
        //get uiimage from data
        return image
        }
        set {
            //get a new value
            let newImage = newValue
            
            //create a file name
            let filePath = String(Date().timeIntervalSince1970)
            let fileManager = FileManager.default
            
            //get the documents url
            let documentUrl = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
            
            //append filenmae to doc url
            let imagePath = documentUrl.appendingPathComponent("\(filePath).jpg")

            //change to data
            let imageData = newImage.png!

            //store data at url
            try! imageData.write(to: imagePath, options: Data.WritingOptions.atomic)
            
            //update imagepath
            self.imagePath = imagePath.lastPathComponent
        }
    }
}
