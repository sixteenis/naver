//
//  View.swift
//  testDB
//
//  Created by 박성민 on 2023/05/31.
//

import SwiftUI

struct ViewTest: View {
    var body: some View {
                TabView {
                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("지도")
                        }
                    ChartView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("차트")
                        }
                } // TabView
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        ViewTest()
    }
}
