import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var viewModel = DB() // 서버에서 가져온 값
    @State var areaCountReal: [Int] = [0, 20, 20, 20, 30, 50] // 실제 한남대
    @State var areaCount1: [Int] = [10, 20, 30, 40] // 가정1
    @State var areaCount2: [Int] = [50, 50, 70, 70] // 가정2
    @State var areaCount3: [Int] = [80, 70, 80, 30] // 가정3
    @State var currentTab: String = "전체" // 처음 앱 시작할 때 그래프 어디꺼 보여줄지
    
    struct ValuePerCategory: Identifiable { // 그래프 구조체 생성
        var id = UUID()
        var name: String
        var value: Int
    }

    var realArea: [ValuePerCategory] { // 초기값 설정
        [
            .init(name: "실제 데이터", value: areaCountReal[0]), // 실제 우리가 서버에서 가져온 값을 나타내는 그래프
            .init(name: "한남대-1", value: areaCountReal[1]),
            .init(name: "한남대-2", value: areaCountReal[2]),
            .init(name: "한남대-3", value: areaCountReal[3]),
            .init(name: "한남대-4", value: areaCountReal[4]),
            .init(name: "한남대-5", value: areaCountReal[5])
        ]
    }

    var fakeArea1: [ValuePerCategory]{
        [
            .init(name: "지역 A-1", value: areaCount1[0]),
            .init(name: "지역 A-2", value: areaCount1[1]),
            .init(name: "지역 A-3", value: areaCount1[2]),
            .init(name: "지역 A-4", value: areaCount1[3])
        ]
    }

    var fakeArea2: [ValuePerCategory]{
        [
            .init(name: "지역 B-1", value: areaCount2[0]),
            .init(name: "지역 B-2", value: areaCount2[1]),
            .init(name: "지역 B-3", value: areaCount2[2]),
            .init(name: "지역 B-4", value: areaCount2[3])
        ]
    }

    var fakeArea3: [ValuePerCategory]{
        [
            .init(name: "지역 C-1", value: areaCount3[0]),
            .init(name: "지역 C-2", value: areaCount3[1]),
            .init(name: "지역 C-3", value: areaCount3[2]),
            .init(name: "지역 C-4", value: areaCount3[3])
        ]
    }

    var selectedAreaData: [ValuePerCategory] {
        switch currentTab {
        case "전체":
            let averageRealArea = areaCountReal.reduce(0, +) / areaCountReal.count //각 지역별 평균을 그래프로 보여줌
                    let averageFakeArea1 = fakeArea1.reduce(0, { $0 + $1.value }) / fakeArea1.count
                    let averageFakeArea2 = fakeArea2.reduce(0, { $0 + $1.value }) / fakeArea2.count
                    let averageFakeArea3 = fakeArea3.reduce(0, { $0 + $1.value }) / fakeArea3.count
                    
                    return [
                        .init(name: "한남대", value: averageRealArea),
                        .init(name: "지역 A", value: averageFakeArea1),
                        .init(name: "지역 B", value: averageFakeArea2),
                        .init(name: "지역 C", value: averageFakeArea3)
                    ]
        case "한남대":
            return realArea
        case "1":
            return fakeArea1
        case "2":
            return fakeArea2
        case "3":
            return fakeArea3
        default:
            return []
        }
    }
    
    func observeValue() { //DB에서 받은 값을 실시간으로 areaCountReal[0]에 갱신
           viewModel.DB.child("key1").observe(.value) { snapshot in
               let value = snapshot.value as? Int ?? 0
               DispatchQueue.main.async {
                           self.areaCountReal[0] = value
                       }
//               self.viewModel.value = value
//               self.viewModel.updateAreaCountReal?(value)
           }
       }
    
    private func getBarColor(value: Int) -> Color { //데이터에 값을 확인하고 막대기 색깔 바꾸기
        switch value {
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
    private func getRecommendedRoute() -> String { //추천경로
           var routeText = "추천 경로: "
           let sortedData = selectedAreaData.sorted(by: { $0.value > $1.value })
           for (index, item) in sortedData.enumerated() {
               routeText += item.name
               if index < sortedData.count - 1 {
                   routeText += " -> "
               }
           }
           return routeText
       }
    var body: some View {
        VStack {
            Group {
                if let value = viewModel.value {
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Text("실시간 지역별 쓰레기량")
                            .padding(.leading,20)
                            .font(.title)
                            .hLeading()
                    }
                    HStack {
                        
                        Text("범위 설정")
                            .fontWeight(.semibold)
                        Picker("", selection: $currentTab) {
                            Text("전체")
                                .tag("전체")
                            Text("한남대")
                                .tag("한남대")
                            Text("1")
                                .tag("1")
                            Text("2")
                                .tag("2")
                            Text("3")
                                .tag("3")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 10)
                    }
                    .padding()
                }
                .onAppear {
                            observeValue()
                        }//실시간으로 값 변경
                //원래 여기
                    Chart(selectedAreaData) { item in
                        BarMark(
                            x: .value("name", item.name),
                            y: .value("saa", item.value)
                        )
                        .foregroundStyle(getBarColor(value: item.value))
                    }
                    .chartYScale(domain: 0...100) //y좌표 즉 카운트 값을 100으로 고정
                    
                    .frame(width: 400, height: 300)
                    
//                    .onAppear {
//                        areaCountReal[0] = value
//                    }
                    HStack {
                        Text(getRecommendedRoute())
                            .font(.headline)
                            .padding(.bottom, 50)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2)) // 배경색 추가
                    .cornerRadius(10) // 모서리를 둥글게 만들기
                    

                    .vTop()
                    
                } else {
                    Text("Loading...")
                        .onAppear {
                            viewModel.readValue()
                        }
                }
            }
        }
    }
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
