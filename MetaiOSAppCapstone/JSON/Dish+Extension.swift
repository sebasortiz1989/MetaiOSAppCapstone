import Foundation
import CoreData


extension Dish {
    
    static func createDishesFrom(menuItems:[MenuItem],
                                 _ context:NSManagedObjectContext) {
        for menuItem in menuItems {
            guard let _ = exists(name: menuItem.title, context) else {
                continue
            }
            let oneDish = Dish(context: context)
            oneDish.name = menuItem.title
            if let price = Float(menuItem.price) {
                oneDish.price = price
            }
        }
    }
    
    
    static func exists(name: String,
                       _ context:NSManagedObjectContext) -> Bool? {
        let request = Dish.request()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish]
            else {
                return nil
            }
            return results.count > 0
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
  
    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
    
    
    static func with(name: String,
                     _ context:NSManagedObjectContext) -> Dish? {
        let request = Dish.request()
        
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "name",
                                              ascending: false,
                                              selector: #selector(NSString .localizedStandardCompare))
        request.sortDescriptors = [sortDescriptor]
        
        do {
            guard let results = try context.fetch(request) as? [Dish],
                  results.count == 1,
                  let dish = results.first
            else { return Dish(context: context) }
            return dish
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func delete(with name: String,
                       _ context:NSManagedObjectContext) -> Bool {
        let request = Dish.request()
        
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        
        do {
            guard let results = try context.fetch(request) as? [Dish],
                  results.count == 1,
                  let dish = results.first
            else {
                return false
            }
            context.delete(dish)
            return true
        } catch (let error){
            print(error.localizedDescription)
            return false
        }
    }
    
    
    class func deleteAll(_ context:NSManagedObjectContext) {
        let request = Dish.request()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { return }
            try persistentStoreCoordinator.execute(deleteRequest, with: context)
            save(context)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    static func save(_ context:NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    class func readAll(_ context:NSManagedObjectContext) -> [Dish]? {
        let request = Dish.request()
        do {
            guard let results = try context.fetch(request) as? [Dish],
                  results.count > 0 else { return nil }
            return results
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
}
