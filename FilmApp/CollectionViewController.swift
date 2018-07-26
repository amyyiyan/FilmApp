//
//  CollectionViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let formatter = DateFormatter()
    var imageObjects = [ImageWithAtributes]() {
        didSet {
            collectionview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = CoreDataHelper.retrieveImage()()
        
        var imageObject = ImageWithAtributes()
        imageObject.date = Date()
        imageObject.image =  UIImagePNGRepresentation(#imageLiteral(resourceName: "download"))
        imageObjects.append(imageObject)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageview.image = UIImage(data: imageObjects[indexPath.row].image!)
        cell.labelview.text = formatter.string(from: imageObjects[indexPath.row].date!)
        
        return cell
    }
}
