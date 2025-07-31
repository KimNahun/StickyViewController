//
//  StickyViewController.swift
//  StickyViewController
//
//  Created by NahunKim on 7/29/25.
//

import UIKit

/// A base view controller that supports up to 3 sticky views.
/// Sticky views appear at the top when their corresponding content views scroll off screen.
open class StickyViewController: UIViewController, UIScrollViewDelegate {

    /// The main scroll view to contain all content views.
    public let scrollView = UIScrollView()

    /// A list of sticky items, each consisting of a contentView, a stickyView, and a fixed height.
    private var stickyItems: [(contentView: UIView, stickyView: UIView, height: CGFloat)] = []

    /// A container view that holds all sticky views, stacked vertically.
    private let stickyContainerView = UIView()

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupStickyContainer()
        setupStickyContent()
    }

    /// Configures and adds the main scrollView to the view hierarchy.
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.delegate = self
    }

    /// Configures and adds the stickyContainerView above the scrollView content.
    /// Sticky views are placed inside this container.
    private func setupStickyContainer() {
        stickyContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stickyContainerView)

        NSLayoutConstraint.activate([
            stickyContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stickyContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    /// Override this method in subclasses to call `configureStickyViews(...)`
    /// and provide the list of sticky pairs.
    open func setupStickyContent() {
        // To be overridden by subclass
    }

    /// Configures the sticky behavior by registering pairs of scrollable content and their sticky counterparts.
    /// - Parameters:
    ///   - scrollView: The scrollView where contentViews are added.
    ///   - stickyItems: A list of tuples, each containing a contentView, a stickyView, and its sticky height.
    public func configureStickyViews(
        scrollView: UIScrollView,
        stickyItems: [(contentView: UIView, stickyView: UIView, height: CGFloat)]
    ) {
        self.stickyItems = stickyItems

        // Step 1: Add sticky views to the sticky container
        for item in stickyItems {
            let sticky = item.stickyView
            sticky.translatesAutoresizingMaskIntoConstraints = false
            sticky.isHidden = true
            stickyContainerView.addSubview(sticky)
        }

        // Step 2: Layout sticky views vertically stacked
        for (index, item) in stickyItems.enumerated() {
            let sticky = item.stickyView
            var constraints: [NSLayoutConstraint] = [
                sticky.leadingAnchor.constraint(equalTo: stickyContainerView.leadingAnchor),
                sticky.trailingAnchor.constraint(equalTo: stickyContainerView.trailingAnchor),
                sticky.heightAnchor.constraint(equalToConstant: item.height)
            ]

            if index == 0 {
                constraints.append(sticky.topAnchor.constraint(equalTo: stickyContainerView.topAnchor))
            } else {
                let prev = stickyItems[index - 1].stickyView
                constraints.append(sticky.topAnchor.constraint(equalTo: prev.bottomAnchor))
            }

            NSLayoutConstraint.activate(constraints)
        }
    }

    /// UIScrollViewDelegate: Detects scrolling and shows/hides sticky views accordingly.
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var accumulatedHeight: CGFloat = 0

        for item in stickyItems {
            let minY = item.contentView.convert(item.contentView.bounds, to: view).minY
            let shouldShow = minY <= accumulatedHeight + 1

            item.stickyView.isHidden = !shouldShow
            if shouldShow {
                accumulatedHeight += item.height
            }
        }
    }
}
