//
//  Toy.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 03/01/22.
//

import Foundation
import FirebaseFirestoreSwift	

struct Toy: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var toyName: String?
    var toyState: Int?
    var toyPhoto: String?
    var donorAddress: String?
    var donorTelephone: Int
    var donorName: String?
    var toyDescription: String?
    
    var toyStateName: String {
        switch toyState {
        case 0:
            return "Mau estado"
        case 1:
            return "Bom estado"
        default:
            return "Ótimo estado"
        }
    }
    
}
