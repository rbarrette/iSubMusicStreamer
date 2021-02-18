//
//  DownloadsViewController.swift
//  iSub
//
//  Created by Benjamin Baron on 1/15/21.
//  Copyright © 2021 Ben Baron. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

final class DownloadsViewController: TabmanViewController {
    private enum TabType: Int, CaseIterable {
        case folders = 0, artists, albums, songs, queue
        var name: String {
            switch self {
            case .folders: return "Folders"
            case .artists: return "Artists"
            case .albums:  return "Albums"
            case .songs:   return "Songs"
            case .queue:   return "Download Queue"
            }
        }
    }
    
    private let buttonBar = TMBar.ButtonBar()
    private var controllerCache = [TabType: UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background
        title = "Downloads"
        
        // TODO: implement this - make a function like setupDefaultTableView to add this and the two buttons in viewWillAppear automatically when in the tab bar and the controller is the root of the nav stack (do this for all view controllers to remove the duplicate code)
        // Or maybe just make a superclass that sets up the default table and handles all this
        NotificationCenter.addObserverOnMainThread(self, selector: #selector(addURLRefBackButton), name: UIApplication.didBecomeActiveNotification)

        // Setup ButtonBar
        isScrollEnabled = false
        dataSource = self
        buttonBar.backgroundView.style = .clear
        buttonBar.layout.transitionStyle = .snap
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addURLRefBackButton()
        addBar(buttonBar, dataSource: self, at: .navigationItem(item: navigationItem))
        Flurry.logEvent("DownloadsTab")
    }
    
    deinit {
        NotificationCenter.removeObserverOnMainThread(self)
    }
    
    private func viewController(index: Int) -> UIViewController? {
        guard let type = TabType(rawValue: index) else { return nil }
        
        if let viewController = controllerCache[type] {
            return viewController
        } else {
            let controller: UIViewController
            switch type {
            case .folders: controller = DownloadedFolderArtistsViewController()
            case .artists: controller = DownloadedTagArtistsViewController()
            case .albums:  controller = DownloadedTagAlbumsViewController()
            case .songs:   controller = DownloadedSongsViewController()
            case .queue:   controller = DownloadQueueViewController()
            }
            controllerCache[type] = controller
            return controller
        }
    }
}

extension DownloadsViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return TabType.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewController(index: index)
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: TabType(rawValue: index)?.name ?? "")
    }
}
