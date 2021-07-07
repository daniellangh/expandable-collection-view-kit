//
//  ExpandableItems.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

public struct ExpandableItems {
    var items: [ExpandableItem] = []
    
    public init(items: [ExpandableItem]) {
        self.items = items
    }
}

@resultBuilder
public struct ExpandableItemBuilder {
    
    public static func buildBlock(_ item: ExpandableItem) -> ExpandableItem {
        item
    }
    
    public static func buildBlock(_ subitems: ExpandableItem...) -> ExpandableItems {
        .init(items: subitems)
    }
    
    public static func buildBlock(_ items: ExpandableItems) -> ExpandableItems {
        items
    }
}

