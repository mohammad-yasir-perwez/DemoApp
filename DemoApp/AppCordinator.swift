//
//  AppCordinator.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 28.12.23.
//
import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var baseViewController: UIViewController? { get set }
    func start()
    func start(_ parentViewController: UIViewController?)
}

extension Coordinator {
    func start() {
    }

    func start(_ parentViewController: UIViewController?) {
        guard let baseViewController = baseViewController else {
            return
        }
        if let parentViewController = (parentViewController as? UINavigationController) {
            parentViewController.pushViewController(baseViewController, animated: true)
        } else if let parentViewController = parentViewController {
            parentViewController.present(baseViewController, animated: true)
        } else {
            start()
        }
    }
}


extension Coordinator {
    static func makeCountryListCoordinator(
        webService: WebService
    ) -> CountryListCoordinator {
        return CountryListCoordinator(webService: webService)
    }
}


class AppCoordinator: Coordinator {
    var baseViewController: UIViewController? {
        get {
            currentWindow.rootViewController
        }
        set {
            currentWindow.rootViewController = newValue
        }
    }

    private weak var window: UIWindow?
    private let countryListCoordinator: CountryListCoordinator

    private var currentWindow: UIWindow {
        window ?? UIWindow(frame: .zero)
    }

    func start() {
        currentWindow.rootViewController = countryListCoordinator.baseViewController
        countryListCoordinator.start()
        currentWindow.makeKeyAndVisible()
    }

    init(window: UIWindow?) {
        self.window = window
        countryListCoordinator = AppCoordinator.makeCountryListCoordinator(
            webService: WebService.live
        )
    }
}
