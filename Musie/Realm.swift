//
//  Realm.swift
//  Musie
//
//  Created by Arth Patel on 9/8/23.
//

import Foundation
import RealmSwift
import MusicKit


class ListeningData : Object,  Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted  var date : Date
    @Persisted  var playCount : Int
    @Persisted  var minutesListened : Int
    
    convenience init(date: Date, playCount: Int, minutesListened: Int) {
        self.init()
        self.date = date.startOfDay
        self.playCount = playCount
        self.minutesListened = minutesListened
    }
}


class SongListened: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    
    @Persisted var musicId: String
    @Persisted var playsOverTime: List<ListeningData>
    
    
    convenience init(musicId: String, playsOverTime: List<ListeningData>) {
        self.init()
        self.musicId = musicId
        self.playsOverTime = playsOverTime
    }
    
}
