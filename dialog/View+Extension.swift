//
//  View+Extension.swift
//  dialog
//
//  Created by 宮本光直 on 2022/02/18.
//

import Foundation
import SwiftUI

extension View {
    public func fullOverFullScreenView<Content>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        self
            .onChange(of: isPresented.wrappedValue) { newValue in
                if newValue {                    
                    let view = content()
                    let viewController = UIHostingController(rootView: view)
                    viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.42)
                    viewController.modalPresentationStyle = .overFullScreen

                    DispatchQueue.main.async {
                        guard let tvc = UIApplication.shared.getTopViewController() else {
                            return
                        }
                        tvc.modalPresentationStyle = .overCurrentContext
                        tvc.present(viewController, animated: true, completion: nil)
                    }
                } else {
                    UIApplication.shared.dismissModalView()
                }
            }
    }
    
    public func halfModalView<Content>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        self
            .onChange(of: isPresented.wrappedValue) { newValue in
                if newValue {
                    let view = content()
                    
                    let view2 = VStack {}
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .overlay(
                            view, alignment: .bottom
                        )
                        .ignoresSafeArea(edges: .bottom)
                    
                    let viewController = UIHostingController(rootView: view2)
                    viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.42)
                    viewController.modalPresentationStyle = .overFullScreen
                    
                    DispatchQueue.main.async {
                        guard let tvc = UIApplication.shared.getTopViewController() else {
                            return
                        }
                        tvc.modalPresentationStyle = .overCurrentContext
                        tvc.present(viewController, animated: true, completion: nil)
                        
                    }
                } else {
                    UIApplication.shared.dismissModalView()
                }
            }
    }
}
