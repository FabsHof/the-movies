//
//  WrappedStruct.swift
//  The Movies
//
//  Created by Fabian Hofmann on 04.11.22.
//

import Foundation

///
/// Helper class to wrap structs in order to make them observable.
/// Taken from: https://www.swiftjectivec.com/observing-structs-swiftui/
///
class WrappedStruct<T>: ObservableObject {
    @Published var item: T?
    
    init(withItem item:T?) {
        self.item = item
    }
}
