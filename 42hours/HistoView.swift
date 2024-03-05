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
        List(vm.periods.reversed()) { period in
            PeriodView(vm: vm, period: period)

        }
        
    }
}

struct PeriodView: View {
    @ObservedObject var vm: Hours42ViewModel
    @State var isModified: Bool = false
    var period: Period
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("From:")
                Text("To:")
                Text("Total:")
            }
            Spacer()
            VStack {
                Text(vm.getPeriodStart(period: period))
                Text(vm.getPeriodEnd(period: period))
                Text(vm.getTimePeriod(period: period))
            }
            .padding(.leading)
            Spacer()
        }
        .padding(10)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                if (period.end != nil) {
                    withAnimation {
                        isModified.toggle()
                    }
                }
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            .tint(Color(red: 1.0, green: 0.7, blue: 0.0))
            Button {
                if (period.end != nil) {
                    withAnimation {
                        vm.deletePeriod(period: period)
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .sheet(isPresented: $isModified, content: {
            CreaPeriodView(vm: vm, period: period, from: period.start ?? Date(), to: period.end ?? Date(), isModified: $isModified)
        })
    }
}

struct CreaPeriodView: View {
    @ObservedObject var vm: Hours42ViewModel
    @State var period: Period
    @State var from: Date
    @State var to: Date
    @Binding var isModified: Bool
    var body: some View {
        VStack {
            DatePicker("From:", selection: $from)
            DatePicker("To:", selection: $to)
            Button(action: {
                vm.changeTime(oldPeriod: period, from: from, to: to)
                isModified.toggle()
            }, label: {
                Text("Valider")
            })
            .padding()
        }
        .padding(.horizontal)
    }
}
