//
//  EntityManager.swift
//  ProjectTaurus
//
//  Created by Nicolas Nascimento on 07/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//

import GameplayKit

protocol EntityManagerDelegate: class {
    func entityManager(_ entityManager: EntityManager, didAdd entity: GKEntity)
    func entityManager(_ entityManager: EntityManager, didRemove entity: GKEntity)
    func entityManager(_ entityManager: EntityManager, didFailToRemove entity: GKEntity)
}

class EntityManager {
    
    // MARK: - Public Properties
    weak var delegate: EntityManagerDelegate?
    
    // MARK: - Private
    private var entities: [GKEntity]
    
    // MARK: - Initialization
    init() {
        self.entities = []
    }
    
    // MARK: - Public
    /// Adds an entity
    func add(entity: GKEntity) {
        // Append entity to list of entities
        self.entities.append(entity)
        
        // Notify the delegate
        self.delegate?.entityManager(self, didAdd: entity)
    }
    func remove(entity: GKEntity) {
        // Assure entity is in array
        guard let index = self.entities.index(of: entity) else {
            self.delegate?.entityManager(self, didFailToRemove: entity)
            return
        }
        // Remove all components from entity before removing it.
        // This allows the components to perform custom behaviour on removal
        let entity = self.entities[index]
        for componentType in entity.components.map({ return type(of: $0) }) {
            entity.removeComponent(ofType: componentType)
        }
        // Remove from list of entities
        self.entities.remove(at: index)
        
        // Notify the delegate
        self.delegate?.entityManager(self, didRemove: entity)
    }
    func removeAllEntities() {
        
        for entity in self.entities {
            self.remove(entity: entity)
        }
    }
}
