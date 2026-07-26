import Cocoa

// Disclaimer: you should never rename your friends in real life!

public struct Friend: CustomDebugStringConvertible {
  public var name: String
  
  public var debugDescription: String {
    "Friend '\(name)'"
  }
}

public final class KeyPathDemo {

  var friends = [
    Friend(name: "Aaarka"),
    Friend(name: "Baarka"),
    Friend(name: "Charka"),
    Friend(name: "Daarka"),
  ]

  public func readFriends<T>(_ keyPath: KeyPath<Friend, T>) -> [T] {
    friends.map { $0[keyPath: keyPath] }
  }

  public func writeFriends<T>(_ keyPath: WritableKeyPath<Friend, T>, value: T) {
    for index in friends.indices {
      friends[index][keyPath: keyPath] = value
    }
  }

  public func writeFriendsWithReadonlyKeypath<T>(_ keyPath: KeyPath<Friend, T>, value: T) {
    for index in friends.indices {
      // Cannot assign through subscript: 'keyPath' is a read-only key path
      //      friends[index][keyPath:keyPath] = value
    }
  }

  public func writeReferenceObjectProperty<T>(
    _ keyPath: ReferenceWritableKeyPath<KeyPathDemo, T>,
    value: T
  ) {
    self[keyPath: keyPath] = value
  }

  public func writeReferenceObjectPropertyB<T>(_ keyPath: WritableKeyPath<KeyPathDemo, T>, value: T)
  {
    // Cannot assign through subscript: 'self' is immutable
    //    self[keyPath: keyPath] = value
  }
}

let demo = KeyPathDemo()
print(demo.readFriends(\.name))
print("friends before write:", demo.friends)
demo.writeFriends(\.name, value: "NewName")
print("friends after write:", demo.friends)

demo.writeReferenceObjectProperty(\.friends, value: [
  Friend(name:"Aara"),
  Friend(name:"Bara"),
  Friend(name:"Cara"),
  Friend(name:"Dara"),
])

print("friends after reference write:", demo.friends)
