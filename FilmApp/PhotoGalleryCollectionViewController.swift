//
//  CollectionViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = DateFormatter()
    var imageObjects: [ImageWithAttributes] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var editModeOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        imageObjects = CoreDataHelper.retrieveImage()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let imageObject = imageObjects[indexPath.item]
        
        if let photo = imageObject.image {
            cell.imageview.image = UIImage(data: photo)
        }
        cell.labelview.text = imageObject.date?.convertToString()
//        cell.labelview.text = String(imageObject.date)

//        cell.imageview.image = UIImage(data: imageObjects[indexPath.row].image!)
//        cell.labelview.text = formatter.string(from: imageObject.date!)
        
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editModeOn = !editModeOn
        collectionView.reloadData()
    }
    
}

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
}

extension PhotoGalleryCollectionViewController : CollectionViewCellDelegate {
    func delete(indexPath: IndexPath) {
        imageObjects.remove(at: indexPath.row)
        // CoreDataHelper.delete(freshImage: imageObjects[indexPath.item])
        collectionView.reloadData()
    }
}


