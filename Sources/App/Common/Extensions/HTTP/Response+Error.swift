import Vapor
import HTTP

extension Response {
  
  convenience init(status: Status, message: String) throws {
    var json = JSON()
    try json.set("message", message)
    try self.init(status: status, json: json)
  }
}

