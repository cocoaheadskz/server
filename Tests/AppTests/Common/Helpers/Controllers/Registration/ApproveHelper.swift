import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class ApproveHelper {
  
  @discardableResult
  static func store(places: [Place] = [], cities: [City] = []) throws -> [App.Event]? {
    
    var cityId = [Identifier]()
    var placeId = [Identifier]()
    var events = [App.Event]()
    let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 10, max: 20))
    let months = 24
    
    if cities.count == 0 {
      for _ in iterations.min...iterations.max {
        let city = City()
        try! city.save()
        cityId.append(city.id!)
      }
    } else {
      cityId =  cities.map { city in city.id! }
    }
    
    if places.count == 0 {
      for _ in iterations.min...iterations.max {
        let place = Place(true, cityId: cityId.randomValue)
        try! place.save()
        placeId.append(place.id!)
      }
    } else {
      placeId = places.map {place in place.id!}
    }
    
    for i in 0...months-1 {
      
      guard
        let date = Calendar.current.date(byAdding: .month, value: -i, to: Date()),
        let date1 = Calendar.current.date(byAdding: .day, value: -6, to: date),
        let date2 = Calendar.current.date(byAdding: .day, value: -12, to: date)
        else {
          return nil
      }
      
      let event1 = App.Event.init(endDate: date1, placeId: placeId.randomValue)
      let event2 = App.Event.init(endDate: date2, placeId: placeId.randomValue)
      
      try! event1.save()
      try! event2.save()
      
      events.append(event1)
      events.append(event2)
    }
    
    return events
  }
  
}