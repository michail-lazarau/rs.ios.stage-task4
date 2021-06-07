import Foundation

final class CallStation {
    var userList: [User] = [User]()
    var callList: [Call] = [Call]()
    var currentCall: Call?
}

extension CallStation: Station {
    func users() -> [User] {
        userList
    }

    func add(user: User) {
//        Array(Set<User>(usersList))
        if !userList.contains(user) {
            userList.append(user)
        }
    }

    func remove(user: User) {
        //let index = callList.firstIndex(where: ({$0.incomingUser == user}))
        //callList.remove(at: index!)
        var call = getCallBy(user)
        call?.status = .ended(reason: .error)
        let index = callList.firstIndex(where: ({$0.incomingUser == user}))
        callList.remove(at: index!)
        callList.insert(call.unsafelyUnwrapped, at: index!)
        
        
        let indexUser = userList.firstIndex(where: ({$0 == user}))
        userList.remove(at: indexUser!)
        
        
        
    }

    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(outgoingUser, incomingUser):
            if (!userList.contains(outgoingUser) && !userList.contains(incomingUser)) {return nil}

            let status = !userList.contains(incomingUser) ? CallStatus.ended(reason: .error)
                : getCallBy(incomingUser)?.status == .talk
                ? CallStatus.ended (reason: .userBusy) : CallStatus.calling
            
//            замена calls(user: )[0]
//            let status = getCallBy(incomingUser)?.status == .talk ? CallStatus.ended (reason: .userBusy): CallStatus.calling
            let call = Call(id: .init(), incomingUser: incomingUser, outgoingUser: outgoingUser, status: status)
            callList.append(call)
            
            currentCall = call
            
            if !userList.contains(incomingUser) {
                currentCall?.outgoingUser = nil
                currentCall?.incomingUser = nil
            }
            
            return call.id
            
        case let .answer(incomingUser):
            if !userList.contains(incomingUser) {
                currentCall?.incomingUser = nil
                currentCall?.outgoingUser = nil
                return nil
            }
            let index = callList.firstIndex(where: ({$0.incomingUser == incomingUser}))
//            if index == nil {
//                return nil
//            }
            
            // замена calls(user: )[0]
            var call = getCallBy(incomingUser)
            call?.status = .talk
            
            callList.remove(at: index!)
            callList.insert(call.unsafelyUnwrapped, at: index!)
            
            currentCall = call
            return call?.id

        case let .end(outgoingUser):
            let index = callList.firstIndex(where: ({$0.outgoingUser == outgoingUser || $0.incomingUser == outgoingUser}))
            
            // замена calls(user: )[0]
            var call = getCallBy(outgoingUser)
            
            // ! to avoid error
            call!.status = call?.status == .talk ? .ended(reason: CallEndReason.end) : .ended(reason: CallEndReason.cancel)
            
            currentCall = call
            currentCall?.incomingUser = nil
            currentCall?.outgoingUser = nil
            
            callList.remove(at: index!)
            callList.insert(call.unsafelyUnwrapped, at: index!)
            return call?.id
            
        default:
            return nil
        }
    }

    func calls() -> [Call] {
        callList
    }

    func calls(user: User) -> [Call] {
        return callList.filter { $0.incomingUser == user || $0.outgoingUser == user}
    }

    func call(id: CallID) -> Call? {
        var call = callList.first{ $0.id == id}
                return call
    }

    func currentCall(user: User) -> Call? {
        currentCall?.incomingUser == user || currentCall?.outgoingUser == user ? currentCall : nil
//        let array = callList.filter { $0.incomingUser == user || $0.outgoingUser == user}
//        return array.isEmpty ? nil : array[0]
    }
    
    func getCallBy(_ user: User) -> Call?{
        callList.first { $0.incomingUser == user || $0.outgoingUser == user}
    }
}

//            for (index, call) in callList.enumerated() {
//                if call.outgoingUser == from {
//                    let call = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: from, status: .talk)
//                callList.insert(call, at: index)
//                }
//            }
