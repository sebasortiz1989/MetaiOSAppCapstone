//
//  FetchedPokemon.swift
//  DexCoreData
//
//  Created by Sebastian Ortiz on 05/07/25.
//

import Foundation

struct FetchedPokemon: Decodable {
    let id: Int16
    let name: String
    let types: [String]
    let hp: Int16
    let attack: Int16
    let defense: Int16
    let specialAttack: Int16
    let specialDefense: Int16
    let speed: Int16
    let sprint: URL
    let shinySprint: URL
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: CodingKey {
            case type
            
            enum TypeKeys: CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: CodingKey {
            case baseStat
        }
        
        enum SpriteDictionaryKeys: String, CodingKey {
            case sprite = "frontDefault"
            case shinySprite = "frontShiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int16.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.types = try container.decode([String].self, forKey: .types)
        self.hp = try container.decode(Int16.self, forKey: .hp)
        self.attack = try container.decode(Int16.self, forKey: .attack)
        self.defense = try container.decode(Int16.self, forKey: .defense)
        self.specialAttack = try container.decode(Int16.self, forKey: .specialAttack)
        self.specialDefense = try container.decode(Int16.self, forKey: .specialDefense)
        self.speed = try container.decode(Int16.self, forKey: .speed)
        self.sprint = try container.decode(URL.self, forKey: .sprint)
        self.shinySprint = try container.decode(URL.self, forKey: .shinySprint)
    }
}
