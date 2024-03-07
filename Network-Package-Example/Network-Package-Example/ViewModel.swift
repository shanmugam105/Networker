//
//  ViewModel.swift
//  Network-Package-Example
//
//  Created by sparkout on 07/03/24.
//

import Combine
import Networker
import Foundation

final class ViewModel {
    var networkService: NetworkService = .shared
    
    private var anyCancellable: Set<AnyCancellable> = .init()
    
    func getRandomNumber(id: Int, completion: @escaping CompletionValue<String?>) {
        networkService.request(route: Routes.getBlog(id), type: BlogTitle.self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("Error")
            } receiveValue: { blog in
                completion(blog.title)
            }
            .store(in: &anyCancellable)
    }
}
