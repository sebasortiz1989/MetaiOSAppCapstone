//
//  Pokemon.swift
//  DexCoreData
//
//  Created by Sebastian Ortiz on 12/08/25.
//
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Pokemon: Decodable {
    // #Unique<Pokemon>([\.id])
    // var id: Int
    @Attribute(.unique) var id: Int
    
    var name: String
    var types: [String]
    var hp: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
    var spriteURL: URL
    var shinyURL: URL
    var sprite: Data?
    var shiny: Data?
    var favorite: Bool = false
    
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
            case stat
            
            enum StatKeys: CodingKey {
                case name
            }
        }
        
        enum SpriteDictionaryKeys: String, CodingKey {
            case spriteURL = "frontDefault"
            case shinyURL = "frontShiny"
        }
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(
                keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self,
                forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        if (decodedTypes.count > 1) {
            if (decodedTypes[0] == "normal") {
                //                let tempType = decodedTypes[0]
                //                decodedTypes[0] = decodedTypes[1]
                //                decodedTypes[1] = tempType
                decodedTypes.swapAt(0, 1)
            }
        }
        
        types = decodedTypes
        
        var hpTemp: Int = 0;
        var attackTemp: Int = 0;
        var defenseTemp: Int = 0;
        var specialAttackTemp: Int = 0;
        var specialDefenseTemp: Int = 0;
        var speedTemp: Int = 0;
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let stat = try statsDictionaryContainer.decode(Int.self, forKey: .baseStat)
            
            let statContainer = try statsDictionaryContainer.nestedContainer(
                keyedBy: CodingKeys.StatDictionaryKeys.StatKeys.self,
                forKey: .stat)
            
            let name = try statContainer.decode(String.self, forKey: .name)
            
            switch name {
            case "hp":
                hpTemp = stat
            case "attack":
                attackTemp = stat
            case "defense":
                defenseTemp = stat
            case "special-attack":
                specialAttackTemp = stat
            case "special-defense":
                specialDefenseTemp = stat
            case "speed":
                speedTemp = stat
            default:
                break
            }
        }
        
        hp = hpTemp
        attack = attackTemp
        defense = defenseTemp
        specialAttack = specialAttackTemp
        specialDefense = specialDefenseTemp
        speed = speedTemp
        
        let spriteContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteDictionaryKeys.self, forKey: .sprites)
        spriteURL = try spriteContainer.decode(URL.self, forKey: .spriteURL)
        shinyURL = try spriteContainer.decode(URL.self, forKey: .shinyURL)
    }
    
    var spriteImage: Image {
        if let data = sprite, let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(.bulbasaur)
        }
    }
    
    var shinyImage: Image {
        if let data = shiny, let image = UIImage(data: data) {
            return Image(uiImage: image)
        } else {
            return Image(.shinybulbasaur)
        }
    }
    
    var background: ImageResource {
        switch types[0] {
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
                .rockgroundsteelfightingghostdarkpsychic
        case "fire", "dragon":
                .firedragon
        case "bug", "flying":
                .flyingbug
        case "normal", "grass", "electric", "poison", "fairy":
                .normalgrasselectricpoisonfairy
        case "water":
                .water
        case "ice":
                .ice
        default:
                .normalgrasselectricpoisonfairy
        }
    }
    
    var typeColor: Color {
        Color(types[0].capitalized)
    }
    
    var stats: [Stat] {
        [
            Stat(id: 1, name: "HP", value: hp),
            Stat(id: 2, name: "Attack", value: attack),
            Stat(id: 3, name: "Defense", value: defense),
            Stat(id: 4, name: "Special Attack", value: specialAttack),
            Stat(id: 5, name: "Special Defense", value: specialDefense),
            Stat(id: 6, name: "Speed", value: speed)
        ]
    }
    
    var highestStatOld: Stat {
        stats.max { stat1, stat2 in
            stat1.value < stat2.value
        }!
    }
    
    var highestStat: Stat { stats.max { $0.value < $1.value }! }
    
    struct Stat: Identifiable {
        let id:Int
        let name:String
        let value: Int
    }
}
