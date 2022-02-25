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

public struct HalfModalShebekit<PopupContent: View>: ViewModifier {
        
    @Binding var isPresented: Bool
    var view: () -> PopupContent
    
    @State var mitu: CGFloat = -100

    public func body(content: Content) -> some View {
            content
                .onChange(of: isPresented) { newValue in
                if newValue {
                    let view = self.view()
                    let view2 = VStack {}
                        .onTapGesture {
                            isPresented = false
                        }
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .overlay(
                            view
                                .offset(y: self.mitu)
                                .animation(.linear(duration: 3))
                            , alignment: .bottom
                        )

                        .ignoresSafeArea(edges: .bottom)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.mitu = 0
                            }
                        }


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


extension View {
    
    public func syanbeKit<PopupContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            HalfModalShebekit<PopupContent>(
                isPresented: isPresented,
                view: view
            )
        )
    }
}
