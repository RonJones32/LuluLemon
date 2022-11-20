//
//  LuluLemonTests.swift
//  LuluLemonTests
//
//  Created by Ronald Jones on 11/19/22.
//

import XCTest
import CoreData
@testable import LuluLemon

class LuluLemonTests: XCTestCase {
        
    lazy var mockPersistantContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "LuluLemon", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false 
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                precondition( description.type == NSInMemoryStoreType )
                                            
                if let error = error {
                    fatalError("Error: \(error)")
                }
            }
            return container
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main] )!
            return managedObjectModel
        }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
            return self.mockPersistantContainer.newBackgroundContext()
        }()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        clearData() // Clear all data
        super.tearDown()
    }
    
    func insertGarment( name: String, date: Date ) -> Garment? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Garment", into: mockPersistantContainer.viewContext)

            obj.setValue(name, forKey: "title")
            obj.setValue(date, forKey: "dateCreated")

            return obj as? Garment
        }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func clearData() {
            
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Garment")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()

    }
    
    func fetchAll() -> [Garment] {

        insertGarment(name: "Shirt", date: Date())
        insertGarment(name: "Pants", date: Date())
        insertGarment(name: "Hat", date: Date())
        insertGarment(name: "Sweater", date: Date())
        
            do {
                try mockPersistantContainer.viewContext.save()
            }  catch {
                print("create fakes error \(error)")
            }
    
        let request: NSFetchRequest<Garment> = Garment.fetchRequest()
        let results = try? mockPersistantContainer.viewContext.fetch(request)
        return results ?? [Garment]()
    }

    func testAddGarment() {
        let todo = insertGarment(name: "Shirt", date: Date())
        XCTAssertNotNil( todo )
    }
    
    func testRemoveGamrnet() {

        
        //Given an item in persistent store
        let items = fetchAll()
        let item = items[0]

        let numberOfItems = items.count

        //When we remove a item
        remove(objectID: item.objectID)
        save()

        //Assert number of items is - 1
        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfItems-1)

    }

    //Convenient method for getting the number of data in store now
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Garment")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
}
