//
//  PersonController.swift
//  PairRandomizer
//
//  Created by Will morris on 6/14/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import Foundation
import Firebase

class PersonController {
    
    static let shared = PersonController()
    
    var personArray: [Person] = []
    
    let dataBase = Firestore.firestore()
    
    func createPerson(name: String) {
        let person = Person(name: name)
        personArray.append(person)
        saveToFirestore(person: person)
    }
    
    func randomize() {
        var newArray: [Person] = []
        for _ in 0...(personArray.count - 1) {
            let person = personArray.randomElement()
            let index = personArray.firstIndex(of: person!)
            personArray.remove(at: index!)
            newArray.append(person!)
        }
        personArray = newArray
    }
    
    func saveToFirestore(person: Person) {
        var ref: DocumentReference? = nil
        ref = dataBase.collection("person").addDocument(data: [
            "name" : "\(person.name)"
            ], completion: { (err) in
                if let err = err {
                    print("Error adding document: \(err) : \(err.localizedDescription)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        })
    }
    
    func loadFromFirestore(completion: @escaping () -> Void) {
        dataBase.collection("person").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let person = Person(name: data.first?.value as! String)
                    self.personArray.append(person)
                }
            }
            completion()
        })
    }
}
