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
            Text(vm.timeSince)
                .font(.subheadline)
                .onAppear(perform: {
                    vm.refreshPressed()
                    vm.getStartPeriod()
                })
                .onTapGesture {
                    vm.getStartPeriod()
                }
            Spacer()
            VStack {
                ZStack {
                    Circle().foregroundStyle(vm.pressed == true ? .green : .red)
                    Text(vm.pressed == true ? "Start" : "Stop")
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
            Spacer()
        }
    }
}
