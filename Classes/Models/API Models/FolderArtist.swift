//
//  RootFolder.swift
//  iSub
//
//  Created by Benjamin Baron on 12/22/20.
//  Copyright © 2020 Ben Baron. All rights reserved.
//

import Foundation

@objc(ISMSFolderArtist) final class FolderArtist: NSObject, NSCopying, Codable {
    @objc let serverId: Int
    @objc(folderId) let id: Int
    @objc let name: String
    
    @objc(initWithServerId:folderId:name:)
    init(serverId: Int, id: Int, name: String) {
        self.serverId = serverId
        self.id = id
        self.name = name
        super.init()
    }
    
    @objc init(serverId: Int, element: RXMLElement) {
        self.serverId = serverId
        self.id =  element.attribute("id").intXML
        self.name = element.attribute("name").stringXML
        super.init()
    }
    
    @objc func copy(with zone: NSZone? = nil) -> Any {
        FolderArtist(serverId: serverId, id: id, name: name)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? FolderArtist {
            return self === object || (serverId == object.serverId && id == object.id)
        }
        return false
    }
    
    @objc override var description: String {
        "\(super.description): serverId: \(serverId), id: \(id), name: \(name)"
    }
}

@objc extension FolderArtist: TableCellModel {
    var primaryLabelText: String? { return name }
    var secondaryLabelText: String? { return nil }
    var durationLabelText: String? { return nil }
    var coverArtId: String? { return nil }
    var isCached: Bool { return false }
    func download() { SongLoader.downloadAll(folderId: id) }
    func queue() { SongLoader.queueAll(folderId: id) }
}

extension FolderArtist: Artist {
    var artistImageUrl: String? { nil }
    var albumCount: Int { -1 }
}
