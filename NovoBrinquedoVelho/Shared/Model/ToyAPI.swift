//
//  ToyAPI.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 03/01/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase

enum APIError: Error {
    case badURL
    case taskError
    case noResponse
    case invalidStatusCode(Int)
    case noData
    case decodeError
}

class ToyAPI: ObservableObject {
    
    @Published
    var toys = [Toy]()
    
    private let toyDonationCollection = Firestore.firestore().collection("toyDonation")
    
    func loadToys(onComplete: @escaping (Result<[Toy], APIError>) -> Void) {
        toyDonationCollection.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.toys = documents.compactMap{ (queryDocumentSnapshot) -> Toy? in
                return try? queryDocumentSnapshot.data(as: Toy.self)
            }
            onComplete(.success(self.toys))
        }
    }
    
    func loadToy(toy: Toy, onComplete: @escaping (Result<Toy, APIError>) -> Void) {
        toyDonationCollection.document(String(toy.id ?? "0")).getDocument(completion: { document, error in
            guard let toy = try? document?.data(as: Toy.self) else {
                return
            }
            onComplete(.success(toy))
        })
        
    }
    
    func addToy(toy: Toy) {
        do {
            let _ = try toyDonationCollection.addDocument(from: toy)
        } catch {
            print("Erro ao tentar realizar a inclusão de um binquedo para doação: \(error)")
        }
    }
    
    func editToy(toy: Toy) {
        let descriptions: [AnyHashable: Any] = [
            "toyName": toy.toyName ?? "",
            "toyState": toy.toyState ?? "0",
            "toyPhoto": toy.toyPhoto ?? "",
            "donorAddress": toy.donorAddress ?? "",
            "donorTelephone": toy.donorTelephone,
            "donorName": toy.donorName ?? "",
            "toyDescription": toy.toyDescription ?? ""
        ]
        toyDonationCollection.document(String(toy.id ?? "0")).updateData(descriptions) { err in
            if let err = err {
                print("Error durante a tentativa de atualizar a doação do brinquedo: \(err)")
            }
        }
    }
    
    func deleteToy(toy: Toy) {
        toyDonationCollection.document(String(toy.id ?? "0")).delete { err in
            if let err = err {
                print("Erro durante a tentativa de deletar a doação do brinquedo: \(err)")
            }
        }
    }
    
}
