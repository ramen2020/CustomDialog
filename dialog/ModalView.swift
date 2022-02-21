//
//  ModalView.swift
//  dialog
//
//  Created by 宮本光直 on 2022/02/21.
//

import SwiftUI

struct ModalView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Button (action: {
                isPresented = false
            }) {
                Text("close")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .foregroundColor(Color.white)
        .font(.system(size: 18, weight: .semibold))
        .frame(width: 300, height: 500)
        .background(Color.white)
    }
}
