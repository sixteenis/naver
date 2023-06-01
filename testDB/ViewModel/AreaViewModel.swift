////
////  AreaViewModel.swift
////  testDB
////
////  Created by 박성민 on 2023/05/19.
////
//
//import Foundation
//
//class AreaViewModel: ObservableObject{
//    //property
//    //Published: State와 같이 상태값을 선언하지만 class에서는 Published 사용 -> View에서 변경되면 새로운 변경사항을 알기 위해서
//    @Published var areaArray: [AreaModel] = []
//    @Published var isLoading: Bool = false
//    //@Published var viewModel = DB()
//    init(){
//        getArea()
//    }
//    //function
//    //array에 추가하는 함수
//    func getArea() {
//        let realArea = AreaModel(name: "한남대", count: 0, xArea: 123.111, yArea: 124151.1111)
//
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//            self.areaArray.append(realArea)
//
//
//            self.isLoading = false
//        }
//
//    }
//}
