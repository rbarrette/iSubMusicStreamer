//
//  DownloadedTagAlbumsViewController.swift
//  iSub
//
//  Created by Benjamin Baron on 1/15/21.
//  Copyright © 2021 Ben Baron. All rights reserved.
//

import UIKit
import Resolver
import SnapKit
import CocoaLumberjackSwift

// TODO: Make sure to call the getAlbum API for all downloaded songs or they won't show up here
final class DownloadedTagAlbumsViewController: UIViewController {
    @Injected private var store: Store
    @Injected private var settings: Settings
    
    private let tableView = UITableView()
    
    private var downloadedTagAlbums = [DownloadedTagAlbum]()
    
    private func registerForNotifications() {
        // Set notification receiver for when queued songs finish downloading to reload the table
        NotificationCenter.addObserverOnMainThread(self, selector: #selector(reloadTable), name: Notifications.streamHandlerSongDownloaded)
        NotificationCenter.addObserverOnMainThread(self, selector: #selector(reloadTable), name: Notifications.cacheQueueSongDownloaded)
        
        // Set notification receiver for when cached songs are deleted to reload the table
        NotificationCenter.addObserverOnMainThread(self, selector: #selector(reloadTable), name: Notifications.cachedSongDeleted)
        
        // Set notification receiver for when network status changes to reload the table
        NotificationCenter.addObserverOnMainThread(self, selector: #selector(reloadTable), name:NSNotification.Name.reachabilityChanged)
    }
    
    private func unregisterForNotifications() {
        NotificationCenter.removeObserverOnMainThread(self, name: Notifications.streamHandlerSongDownloaded)
        NotificationCenter.removeObserverOnMainThread(self, name: Notifications.cacheQueueSongDownloaded)
        NotificationCenter.removeObserverOnMainThread(self, name: Notifications.cachedSongDeleted)
        NotificationCenter.removeObserverOnMainThread(self, name: NSNotification.Name.reachabilityChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        title = "Downloaded Albums"
        setupDefaultTableView(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForNotifications()
        reloadTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForNotifications()
    }
    
    @objc private func reloadTable() {
        downloadedTagAlbums = store.downloadedTagAlbums(serverId: settings.currentServerId)
        tableView.reloadData()
    }
}

extension DownloadedTagAlbumsViewController: UITableViewConfiguration {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedTagAlbums.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueUniversalCell()
        cell.show(cached: false, number: false, art: true, secondary: false, duration: false)
        cell.update(model: downloadedTagAlbums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // TODO: implement this
        return nil
    }
}
