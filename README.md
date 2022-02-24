#  Dialog / PopUp
A project that easily invokes commonly used dialogs.
ダイアログを簡単に呼び出せるようにしたプロジェクト。

|Dialog/PopUp|Half Modal|
|--|--|
|![Dialog / PopUp](https://user-images.githubusercontent.com/62822536/155285120-b390d129-dd2a-49a6-ae66-27469be34c8b.gif)|![Half Modal](https://user-images.githubusercontent.com/62822536/155285140-8d370bf8-2344-41b7-8750-430f826f02bd.gif)|

## Overview

SwiftUI had the following problems.
- SwiftUI does not have a standard Dialog/PopUp component.
- If you create a Dialog/PopUp, you need to show it in the outermost layer to make the tabbar and navigaiton bar transparent.
- In the case of up, it is difficult to manage flags.

I created this project to solve that problem.

---

SwiftUIには以下の問題がありました。
- SwiftUIには、標準のDialog / PopUpのコンポーネントがない。
- Dialog / PopUpを作った場合、一番外の階層でそれを出さなければ、tabbarやnavigaiton barが透過されない。
- ↑の場合、フラグ管理が大変

その問題を解決するために、このプロジェクトを作成しました。

## Environment
SwiftUI
iOS14~

## How to use
Just add a modifier.

```
    .fullOverFullScreenView(isPresented: $isPresented){
        //
    }
```

```
    .halfModalView(isPresented: $isPresented){
        //
    }
```

## example
```
import SwiftUI

struct Page: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {

    VStack {
        Button (action: {
            isPresented = true
        }) {
            Text("open")
                .foregroundColor(Color.white)
                .frame(width: 250, height: 50)
                .background(Color.red)
                .cornerRadius(10)
        }
    }
    .fullOverFullScreenView(isPresented: $isPresented){
        ModalView(isPresented: $isPresented)
    }
}
```

```
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
```
