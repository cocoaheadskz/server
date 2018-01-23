import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class Session: Model {
    
  let storage = Storage()
  
  // sourcery: unique = true
  var userId: Identifier
  var token: String
  var actual: Bool
  var timestamp: Int // NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ??? FIX
  
  init(userId: Identifier,
       token: String,
       actual: Bool = true,
       timestamp: Int) {
    self.userId = userId
    self.token = token
    self.actual = actual
    self.timestamp = timestamp
  }

  // sourcery:inline:auto:Session.AutoModelGeneratable
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    token = try row.get(Keys.token)
    actual = try row.get(Keys.actual)
    timestamp = try row.get(Keys.timestamp)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.token, token)
    try row.set(Keys.actual, actual)
    try row.set(Keys.timestamp, timestamp)
    return row
  }
  // sourcery:end
}

extension Session {
  
  static func find(by token: String) throws -> Session? {
    return try Session.makeQuery().filter(Keys.token, token).first()
  }
  
  var user: User? {
    return try? parent(id: userId).get()!
  }
  
}
