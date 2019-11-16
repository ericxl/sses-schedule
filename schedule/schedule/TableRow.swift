//
//  TableRow.swift
//  schedule
//
//  Created by Eric Liang on 10/20/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import SwiftUI

struct TableRow: View {
    var index : Int
    var body: some View {
        HStack(spacing: 20) {
            Text(index.asNumeric)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Text1")
                .font(.title)
        }
    }
}


#if DEBUG
struct TableRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(1..<9) { item in
                TableRow(index: item)
            }
            .navigationBarTitle("Schedule", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                
                }) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Image(systemName: "pencil").font(.title)
                    }
                })
            
        }.accentColor(Color(hex: "8D2B20"))
    }
}
#endif
