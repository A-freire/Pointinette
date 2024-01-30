//
//  ContentView.swift
//  42hours
//
//  Created by Adrien Freire on 05/12/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var vm: Hours42ViewModel
    @State var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            TimerView(vm: vm)
                .tabItem { Image(systemName: "timer") }
                .tag(1)
            HistoView(vm: vm)
                .tabItem { Image(systemName: "person.badge.clock") }
                .tag(2)
        }
    }
}

