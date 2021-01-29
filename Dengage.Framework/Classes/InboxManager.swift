//
//  InboxManager.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 29.01.2021.
//

import Foundation
internal class InboxManager: NSObject {
    
    static let shared = InboxManager()
    var inboxMessages = [DengageMessage]()
    
    func getInboxMessages(request: GetMessagesRequest,
                                        completion: @escaping (Result<[DengageMessage], Error>) -> Void) {
       
        if request.offset == "1" && !inboxMessages.isEmpty{
            completion(.success(inboxMessages))
        }else{
            Dengage.baseService.send(request: request) { result in
                switch result {
                case .success(let response):
                    
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteInboxMessage(with request: DeleteMessagesRequest,
                                          completion: @escaping (Result<Bool, Error>) -> Void) {
        let messages = inboxMessages.filter {$0.id != request.id}
        inboxMessages = messages
        Dengage.baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func markInboxMessageAsRead(with request: MarkAsReadRequest,
                                              completion: @escaping (Result<Bool, Error>) -> Void) {
        markLocalMessageIfNeeded(with: request.id)
        Dengage.baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveInitalInboxMessagesIfNeeded(request:GetMessagesRequest, messages:[DengageMessage]) {
        guard request.offset == "1" else {return}
        inboxMessages = messages
    }

    private func markLocalMessageIfNeeded(with id: String?) {
        guard let messageId = id else { return }
        var message = inboxMessages.first(where: {$0.id == messageId})
        message?.isClicked = true
        inboxMessages = inboxMessages.filter {$0.id != messageId}
        guard let readedMessage = message else { return }
        inboxMessages.append(readedMessage)
    }
}


