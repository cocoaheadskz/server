// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(Linux)
import XCTest

extension ClientMiddlewareTests {
  static var allTests: [(String, (ClientMiddlewareTests) -> () throws -> Void)] = [
   ("testThatMiddlewarePresentInConfig", testThatMiddlewarePresentInConfig),
   ("testThatConfigInitializationFailWithoutToken", testThatConfigInitializationFailWithoutToken),
   ("testThatConfigInitializationFailWithEmptyToken", testThatConfigInitializationFailWithEmptyToken),
   ("testThatFailedConfigInitializationThrowsProperError", testThatFailedConfigInitializationThrowsProperError),
   ("testThatConfigInitializationPassWithAnyNonEmptyToken", testThatConfigInitializationPassWithAnyNonEmptyToken),
   ("testThatTokenIsAssignedFromConfigInitialization", testThatTokenIsAssignedFromConfigInitialization),
   ("testThatResponsePassWithCoincidentToken", testThatResponsePassWithCoincidentToken),
   ("testThatResponseFailWithIncoincidentToken", testThatResponseFailWithIncoincidentToken)
  ]
}
extension EventControllerTests {
  static var allTests: [(String, (EventControllerTests) -> () throws -> Void)] = [
   ("testThatEventHasPlaceRelation", testThatEventHasPlaceRelation),
   ("testThatPlaceOfEventHasCityRelation", testThatPlaceOfEventHasCityRelation),
   ("testThatShowEventReturnsOkStatus", testThatShowEventReturnsOkStatus),
   ("testThatShowEventReturnsJSONWithAllRequiredFields", testThatShowEventReturnsJSONWithAllRequiredFields),
   ("testThatShowEventReturnsJSONWithExpectedFields", testThatShowEventReturnsJSONWithExpectedFields),
   ("testThatGetEventByIdRouteReturnsOkStatus", testThatGetEventByIdRouteReturnsOkStatus),
   ("testThatGetEventByIdRouteFailsForEmptyTable", testThatGetEventByIdRouteFailsForEmptyTable)
  ]
}
extension EventSpeechControllerTests {
  static var allTests: [(String, (EventSpeechControllerTests) -> () throws -> Void)] = [
   ("testThatIndexEventReturnsOkStatus", testThatIndexEventReturnsOkStatus),
   ("testThatIndexEventFailsForEmptyTable", testThatIndexEventFailsForEmptyTable),
   ("testThatGetSpeechesForEventRouteReturnsOkStatus", testThatGetSpeechesForEventRouteReturnsOkStatus)
  ]
}
extension HeartbeatControllerTests {
  static var allTests: [(String, (HeartbeatControllerTests) -> () throws -> Void)] = [
   ("testThatPostSetBeatAnyValue", testThatPostSetBeatAnyValue),
   ("testThatRowCountAfterStoreAlwaysBeEqualOne", testThatRowCountAfterStoreAlwaysBeEqualOne),
   ("testThatShowGet204NoContentForEmptyBeatTable", testThatShowGet204NoContentForEmptyBeatTable),
   ("testThatShowGetCurrentValueIfBeatTableIsNotEmpty", testThatShowGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRoutePostMethodShouldSetAnyIntValue", testThatRoutePostMethodShouldSetAnyIntValue),
   ("testThatRouteGet204NoContentForEmptyBeatTable", testThatRouteGet204NoContentForEmptyBeatTable),
   ("testThatRouteGetCurrentValueIfBeatTableIsNotEmpty", testThatRouteGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRouteHearbeatScenarioIsCorrect", testThatRouteHearbeatScenarioIsCorrect)
  ]
}
extension RouteTests {
  static var allTests: [(String, (RouteTests) -> () throws -> Void)] = [
   ("testThatRequestWithNoClientTokenFails", testThatRequestWithNoClientTokenFails),
   ("testThatAuthorizedRequestPasses", testThatAuthorizedRequestPasses),
   ("testThatRequestWithInvalidClientTokenFails", testThatRequestWithInvalidClientTokenFails),
   ("testThatRequestToHelloReturnsProperData", testThatRequestToHelloReturnsProperData),
   ("testThatRequestToPlainTextReturnsProperData", testThatRequestToPlainTextReturnsProperData)
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(ClientMiddlewareTests.allTests),
  testCase(EventControllerTests.allTests),
  testCase(EventSpeechControllerTests.allTests),
  testCase(HeartbeatControllerTests.allTests),
  testCase(RouteTests.allTests)
])
// swiftlint:enable trailing_comma
#endif
