//
//  NewsCountry.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

enum NewsCountry: String, CaseIterable, NewsFilterProtocol {

    case any = ""
    case ae
    case ar
    case at
    case au
    case be
    case bg
    case br
    case ca
    case ch
    case cn
    case co
    case cu
    case cz
    case de
    case eg
    case fr
    case gb
    case gr
    case hk
    case hu
    case id
    case ie
    case il
    case ind = "in"
    case it
    case jp
    case kr
    case lt
    case lv
    case ma
    case mx
    case my
    case ng
    case nl
    case no
    case nz
    case ph
    case pl
    case pt
    case ro
    case rs
    case sa
    case se
    case sg
    case si
    case sk
    case th
    case tr
    case tw
    case ua
    case us
    case ve
    case za

    var code: String? {
        self == .any ? nil : rawValue
    }

    var name: String {
        self == .any ? "Any" : rawValue.countryName
    }

}
