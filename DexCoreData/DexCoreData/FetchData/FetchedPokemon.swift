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
    let sprite: URL
    let shinySprite: URL
    
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
            case sprite = "frontDefault"
            case shinySprite = "frontShiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int16.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionatyContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionatyContainer.nestedContainer(
                keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self,
                forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        types = decodedTypes
        
        var hpTemp: Int16 = 0;
        var attackTemp: Int16 = 0;
        var defenseTemp: Int16 = 0;
        var specialAttackTemp: Int16 = 0;
        var specialDefenseTemp: Int16 = 0;
        var speedTemp: Int16 = 0;

        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let stat = try statsDictionaryContainer.decode(Int16.self, forKey: .baseStat)

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
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shinySprite = try spriteContainer.decode(URL.self, forKey: .shinySprite)
    }
}
