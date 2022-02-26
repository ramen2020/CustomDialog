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
                    .navigationBarTitle("Dialog / PopUp")
            }
            .tabItem {
                Image(systemName: "1.circle.fill")
            }
            
            NavigationView {
                SecondPage()
                    .navigationBarTitle("Half Modal")
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
        VStack {
            Button (action: {
                isPresented = true
            }) {
                Text("open")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .background(Color.white)
        .fullOverFullScreenView(isPresented: $isPresented){
            ModalView(isPresented: $isPresented)
        }
    }
}

struct SecondPage: View {
    
    @State var isPresented: Bool = false
    @State var isPresented2: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Button (action: {
                self.isPresented = true
            }) {
                Text("Half Modal")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button (action: {
                self.isPresented2 = true
            }) {
                Text("Dialog")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
        .present(isPresented: $isPresented) {
            HalfModal {
                ItemContent()
            }
        }
        .present(isPresented: $isPresented2) {
            PopUpModal {
                ItemContent()
            }
        }
    }
}

struct PopUpModal<PopupContent: View>: View {
    
    @State var ok: Bool = false
    @Environment(\.modal) var isPresented

    var view: () -> PopupContent

    var body: some View {
        Group {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .all)
            .onReceive(ModalNotification.modalDidPresentedSubject) { _ in
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.2)) {
                        ok = true
                    }
                }
            }
            .onReceive(ModalNotification.modalDidDismissedSubject) { _ in
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.2)) {
                        ok = false
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("タップ")
                isPresented.wrappedValue = false
            }
            .overlay(self.view().offset(y: ok ? 0 : UIScreen.main.bounds.height))
    }
}

struct HalfModal<PopupContent: View>: View {

    @Environment(\.modal) var isPresented
    
    @State var ok: Bool = false
    
    @State var modalHeight: CGFloat = UIScreen.main.bounds.height
    
    var view: () -> PopupContent
    
    public var defaultAnimation: Animation = .interpolatingSpring(
        stiffness: 400.0,
        damping: 25.0,
        initialVelocity: 5.0
    )
    
    func onDragChanged(drag: DragGesture.Value) {
        let translationHeight = drag.translation.height
        let firstPosition = CGFloat(0)

        if translationHeight > firstPosition {
            withAnimation(defaultAnimation) {
                modalHeight = drag.translation.height
            }
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let translationHeight = drag.translation.height

        if 110 > translationHeight {
            withAnimation(defaultAnimation) {
                modalHeight = 0
            }
        } else {
            self.isPresented.wrappedValue = false
        }
    }

    var body: some View {
        VStack {
            HStack{Spacer()}
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    isPresented.wrappedValue = false
                }
            
            VStack {
                self.view()
                    .gesture(
                        DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
                            .onChanged(onDragChanged)
                            .onEnded(onDragEnded)
                    )
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .offset(y: modalHeight)
        }
        .ignoresSafeArea(edges: .all)
        .onReceive(ModalNotification.modalDidPresentedSubject) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.2)) {
                    modalHeight = 0
                }
            }
        }
        .onReceive(ModalNotification.modalDidDismissedSubject) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 0.2)) {
                    modalHeight = UIScreen.main.bounds.height
                }
            }
        }
    }
}

struct ItemContent: View {

    @Environment(\.modal) var isPresented

    var body: some View {
        VStack {
            Button (action: {
                self.isPresented.wrappedValue = false
            }) {
                Text("close")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(height: 300)
        .padding()
        .background(Color.white)
    }
}


import SwiftUI

extension View {
    func present<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        self.overlay(
            Modal(isPresented: isPresented, content: content)
                .frame(width: 0, height: 0)
        )
    }
}

private struct ModalEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var modal: Binding<Bool> {
        get {
            return self[ModalEnvironmentKey.self]
        }
        set {
            return self[ModalEnvironmentKey.self] = newValue
        }
    }
}

struct NotificationConst {
    static let MODAL_PRESENTED: Notification.Name = Notification.Name("modalDidPresented")
    static let MODAL_DISMISSED: Notification.Name = Notification.Name("modalDidDismissed")
}

struct ModalNotification {
    static var modalDidPresentedSubject: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: NotificationConst.MODAL_PRESENTED)
    }

    static func notifyModalDidPresented() {
        NotificationCenter.default
            .post(Notification(name: NotificationConst.MODAL_PRESENTED))
    }

    static var modalDidDismissedSubject: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: NotificationConst.MODAL_DISMISSED)
    }

    static func notifyModalDidDismissed() {
        NotificationCenter.default
            .post(Notification(name: NotificationConst.MODAL_DISMISSED))
    }
}


private struct Modal<Content: View>: UIViewControllerRepresentable {
    typealias Context = UIViewControllerRepresentableContext<Modal>

    @Binding var isPresented: Bool

    let content: () -> Content

    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if self.isPresented {
            let content = self.content()
                .environment(\.modal, self.$isPresented)

            let host = UIHostingController(rootView: content)
            host.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            host.modalPresentationStyle = .overFullScreen

            DispatchQueue.main.async {
                uiViewController.modalPresentationStyle = .overCurrentContext
                uiViewController.present(host, animated: false, completion: {
                    ModalNotification.notifyModalDidPresented()
                })
            }
        } else {
            ModalNotification.notifyModalDidDismissed()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                uiViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
}
