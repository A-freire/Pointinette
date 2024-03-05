//
//  TimerView.swift
//  42hours
//
//  Created by Adrien Freire on 07/12/2023.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var vm: Hours42ViewModel

    var body: some View {
        VStack() {
            Spacer()
            Text(vm.getTimeThisMount())
                .font(.largeTitle)
            Spacer()
            ShowTIme(vm: vm)
            Spacer()
            ButtonTime(vm: vm)
            Spacer()
        }
    }
}

struct ShowTIme: View {
    @ObservedObject var vm: Hours42ViewModel

    var body: some View {
        HStack {
            if (vm.getRefresh() == true && vm.timeSince != "") {
                Image(systemName: "arrow.clockwise")
                    .onTapGesture {
                        vm.getStartPeriod()
                    }
            }
            Text(vm.timeSince)
                .font(.subheadline)
                .onAppear(perform: {
                    vm.refreshPressed()
                    vm.getStartPeriod()
                })
//                .onTapGesture {
//                    vm.getStartPeriod()
//                }
            if (vm.getRefresh() != true && vm.timeSince != "") {
                Image(systemName: "arrow.clockwise")
                    .onTapGesture {
                        vm.getStartPeriod()
                    }
            }
        }
        .onLongPressGesture(perform: {vm.setRefresh()})
    }
}

struct ButtonTime: View {
    @ObservedObject var vm: Hours42ViewModel

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundStyle(.gray)
                Circle()
                    .foregroundStyle(vm.pressed == true ? .green : .red)
                    .frame(width: 300, height: 300 )
                    .shadow(radius: 10)
                Text(vm.pressed == true ? "Start" : "Stop")
                    .font(.title)
            }
            .onTapGesture {
                vm.setPressedState()
                if vm.getPressedState() == false {
                    vm.setStartPeriod()
                } else {
                    vm.setCurrentPeriod(end: Date())
                }
                vm.getStartPeriod()
            }
        }
        .padding(.horizontal)
    }
}
