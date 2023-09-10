//
//  InsightsView.swift
//  Musie
//
//  Created by Arth Patel on 8/28/23.
//

import SwiftUI
import Charts
import MusicKit


enum TimeFrame :  String , Identifiable {
    case day
    case week
    case month
    case year
    var id: Self { self }
    
    var component : Calendar.Component {
        switch self {
        case .day:
            return .hour
        case .week:
            return .day
        case .month:
            return .day
        case .year:
            return .month
            
        }
    }
    
    var text : String {
        switch self {
    case .day:
            return Date.now.day
    case .week:
        return Date.now.week
    case .month:
            return Date.now.month
    case .year:
            return Date.now.year
        
    }
    }
}



struct InsightsView: View {
    @Binding var libraryData : LibraryData
    @State var songAddedList = [Song]()
    
    @State var albumAddedList = [Album]()
    
    @State var artistAddedList = [Artist]()
   
    
    @State var dateComponent : Calendar.Component = .hour
    var currentDay = Calendar.current.startOfDay(for: .now)
    

    var timeframes : [TimeFrame] = [.day,.week,.month,.year]
    @State var selected : TimeFrame = .day
    @State var loaded = false
   
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("TimeFrame", selection: $selected) {
                        ForEach(timeframes) { timeframe in
                            Text(timeframe.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    .task {
                        selected = .day
                    }
                    .onChange(of: selected) { old, new in
                        
                        
                        
                        switch selected {
                        case .day:
                            libraryData.songAddedData =  self.libraryData.songs.filterByTime(date: currentDay, dateComponent: .day)
                            libraryData.artistAddedData = self.libraryData.artists.filterByTime(date: currentDay, dateComponent: .day)
                            
                            libraryData.albumAddedData =  self.libraryData.albums.filterByTime(date: currentDay, dateComponent: .day)
                        case .week:
                            libraryData.songAddedData =  self.libraryData.songs.filterByTime(date: currentDay, dateComponent: .weekOfYear)
                            libraryData.artistAddedData = self.libraryData.artists.filterByTime(date: currentDay, dateComponent: .weekOfYear)
                            
                            libraryData.albumAddedData  =  self.libraryData.albums.filterByTime(date: currentDay, dateComponent: .weekOfYear)
                        case .month:
                            libraryData.songAddedData =  self.libraryData.songs.filterByTime(date: currentDay, dateComponent: .month)
                            libraryData.artistAddedData = self.libraryData.artists.filterByTime(date: currentDay, dateComponent: .month)
                            
                            libraryData.albumAddedData  =  self.libraryData.albums.filterByTime(date: currentDay, dateComponent: .month)
                        case .year:
                            libraryData.songAddedData =  self.libraryData.songs.filterByTime(date: currentDay, dateComponent: .year)
                            libraryData.artistAddedData = self.libraryData.artists.filterByTime(date: currentDay, dateComponent: .year)
                            
                            libraryData.albumAddedData  =  self.libraryData.albums.filterByTime(date: currentDay, dateComponent: .year)
                            
                        }
                        
                        dateComponent = new.component
                    }
                    
                    Group {
                        HStack {
                            Text(selected.text)
                                .font(.system(.title2,weight: .semibold))
                            Spacer()
                            
                        }
                        .foregroundStyle(.secondary)
                        
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            
                            Text("\(libraryData.songAddedData.1) songs added")
                                .font(.system(.title,weight: .semibold))
                            
                            
                            Chart(Array(libraryData.songAddedData.0.keys), id:  \.self) { song in
                                
                                if let value =  libraryData.songAddedData.0[song] {
                                    BarMark(x: .value("Added", song, unit: dateComponent) , y: .value("Occurrance", value), width: 20)
                                        .annotation(position: .top, alignment: .center) {
                                            VStack {
                                                Text("\(value)")
                                            }
                                        }
                                        .clipShape(Capsule())
                                        .foregroundStyle(.blue)
                                    
                                }
                                
                                
                            }
                            
                            
                            .frame(height: 300)
                            
                            
                        }
                        
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(libraryData.albumAddedData.1) albums added")
                                .font(.system(.title,weight: .semibold))
                            Chart(Array(libraryData.albumAddedData.0.keys), id:  \.self) { album in
                                
                                if let value = libraryData.albumAddedData.0[album] {
                                    BarMark(x: .value("Added", album, unit: dateComponent) , y: .value("Occurrance", value), width: 20)
                                        .annotation(position: .top, alignment: .center) {
                                            VStack {
                                                Text("\(value)")
                                            }
                                        }
                                        .clipShape(Capsule())
                                        .foregroundStyle(.blue)
                                }
                                
                                
                            }
                            
                            .frame(height: 300)
                            
                            
                        }
                        
                        
                        Spacer()
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(libraryData.artistAddedData.1) artists added")
                                .font(.system(.title,weight: .semibold))
                            Chart(Array(libraryData.artistAddedData.0.keys), id:  \.self) { artist in
                                
                                if let value = libraryData.artistAddedData.0[artist] {
                                    BarMark(x: .value("Added", artist, unit: dateComponent) , y: .value("Occurrance",value), width: 20)
                                        .annotation(position: .top, alignment: .center) {
                                            VStack {
                                                Text("\(value)")
                                            }
                                        }
                                        .clipShape(Capsule())
                                        .foregroundStyle(.blue)
                                }
                                
                                
                            }
                            
                            
                            
                            .frame(height: 300)
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                }
                .padding()
                
              
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            .navigationTitle("Insights")
        }
    }
}




extension Date {
    
   
    
 
    var month : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    var week: String {
        let sowdateFormatter = DateFormatter()
        sowdateFormatter.dateFormat = "MMMM d"
        
        let eowdateFormatter = DateFormatter()
        eowdateFormatter.dateFormat = "d"
        
        return  sowdateFormatter.string(from: Date.now.startOfWeek) + "-" + eowdateFormatter.string(from: Date.now.endOfWeek) + ", " + Date.now.year
        
    }
    var year : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return  dateFormatter.string(from: self)
    }
    
    var day : String {
        return Calendar.current.startOfDay(for: .now).formatted(date: .complete, time: .omitted)
    }
    
    
    
    var startOfDay : Date {
       
           return Calendar.current.startOfDay(for: self)
    }
    
    
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
           return Calendar.current.date(from: components)!
       }

       var endOfMonth: Date {
           var components = DateComponents()
           components.month = 1
           components.second = -1
           return Calendar.current.date(byAdding: components, to: startOfMonth)!
       }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date {
          Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
      }
      
      var endOfWeek: Date {
          var components = DateComponents()
          components.weekOfYear = 1
          components.second = -1
          return Calendar.current.date(byAdding: components, to: startOfWeek)!
      }
    
    var startOfHour : Date {
       
        Calendar.current.dateComponents([.calendar, .minute, .year, .month, .day, .hour], from: self).date!
    }
  
}

extension MusicItemCollection<Song> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int)  {
        
        var dictionary: [Date : Int] = [:]
       let filteredSongs = self.filter({ song in
             if let songDate = song.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: songDate, toGranularity: dateComponent) == .orderedSame) {
                     
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[songDate.startOfDay] =  (dictionary[songDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[songDate.startOfDay] =  (dictionary[songDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[songDate.startOfMonth] =  (dictionary[songDate.startOfMonth] ?? 0) + 1
                     default:
                        
                         dictionary[songDate.startOfHour] =  (dictionary[songDate.startOfHour] ?? 0) + 1
                     }
                    
                   
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
       
        return (dictionary, filteredSongs.count)
    }
    
}

extension MusicItemCollection<Artist> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int)   {
        
        var dictionary: [Date : Int] = [:]
       let filteredArtists = self.filter({ artist in
             if let artistDate = artist.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: artistDate, toGranularity: dateComponent) == .orderedSame) {
                
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[artistDate.startOfDay] =  (dictionary[artistDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[artistDate.startOfDay] =  (dictionary[artistDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[artistDate.startOfMonth] =  (dictionary[artistDate.startOfMonth] ?? 0) + 1
                     default:
                         dictionary[artistDate.startOfHour] =  (dictionary[artistDate.startOfHour] ?? 0) + 1
                     }
                     
                  
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
        return (dictionary, filteredArtists.count)
    }
    
}

extension MusicItemCollection<Album> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int) {
    
        var dictionary: [Date : Int] = [:]
       let filteredAlbums = self.filter({ album in
             if let albumDate = album.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: albumDate, toGranularity: dateComponent) == .orderedSame) {
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[albumDate.startOfDay] =  (dictionary[albumDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[albumDate.startOfDay] =  (dictionary[albumDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[albumDate.startOfMonth] =  (dictionary[albumDate.startOfMonth] ?? 0) + 1
                     default:
                         dictionary[albumDate.startOfHour] =  (dictionary[albumDate.startOfHour] ?? 0) + 1
                     }
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
        return (dictionary, filteredAlbums.count)
    }
    
}


