import XCTest
import Testing
@testable import Vapor
@testable import App

class EventControllerTests: TestCase {
  //swiftlint:disable force_try
  var drop: Droplet!
  ///swiftlint:enable force_try
  let eventContoller = EventController()
  
  override func setUp() {
    super.setUp()
    do {
      drop = try Droplet.testable()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
  
  func testThatEventHasPlaceRelation() throws {
    let eventId = try storeEvent()
    let event = try findEvent(by: eventId)
    let place = try event?.place()
    XCTAssertNotNil(place)
  }
  
  func testThatPlaceOfEventHasCityRelation() throws {
    let eventId = try storeEvent()
    let event = try findEvent(by: eventId)
    let place = try event?.place()
    let city = try place?.city()
    XCTAssertNotNil(city)
  }
  
  func testThatIndexEventsFailsForEmptyQueryParameters() throws {
    let req = Request.makeTest(method: .get)
    let res = try eventContoller.index(req).makeResponse()
    XCTAssertEqual(res.status, .badRequest)
  }
  
  func testThatIndexEventsReturnsOkStatusForBeforeQueryKey() throws {
    let query = "before=\(Int.randomValue)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexEventsReturnsOkStatusForAfterQueryKey() throws {
    let query = "after=\(Int.randomValue)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexEventsFailsForIncorrectQueryKey() throws {
    let query = "\(EventHelper.invalidQueryKeyParameter)=\(Int.randomValue)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    XCTAssertEqual(res.status, .badRequest)
  }
  
  func testThatIndexEventsFailsForNonIntQueryValue() throws {
    let query = "before=\(EventHelper.invalidQueryValueParameter)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    XCTAssertEqual(res.status, .badRequest)
  }
  
  func testThatIndexEventsReturnsJSONArray() throws {
    let resAfter = try fetchEvents(after: Int.randomValue)
    let resBefore = try fetchEvents(before: Int.randomValue)
    XCTAssertNotNil(resAfter.json?.array)
    XCTAssertNotNil(resBefore.json?.array)
  }
  
  func testThatIndexEventsReturnsJSONArrayEventsHasAllRequiredFields() throws {
    let timestamp = Int.randomTimestamp
    
    try storeEvent(after: timestamp)
    try storeEvent(before: timestamp)

    let resAfter = try fetchEvents(after: timestamp)
    let resBefore = try fetchEvents(before: timestamp)
    
    let eventJSON1 = resAfter.json?.array?.first
    let eventJSON2 = resBefore.json?.array?.first
    
    assertEventHasRequiredFields(json: eventJSON1)
    assertEventHasRequiredFields(json: eventJSON2)
  }
  
  func testThatIndexEventsReturnsJSONArrayEventsHasAllExpectedFields() throws {
    let timestamp = Int.randomTimestamp
    
    let eventId1 = try storeEvent(after: timestamp)
    let eventId2 = try storeEvent(before: timestamp)
    
    guard
      let event1 = try findEvent(by: eventId1),
      let event2 = try findEvent(by: eventId2)
    else {
      XCTFail()
      return
    }
    
    let resAfter = try fetchEvents(after: timestamp)
    let resBefore = try fetchEvents(before: timestamp)
    
    let eventJSON1 = resAfter.json?.array?.first
    let eventJSON2 = resBefore.json?.array?.first
    
    try assertEventHasExpectedFields(json: eventJSON1, event: event1)
    try assertEventHasExpectedFields(json: eventJSON2, event: event2)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfPastEvents() throws {
    let timestamp = Int.randomTimestamp
    let expectedEventsCount = Int.random(min: 1, max: 20)
    
    for _ in 0..<expectedEventsCount {
      try storeEvent(before: timestamp)
    }
    
    let res = try fetchEvents(before: timestamp)
    let actualEventsCount = res.json?.array?.count
    XCTAssertEqual(actualEventsCount, expectedEventsCount)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfFutureEvents() throws {
    let timestamp = Int.randomTimestamp
    let expectedEventsCount = Int.random(min: 1, max: 20)

    for _ in 0..<expectedEventsCount {
      try storeEvent(after: timestamp)
    }
    
    let res = try fetchEvents(after: timestamp)
    let actualEventsCount = res.json?.array?.count
    XCTAssertEqual(actualEventsCount, expectedEventsCount)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfPastAndFutureEvents() throws {
    let timestamp = Int.randomTimestamp
    let expectedPastEventsCount = Int.random(min: 1, max: 20)
    let expectedFutureEventsCount = Int.random(min: 1, max: 20)

    for _ in 0..<expectedPastEventsCount {
      try storeEvent(before: timestamp)
    }
    for _ in 0..<expectedFutureEventsCount {
      try storeEvent(after: timestamp)
    }
    
    let resBefore = try fetchEvents(before: timestamp)
    let resAfter = try fetchEvents(after: timestamp)

    let actualPastEventsCount = resBefore.json?.array?.count
    let actualFutureEventsCount = resAfter.json?.array?.count
    XCTAssertEqual(actualPastEventsCount, expectedPastEventsCount)
    XCTAssertEqual(actualFutureEventsCount, expectedFutureEventsCount)
  }
  
  // MARK: Endpoint tests
    
  func testThatGetEventsBeforeTimestampRouteReturnsOkStatus() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: "before=\(Int.randomTimestamp)")
      .assertStatus(is: .ok)
  }
  
  func testThatGetEventsAfterTimestampRouteReturnsOkStatus() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: "after=\(Int.randomTimestamp)")
      .assertStatus(is: .ok)
  }
  
  func testThatGetEventsRouteFailsWithWrongQueryParameterKey() throws {
    let query = "\(EventHelper.invalidQueryKeyParameter)=\(Int.randomTimestamp)"
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: query)
      .assertStatus(is: .badRequest)
  }
  
  func testThatGetEventsRouteFailsWithWrongQueryParameterValue() throws {
    let validKey = Bool.randomValue ? "after" : "before"
    let query = "\(validKey)=\(EventHelper.invalidQueryValueParameter)"
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: query)
      .assertStatus(is: .badRequest)
  }
}

extension EventControllerTests {
  
  fileprivate func assertEventHasRequiredFields(json: JSON?) {
    XCTAssertNotNil(json)
    XCTAssertNotNil(json?["id"])
    XCTAssertNotNil(json?["title"])
    XCTAssertNotNil(json?["description"])
    XCTAssertNotNil(json?["photo_url"])
    XCTAssertNotNil(json?["is_registration_open"])
    XCTAssertNotNil(json?["start_date"])
    XCTAssertNotNil(json?["end_date"])
    XCTAssertNotNil(json?["hide"])
    XCTAssertNotNil(json?["place"])
    XCTAssertNotNil(json?["status"])
    XCTAssertNotNil(json?["speakers_photos"])

    let placeJSON = json?["place"]?.makeJSON()
    XCTAssertNotNil(placeJSON?["id"])
    XCTAssertNotNil(placeJSON?["latitude"])
    XCTAssertNotNil(placeJSON?["longitude"])
    XCTAssertNotNil(placeJSON?["title"])
    XCTAssertNotNil(placeJSON?["description"])
    XCTAssertNotNil(placeJSON?["address"])
    XCTAssertNotNil(placeJSON?["city"])
    
    let cityJSON = placeJSON?["city"]?.makeJSON()
    XCTAssertNotNil(cityJSON?["id"])
    XCTAssertNotNil(cityJSON?["city_name"])
  }
  
  fileprivate func assertEventHasExpectedFields(json: JSON?, event: App.Event) throws {
    guard let place = try event.place() else {
      XCTFail()
      return
    }
    guard let city = try place.city() else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(json?["id"]?.int, event.id?.int)
    XCTAssertEqual(json?["title"]?.string, event.title)
    XCTAssertEqual(json?["description"]?.string, event.description)
    XCTAssertEqual(json?["photo_url"]?.string, event.photoUrl)
    XCTAssertEqual(json?["is_registration_open"]?.bool, event.isRegistrationOpen)
    XCTAssertEqual(json?["start_date"]?.int, event.startDate)
    XCTAssertEqual(json?["end_date"]?.int, event.endDate)
    XCTAssertEqual(json?["hide"]?.bool, event.hide)
    XCTAssertEqual(json?["speakers_photos"]?.array?.count, try event.speakersPhotos().count)
    XCTAssertEqual(json?["speakers_photos"]?.array?.first?.string, try event.speakersPhotos().first)

    let placeJSON = json?["place"]?.makeJSON()
    XCTAssertEqual(placeJSON?["id"]?.int, place.id?.int)
    XCTAssertEqual(placeJSON?["latitude"]?.double, place.latitude)
    XCTAssertEqual(placeJSON?["longitude"]?.double, place.longitude)
    XCTAssertEqual(placeJSON?["title"]?.string, place.title)
    XCTAssertEqual(placeJSON?["description"]?.string, place.description)
    XCTAssertEqual(placeJSON?["address"]?.string, place.address)
    
    let cityJSON = placeJSON?["city"]?.makeJSON()
    XCTAssertEqual(cityJSON?["id"]?.int, city.id?.int)
    XCTAssertEqual(cityJSON?["city_name"]?.string, city.cityName)
  }
  
  fileprivate func fetchEvents(before timestamp: Int) throws -> Response {
    let query = "before=\(timestamp)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    return res
  }
  
  fileprivate func fetchEvents(after timestamp: Int) throws -> Response {
    let query = "after=\(timestamp)"
    let req = Request.makeTest(method: .get, query: query)
    let res = try eventContoller.index(req).makeResponse()
    return res
  }
  
  fileprivate func storeEvent() throws -> Identifier? {
    return try EventHelper.storeEvent()
  }
  
  @discardableResult
  fileprivate func storeEvent(after timestamp: Int) throws -> Identifier? {
    return try EventHelper.storeEvent(after: timestamp)
  }
  
  @discardableResult
  fileprivate func storeEvent(before timestamp: Int) throws -> Identifier? {
    return try EventHelper.storeEvent(before: timestamp)
  }
  
  fileprivate func findEvent(by id: Identifier?) throws -> App.Event? {
    return try EventHelper.findEvent(by: id)
  }
  
  fileprivate func storeAndFetchEvent() throws -> App.Event {
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      fatalError()
    }
    return event
  }
}