//
//  DataController.swift
//  TableViewDemo
//
//  Created by Josip Maric on 22/05/2019.
//  Copyright © 2019 Josip Maric. All rights reserved.
//

import Foundation
import CoreData

// API prema bazi podataka
class DataController {
    
    // DataController modeliramo kao singleton
    static let shared = DataController()
    private init() {} // Prevent clients from creating another instance.
    
    // NSPersistentContainer je ulazna tocka prema Core Data
    // NSPersistentContainer stvara i upravlja NSManagedObjectModel-om (u ovom slucaju to je model "Model")
    // NSManagedObjectModel sadrzi definicije entiteta sa svojim atributima i medusobnim vezama (.xcdatamodeld datoteka)
    // NSPersistentContainer stvara i NSManagedObjectContext, objekt preko kojeg vrsimo interakciju s bazom podataka
    // Na NSManagedObjectContext objekt mozemo gledati kao na jedan shapshot baze podataka, trenutno stanje baze podataka
    // iz njega dohvacamo podatke iz baze, mijenajmo ih, stvaramo i brisemo.
    // Sve promjene nad objektima napravljene u NSManagedObjectContextu su napravljeno samo nad objektima u memoriji, da bi se te promjene perzistirale u bazu potrebno je spremiti context
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // U DataController smjestamo metode koje komuniciraju s bazom; stvaranje, dohvacanje, brisanje i azuriranje podataka u bazi
    // Ovdje je primjer metode koja dohvaca sve review-ove iz baze podataka
    func fetchQuizzes() -> [Quiz]? {
        // Genericki razred NSFetchRequest predstavlja upit na bazu podataka kojim dohvacamo objekte nekog razreda
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        // NSFetchRequestu mozemo postaviti NSPredicate koji sadrzi uvjete koje objekti trebaju zadovoljiti da bi se dohvatili (slicno kao WHERE u SQL)
        // NSFetchRequestu mozemo postaviti i NSSortDescriptor-e kojima odredujemo atribute po kojima se rezultati upita sortiraju (kao ORDER BY)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let context = DataController.shared.persistentContainer.viewContext
        // izvodenje upita
        let quizzes = try? context.fetch(request)
        return quizzes
    }
    
    // Sve promjene nad objektima napravljene u NSManagedObjectContextu su napravljeno samo nad objektima u memoriji, da bi se te promjene perzistirale u bazu potrebno je spremiti context, metodom .save()
    func saveContext () {
        
        // viewContext je NSManagedObjectContext objekt iz kojeg dohvacamo, u kojem stvaramo, brisemo ili mijenjamo objekte na main thread-u
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
