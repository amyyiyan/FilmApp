//
//  CollectionViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lastImageSelected: UIImage?
    var lastDateSelected: Date?

    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = DateFormatter()
    var imageObjects: [ImageWithAttributes] = [] {
        didSet {
//            collectionView.reloadData()
            let indexPaths = collectionView.indexPathsForVisibleItems
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    var editModeOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        collectionView.reloadData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        imageObjects = CoreDataHelper.retrieveImage()
//        collectionView.reloadData()
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
//        cell.labelview.text = String(imageObject.date)
//        cell.imageview.image = UIImage(data: imageObjects[indexPath.row].image!)
//        cell.labelview.text = formatter.string(from: imageObject.date!)
        
        cell.isEditing = self.editModeOn
        cell.labelview.text = imageObject.date?.convertToString()
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let imageObj = imageObjects[indexPath.item].image else { return }
        lastImageSelected = UIImage(data: imageObj)
//      lastImageSelected = UIImage(data: imageObjects[indexPath.item].image!)
        lastDateSelected = imageObjects[indexPath.item].date
        performSegue(withIdentifier: "enlargedImageSegue" , sender: indexPath)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editModeOn = !editModeOn
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "enlargedImageSegue" {

            guard let indexPath = sender as? IndexPath else { return }
            let imageObject = imageObjects[indexPath.item]
            
            let destination = segue.destination as! EnlargedImageViewController
            destination.image = lastImageSelected
            destination.date = lastDateSelected
            destination.imageAttribute = imageObject

        }
    }
    
}

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
    
    func convertToFullString() -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy' 'HH:mm:ss"
        return formatter.string(from: self)
    }
}

extension PhotoGalleryCollectionViewController : CollectionViewCellDelegate {
    func delete(indexPath: IndexPath) {
        CoreDataHelper.delete(freshImage: imageObjects[indexPath.item])
        imageObjects.remove(at: indexPath.row)
        print("Pressed delete")
        collectionView.reloadData()
        CoreDataHelper.saveImage()
    }
}


