import SwiftUI

struct TextView: View {
    @StateObject var viewModel = DB()
    //@StateObject var viewModel2 = WeatherData()
    @State var a: Int?
    @State var b: Double?
    @State var sum: Double = 0.0
    func observeValue() {
        viewModel.DB.child("Mcount").observe(.value) { snapshot in
            let value = snapshot.value as? Int ?? 0
            DispatchQueue.main.async {
                self.a = value
                self.updateSum()
            }
        }
        viewModel.DB.child("width").observe(.value) { item in
            let value = item.value as? Double ?? 0
            DispatchQueue.main.async {
                self.b = value
                self.updateSum()
            }
        }
    }
    func updateSum(){
        if let aValue = a, let bValue = b {
                self.sum = Double(aValue) + bValue // a와 b 값을 더해서 sum에 저장
            }

    }
    var body: some View {
        Group {
            if viewModel.value != nil {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(a ?? 0)")
                    Text("\(b ?? 0)")
                    Text("\(sum)")
                    
                }
                .onAppear {
                    observeValue()
                }
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.readValue()
                    }
            }
        }
    }
}


struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}


