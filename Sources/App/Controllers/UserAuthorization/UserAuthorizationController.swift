import HTTP
import Vapor
import Fluent

final class UserAuthorizationController {

  private let drop: Droplet
  private let config: Config
  private let fb: FacebookController
  private let vk: VkontakteController
  
  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
    fb = FacebookController(drop: self.drop)
    vk = VkontakteController(drop: self.drop)
  }

  func store(_ req: Request) throws -> ResponseRepresentable {

    guard let token = req.json?["token"]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'token' from request")
    }

    guard let social = req.json?["social"]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'social' from request")
    }

    switch social {
    case Social.Nets.fb:
      return try fb.createOrUpdateUserProfileFromFacebook(use: token)
    case Social.Nets.vk:
      guard let secret = req.json?["secret"]?.string else {
        throw Abort(.badRequest, reason: "Can't get 'secret' from request")
      }
      return try vk.createOrUpdateUserProfileFromVkontake(use: token, secret: secret)
    default:
      throw Abort(.badRequest, reason: "Wrong social id: \(social)")
    }

  }

}

extension UserAuthorizationController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      store: store
    )
  }
}
