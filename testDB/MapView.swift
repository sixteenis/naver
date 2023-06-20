import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = DB()
    @State var areaCountReal: [Int] = [10, 20, 40, 70, 20, 20] // 실제 한남대
    @State var areaCount1: [Int] = [45, 45, 45, 45] // 가정1
    @State var areaCount2: [Int] = [37, 37, 37, 37] // 가정2
    @State var areaCount3: [Int] = [90, 90, 90, 90] // 가정3
    //@State var mCount: Int?
    @State var width: Double?
    @State var sum: Int = 0 // 수정된 부분
    @State var mCount1: Int = 5
    @State var mCount2: Int = 5
    @State var mCount3: Int = 5
    @State var mCountSum: Int = 0
    @State private var places: [Place] = []
    struct Place: Identifiable {
        var id: UUID = UUID()
        var name: String
        var count: Int
        var location: CLLocationCoordinate2D
        var color: Color = .white
    }

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.353482, longitude: 127.421727),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    func observeValue() { //DB에서 받은 값을 실시간으로 areaCountReal[0]에 갱신

        viewModel.DB.child("width").observe(.value) { item in
            let value = item.value as? Double ?? 0
            DispatchQueue.main.async {
                self.width = value
                self.updateSum()
            }
        }
        viewModel.DB.child("distance1").observe(.value) { snapshot in
            let value = snapshot.value as? Double ?? 0
            DispatchQueue.main.async {
                self.mCount1 = Int(value)
                self.updateSum()
                    }
//               self.viewModel.value = value
//               self.viewModel.updateAreaCountReal?(value)
        }//Mcount
        viewModel.DB.child("distance2").observe(.value) { snapshot in
            let value = snapshot.value as? Double ?? 0
            DispatchQueue.main.async {
                self.mCount2 = Int(value)
                self.updateSum()
                    }
//               self.viewModel.value = value
//               self.viewModel.updateAreaCountReal?(value)
        }//Mcount
        viewModel.DB.child("distance3").observe(.value) { snapshot in
            let value = snapshot.value as? Double ?? 0
            DispatchQueue.main.async {
                self.mCount3 = Int(value)
                self.updateSum()
                    }
//               self.viewModel.value = value
//               self.viewModel.updateAreaCountReal?(value)
        }//Mcount
        
       }
    
    func updateSum(){
        if let bValue = width{ //let aValue = mCount,
            self.sum = Int((width ?? 0) / 500.0) // a와 b 값을 더해서 sum에 저장
            }
        self.mCountSum = 210 - (mCount1 + mCount2 + mCount3) / 3
        if mCountSum < 0 {
            return
        }else if mCountSum < 30{
            sum = sum * 2
            return
        }else if mCountSum < 60{
            sum = sum * 3
            return
        }else if mCountSum < 90{
            sum = sum * 4
            return
        }else if mCountSum < 120{
            sum = sum * 5
            return
        }
        
        if Int(sum) == 0 {
            for i in 0...5{
                self.areaCountReal[i] = 0
            }
        }
        else if Int(sum) < 2{
            for i in 0...5{
                self.areaCountReal[i] = 15
            }
        }else if Int(sum) < 4{
            for i in 0...5{
                self.areaCountReal[i] = 30
            }
        }else if Int(sum) < 6{
            for i in 0...5{
                self.areaCountReal[i] = 45
            }
        }else if Int(sum) < 8{
            for i in 0...5{
                self.areaCountReal[i] = 60
            }
        }else if Int(sum) < 10{
            for i in 0...5{
                self.areaCountReal[i] = 75
            }
        }else if Int(sum) < 12{
            for i in 0...5{
                self.areaCountReal[i] = 90
            }
        }
        else{
            for i in 0...5{
                self.areaCountReal[i] = 100
            }
        }
         

    }//mcount랑 width값을 받아서 어떤식으로 표현할지 바꾸는 함수
    private func getBarColor(count: Int) -> Color {
        switch count {
        case 0...30:
            return .green
        case 31...70:
            return .orange
        case 71...100:
            return .red
        default:
            return .white
        }
    }

    var body: some View {
        if viewModel.value != nil {
            Map(coordinateRegion: $region, annotationItems: places) { item in
                MapAnnotation(coordinate: item.location, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                    VStack {
                        Text(item.name)
                            .font(.footnote)
                        Circle()
                            .stroke(item.color, lineWidth: 2)
                            .foregroundColor(item.color.opacity(0.3))
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .onAppear {
                viewModel.readValue()
                observeValue()
                updateSum()
                places = [
                    Place(name: "한남대(Real)\(mCountSum), \(sum)", count: areaCountReal[0], location: CLLocationCoordinate2D(latitude: 36.355196, longitude: 127.420742)), // 수정된 부분
                    Place(name: "한남대-1", count: areaCountReal[1], location: CLLocationCoordinate2D(latitude: 36.354508, longitude: 127.421807)),
                    Place(name: "한남대-2", count: areaCountReal[2], location: CLLocationCoordinate2D(latitude: 36.355149, longitude: 127.421449)),
                    Place(name: "한남대-3", count: areaCountReal[3], location: CLLocationCoordinate2D(latitude: 36.353482, longitude: 127.421727)),
                    Place(name: "한남대-4", count: areaCountReal[4], location: CLLocationCoordinate2D(latitude: 36.354255, longitude: 127.419681)),
                    Place(name: "한남대-4", count: areaCountReal[5], location: CLLocationCoordinate2D(latitude: 36.354255, longitude: 127.419681)),
                    Place(name: "A-1", count: areaCount1[0], location: CLLocationCoordinate2D(latitude: 36.354061, longitude: 127.428934)),
                    Place(name: "A-2", count: areaCount1[1], location: CLLocationCoordinate2D(latitude: 36.353084, longitude: 127.428897)),
                    Place(name: "A-3", count: areaCount1[2], location: CLLocationCoordinate2D(latitude: 36.355449, longitude: 127.428688)),
                    Place(name: "A-4", count: areaCount1[3], location: CLLocationCoordinate2D(latitude: 36.352932, longitude: 127.429143)),
                    Place(name: "B-1", count: areaCount2[0], location: CLLocationCoordinate2D(latitude: 36.351454, longitude: 127.421698)),
                    Place(name: "B-2", count: areaCount2[1], location: CLLocationCoordinate2D(latitude: 36.350636, longitude: 127.420984)),
                    Place(name: "B-3", count: areaCount2[2], location: CLLocationCoordinate2D(latitude: 36.350795, longitude: 127.420251)),
                    Place(name: "B-4", count: areaCount2[3], location: CLLocationCoordinate2D(latitude: 36.350160, longitude: 127.420601)),
                    Place(name: "C-1", count: areaCount3[0], location: CLLocationCoordinate2D(latitude: 36.351026, longitude: 127.424747)),
                    Place(name: "C-2", count: areaCount3[1], location: CLLocationCoordinate2D(latitude: 36.350814, longitude: 127.425141)),
                    Place(name: "C-3", count: areaCount3[2], location: CLLocationCoordinate2D(latitude: 36.351052, longitude: 127.425787)),
                    Place(name: "C-4", count: areaCount3[3], location: CLLocationCoordinate2D(latitude: 36.350691, longitude: 127.424080))
                ] // 한남대: 6개, 가정1 5개, 가정2 4개, 가정3: 3개
                
                for index in 0..<places.count {
                    let place = places[index]
                    places[index].color = getBarColor(count: place.count)
                }
            }
            .onChange(of: width) { _ in
                updateSum()
            }
        } else {
            Text("Loading...")
                .onAppear {
                    observeValue()
                    updateSum()
                    viewModel.readValue()
                }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
