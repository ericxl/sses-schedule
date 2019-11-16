//
//  ContentView.swift
//  schedule
//
//  Created by Eric Liang on 10/20/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import SwiftUI
//import ScheduleCore

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        NavigationView {
            GeometryReader { metrics in
                List(1..<9) { item in
                    TableRow(index: item).frame(height: metrics.size.height / 8)
                }
            }
            .navigationBarTitle("Schedule", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                
                    }) {
                    Button(action: {}) {
                        Image(systemName: "pencil").font(.title)
                    }
                })
        }
        .accentColor(Color(hex: colorScheme == .light ? "8D2B20" : "CB3E2E"))
        
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            ContentView()
                .environment(\.colorScheme, .dark)
            
            ContentView()
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            
            ContentView()
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
        }
    }
}
#endif
