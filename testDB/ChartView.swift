import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var viewModel = DB() // 서버에서 가져온 값
    @State var areaCountReal: [Int] = [0, 20, 20, 20, 20, 20] // 실제 한남대
    @State var areaCount1: [Int] = [45, 45, 45, 45] // 가정1
    @State var areaCount2: [Int] = [37, 37, 37, 37] // 가정2
    @State var areaCount3: [Int] = [90, 90, 90, 90] // 가정3
    @State var currentTab: String = "전체" // 처음 앱 시작할 때 그래프 어디꺼 보여줄지
    @State var mCount1: Int = 5
    @State var mCount2: Int = 5
    @State var mCount3: Int = 5
    @State var mCountSum: Int = 0
    @State var width: Double?
    @State var sum: Double = 0.0
    
    
    struct ValuePerCategory: Identifiable { // 그래프 구조체 생성
        var id = UUID()
        var name: String
        var value: Int
        var rout: Int
    }

    var realArea: [ValuePerCategory] { // 초기값 설정
        [
            .init(name: "한남대(Real)", value: areaCountReal[0], rout: 1), // 실제 우리가 서버에서 가져온 값을 나타내는 그래프
            .init(name: "한남대-1", value: areaCountReal[1],rout: 1),
            .init(name: "한남대-2", value: areaCountReal[2],rout: 1),
            .init(name: "한남대-3", value: areaCountReal[3],rout: 1),
            .init(name: "한남대-4", value: areaCountReal[4],rout: 1),
            .init(name: "한남대-5", value: areaCountReal[5],rout: 1)
        ]
    }

    var fakeArea1: [ValuePerCategory]{
        [
            .init(name: "A-1", value: areaCount1[0],rout: 5),
            .init(name: "A-2", value: areaCount1[1],rout: 5),
            .init(name: "A-3", value: areaCount1[2],rout: 5),
            .init(name: "A-4", value: areaCount1[3],rout: 5)
        ]
    }

    var fakeArea2: [ValuePerCategory]{
        [
            .init(name: "B-1", value: areaCount2[0],rout: 2),
            .init(name: "B-2", value: areaCount2[1],rout: 2),
            .init(name: "B-3", value: areaCount2[2],rout: 2),
            .init(name: "B-4", value: areaCount2[3],rout: 2)
        ]
    }

    var fakeArea3: [ValuePerCategory]{
        [
            .init(name: "C-1", value: areaCount3[0],rout: 3),
            .init(name: "C-2", value: areaCount3[1],rout: 3),
            .init(name: "C-3", value: areaCount3[2],rout: 3),
            .init(name: "C-4", value: areaCount3[3],rout: 3)
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
                        .init(name: "한남대", value: averageRealArea, rout: 1),
                        .init(name: "지역 A", value: averageFakeArea1,rout: 5),
                        .init(name: "지역 B", value: averageFakeArea2, rout: 2),
                        .init(name: "지역 C", value: averageFakeArea3, rout: 3)
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
            self.sum = (width ?? 0) / 500.0 // a와 b 값을 더해서 sum에 저장
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
    private func getRecommendedRoute2() -> String { //알고리즘 추천경로
        var routeText = "알고리즘 추천 경로: "
        let sortedData = selectedAreaData.sorted(by: { (item1, item2) in
            let valueDifference = abs(item1.value - item2.value)
            if valueDifference <= 10 {
                return item1.rout < item2.rout
            } else {
                return item1.value > item2.value
            }
        })
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
                if viewModel.value != nil {
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Text("실시간 쓰레기양")
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
                    
                    HStack {
                        Text(getRecommendedRoute2())
                            .font(.headline)
                            .padding(.bottom, 50)
                            .padding(.top, 20)
                        Text("\(mCount1), \(mCount2), \(mCount3), \(mCountSum), \(sum)")
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
