import SwiftUI
import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class DB: ObservableObject {
    var DB = Database.database().reference()
    
    @Published var value: Int?
    @Published var temperatureValue: Int?
    var updateAreaCountReal: ((Int) -> Void)?
    
    func readValue() {
        DB.child("width").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? Int ?? 0
            self.value = value
            self.updateAreaCountReal?(value)
        }
//        DB.child("temperature").observeSingleEvent(of: .value) { snapshot in
//                    let temperatureValue = snapshot.value as? Int ?? 0
//                    self.temperatureValue = temperatureValue
//                }
    }//readValue
}
