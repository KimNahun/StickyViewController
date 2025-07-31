# StickyViewController

`StickyViewController` is a customizable base `UIViewController` subclass that allows up to **three sticky views** to stay pinned to the top of the screen as their corresponding content views scroll out of view.

This is useful for building **scrollable headers, sections, or banners** that stay visible while users scroll through content.

---

## 📹 Sample Video



https://github.com/user-attachments/assets/50688871-dd8a-42ad-b522-8c09201f7e8d



## 📦 Installation (Swift Package Manager)

1. Open your Xcode project.
2. Go to **File > Add Packages**.
3. Paste the URL of this repository:

```bash
https://github.com/KimNahun/StickyViewController.git
```

4. Choose the branch, tag, or revision you want to install.

---

## 🚀 Features

* Up to **3 independently controlled sticky views**
* Simple setup via one method: `configureStickyViews(...)`
* Clean and readable Swift code using UIKit

---

## 📄 Usage

1. **Subclass** `StickyViewController` in your `UIViewController`
2. Override `viewDidLoad()`
3. Call `configureStickyViews(...)` to register content views and corresponding sticky views

```swift
import UIKit
import SnapKit
import Then
import StickyViewController

class PracticeViewController: StickyViewController {

    private let redView = UIView().then { $0.backgroundColor = .red }
    private let greenView = UIView().then { $0.backgroundColor = .green }
    private let blueView = UIView().then { $0.backgroundColor = .blue }

    private let redStickyView = UIView().then { $0.backgroundColor = .red }
    private let greenStickyView = UIView().then { $0.backgroundColor = .green }
    private let blueStickyView = UIView().then { $0.backgroundColor = .blue }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutScrollContent()

        configureStickyViews(
            scrollView: scrollView,
            stickyItems: [
                (redView, redStickyView, 60),
                (greenView, greenStickyView, 100),
                (blueView, blueStickyView, 80)
            ]
        )
    }

    private func layoutScrollContent() {
        [redView, greenView, blueView].forEach {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { $0.height.equalTo(500) }
        }

        redView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }

        greenView.snp.makeConstraints {
            $0.top.equalTo(redView.snp.bottom).offset(300)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }

        blueView.snp.makeConstraints {
            $0.top.equalTo(greenView.snp.bottom).offset(300)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-1000)
        }
    }
}
```

---

## 🧠 How it works

* Each sticky item is defined by a content view inside the scroll view, a corresponding sticky view to pin, and a height.
* As the user scrolls, if a content view scrolls offscreen, its sticky view is shown and pinned.
* Sticky views stack vertically at the top in the order you registered them.

---

## ✏️ Customize Sticky Views

Each sticky view is just a `UIView`, so you can:

* Add labels, buttons, images, etc.
* Animate them as needed
* Match their frame, style, or color to your design

---
