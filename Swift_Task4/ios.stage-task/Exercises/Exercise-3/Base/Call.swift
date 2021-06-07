import Foundation

typealias CallID = UUID

struct Call: Equatable {
    let id: CallID
    var incomingUser: User?
    var outgoingUser: User?
    var status: CallStatus?
    
    mutating func resetValues(){
        status = nil
        incomingUser = nil
        outgoingUser = nil
    }
    
    var hashValue: Int {
        [id].hashValue
    }
    
    static func ==(leftCall: Call, rightCall: Call) -> Bool{
        return leftCall.id == rightCall.id
    }
}

enum CallEndReason: Equatable {
    case cancel // Call was canceled before the other user answered
    case end // Call ended after successful conversation
    case userBusy // Call ended because the user is busy
    case error
}

enum CallStatus: Equatable {
    case calling
    case talk
    case ended(reason: CallEndReason)
}
