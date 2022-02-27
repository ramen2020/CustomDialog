#  (Beta version) NaoPop
Library for displaying half-modals and pop-ups (dialogs)<br>
ハーフモーダルやポップアップ(ダイアログ)を表示するためのライブラリ

|Dialog/PopUp|Half Modal|
|--|--|
|![Half Modal](https://user-images.githubusercontent.com/62822536/155831246-830ef5f4-3cc4-4453-8c1d-1057d4b11cad.gif)|![Dialog / PopUp](https://user-images.githubusercontent.com/62822536/155831254-d83df559-8d71-4b2e-930c-0a4c460fd5b1.gif)|

## Overview

SwiftUI had the following problems.
- SwiftUI does not have a standard Dialog/PopUp/Hafl modal component.
- If you create a Dialog/PopUp, you need to show it in the outermost layer to make the tabbar and navigaiton bar transparent.
- If there are many screen transitions or the hierarchy is deep, flag management is difficult.

I created this project to solve that problem.

---

SwiftUIには以下の問題がありました。
- SwiftUIには、標準のDialog / PopUp / ハーフモーダルのコンポーネントがない。
- Dialog / PopUpを作った場合、一番外の階層でそれを出さなければ、tabbarやnavigaiton barが透過されない。
- 画面遷移が多い・階層が深い場合、フラグ管理が大変

その問題を解決するために、このプロジェクトを作成しました。

## Environment
SwiftUI
iOS14~

## How to use
Use naoPop mofifier with NaoPopUpModal or NaoHalfModal.

### NaoPopUpModal

```
.naoPop(isPresented: $isPresented) {
    NaoPopUpModal {
        Text("text")
    }
}

// Set all properties
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

```

### NaoHalfModal
```
.naoPop(isPresented: $isPresented) {
    NaoHalfModal {
        Text("text")
    }
}

// Set all properties
.naoPop(isPresented: $isPresented) {
    NaoHalfModal(
        modalBackground: Color.purple,
        cornerRadius: 30,
        tapOutsideDismiss: false,
        dragDismiss: true,
        presentedAnimation: .easeOut(duration: 0.2),
        dismissAnimation: .easeIn(duration: 0.2),
        onDismiss: {
            print("dismiss modal !!!")
        }
    ) {
        ItemContent()
    }
}
```

## example
```
import SwiftUI

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
    NaoPopUpModal(tapOutsideDismiss: false) {
        ItemContent()
    }
}
```

```
import SwiftUI

struct ItemContent: View {

    @Environment(\.naoModal) var isPresented

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
```

## Properties

### NaoPopUpModal (PopUp)

#### `tapOutsideDismiss`
 
Tap the outer frame to close it.

```
var tapOutsideDismiss: Bool
```

#### `presentedAnimation`
    
Animation when opening modal

```
var presentedAnimation: Animation
```

#### `dismissAnimation`
    
Animation when closing modal

```
var dismissAnimation: Animation
```

#### `onDismiss`

Action when closed modal

```
var onDismiss: (() -> Void)?
```

### NaoHalfModal (Half Modal)
    
#### `modalBackground`

Modal background color

```
var modalBackground: Color
```

#### `cornerRadius`

Round the corners of the modal

```
var cornerRadius: CGFloat
```

#### `dragDismiss`

Can be closed by dragging.

```
var dragDismiss: Bool
```

#### `tapOutsideDismiss`
 
Tap the outer frame to close it.

```
var tapOutsideDismiss: Bool
```

#### `presentedAnimation`
    
Animation when opening modal

```
var presentedAnimation: Animation
```

#### `dismissAnimation`
    
Animation when closing modal

```
var dismissAnimation: Animation
```

#### `onDismiss`

Action when closed modal

```
var onDismiss: (() -> Void)?
```