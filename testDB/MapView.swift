import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = DB()
    @State var areaCountReal: [Int] = [0, 20, 20, 20, 30, 50] // 실제 한남대
    @State var areaCount1: [Int] = [10, 20, 30, 40] // 가정1
    @State var areaCount2: [Int] = [50, 50, 70, 70] // 가정2
    @State var areaCount3: [Int] = [80, 70, 80, 30] // 가정3
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

    @State private var places: [Place] = []

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
        if let value = viewModel.value {
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

                places = [
                    Place(name: "한남대(Real\(value))", count: value, location: CLLocationCoordinate2D(latitude: 36.353482, longitude: 127.421727)),
                    Place(name: "한남대-1", count: areaCountReal[1], location: CLLocationCoordinate2D(latitude: 36.354508, longitude: 127.421807)),
                    Place(name: "한남대-2", count: areaCountReal[2], location: CLLocationCoordinate2D(latitude: 36.355149, longitude: 127.421449)),
                    Place(name: "한남대-3", count: areaCountReal[3], location: CLLocationCoordinate2D(latitude: 36.355196, longitude: 127.420742)),
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
                    
                ]//한남대: 6개, 가정1 5개, 가정2 4개, 가정3: 3개
//                @State var areaCountReal: [Int] = [0, 20, 20, 20, 30, 50] // 실제 한남대
//                @State var areaCount1: [Int] = [10, 20, 30, 40, 40] // 가정1
//                @State var areaCount2: [Int] = [50, 50, 70, 70] // 가정2
//                @State var areaCount3: [Int] = [80, 70, 80] // 가정3
                for index in 0..<places.count {
                    let place = places[index]
                    places[index].color = getBarColor(count: place.count)
                }
            }
        } else {
            Text("Loading...")
                .onAppear {
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
