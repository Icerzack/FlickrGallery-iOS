//
//  StorageManager.swift
//  FlickrGallery
//
//  Created by Max Kuznetsov on 26.06.2022.
//

import UIKit
import CoreData


protocol StorageManager: AnyObject{
    func saveData(withName name: String, withPhoto photoData: Data) throws
    func getData() throws -> [Any]
}

class CoreDataStorageManager: StorageManager{
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(withName name: String, withPhoto photoData: Data) throws{
        guard let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) else { return }
        
        let photo = Photo(entity: entity, insertInto: context)
        photo.name = name
        photo.imageData = photoData
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getData() throws -> [Any]{
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return []
    }
}
