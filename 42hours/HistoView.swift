//
//  HistoView.swift
//  42hours
//
//  Created by Adrien Freire on 07/12/2023.
//

import SwiftUI

struct HistoView: View {
    @ObservedObject var vm: Hours42ViewModel

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(vm.periods, id: \.self) { period in
                    Text("from: \(vm.getPeriodStart(period: period)) to: \(vm.getPeriodEnd(period: period))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
        }
    }
}

