//
//  ContentView.swift
//  dialog
//
//  Created by 宮本光直 on 2022/02/16.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            NavigationView {
                FirstPage()
                    .navigationBarTitle("Half Modal")
            }
            .tabItem {
                Image(systemName: "1.circle.fill")
            }
            
            NavigationView {
                SecondPage()
                    .navigationBarTitle("Dialog / PopUp")
            }
            .tabItem {
                Image(systemName: "2.circle.fill")
            }
        }
        
    }
}

struct FirstPage: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Button (action: {
                self.isPresented = true
            }) {
                Text("Half Modal")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .naoPop(isPresented: $isPresented) {
            NaoHalfModal(onDismiss: {
                //
            }) {
                ItemContent()
            }
        }
    }
}

struct SecondPage: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Button (action: {
                self.isPresented = true
            }) {
                Text("Dialog")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.purple)
                    .cornerRadius(10)
            }

        }
        .naoPop(isPresented: $isPresented) {
            NaoPopUpModal(
                tapOutsideDismiss: false,
                presentedAnimation: .easeOut(duration: 0.2),
                dismissAnimation: .easeIn(duration: 0.2),
                onDismiss: {
                    print("dismiss PopUp !!!")
                }
            ) {
                ItemContent()
            }
        }
    }
}
