//
//  _2hoursApp.swift
//  42hours
//
//  Created by Adrien Freire on 05/12/2023.
//

import SwiftUI

@main
struct Hours42App: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView(vm: Hours42ViewModel(context: dataController.container.viewContext))
        }
    }
}
