import SwiftUI
import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class DB: ObservableObject {
    var DB = Database.database().reference()
    
    @Published var value: Int?
    var updateAreaCountReal: ((Int) -> Void)?
    
    func readValue() {
        DB.child("key1").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? Int ?? 0
            self.value = value
            self.updateAreaCountReal?(value)
        }
    }
}
