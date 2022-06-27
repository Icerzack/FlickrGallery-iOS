import UIKit
import CoreData


protocol StorageManagerProtocol: AnyObject{
    func saveData(withName name: String, withPhoto photoData: Data)
    func getData() -> [AnyObject]
}

class CoreDataStorageManager: StorageManagerProtocol{
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(withName name: String, withPhoto photoData: Data){
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
    
    func getData() -> [AnyObject]{
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
