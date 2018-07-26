//
//  CoreDataHelper.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()


    static func newImage() -> ImageWithAtributes {
        let freshImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as! ImageWithAtributes
    
        return freshImage
    }

    static func saveImage() {
        do {
            try context.save()
        } catch let error {
            print ("Could not save \(error.localizedDescription)")
        }
    }

    static func delete(freshImage: ImageWithAtributes) {
        context.delete(freshImage)
        
        saveImage()
    }
    
    static func retrieveImage() -> [ImageWithAtributes] {
        do {
            let fetchRequest = NSFetchRequest<ImageWithAtributes>(entityName: "Image")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}
