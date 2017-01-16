//
//  ProfilePreferenceValues.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//


// MARK: - Preference importance
typealias PreferenceImportance = Int

let PreferenceImportanceNotImportant: PreferenceImportance = 0
let PreferenceImportanceMustNotHave: PreferenceImportance = 1
let PreferenceImportanceImportant: PreferenceImportance = 2
let PreferenceImportanceMustHave: PreferenceImportance = 3
let PreferenceImportances = [
    // PreferenceImportanceMustNotHave,
    PreferenceImportanceMustHave,
    PreferenceImportanceImportant,
    PreferenceImportanceNotImportant,
]

// MARK: - Number precisions
typealias HZNumberPrecision = Int

let HZNumberPrecisionInteger: HZNumberPrecision = 0
let HZNumberPrecisionFloat: HZNumberPrecision = 1

// MARK: - Number representations
typealias HZNumberRepresentation = Int

let HZNumberRepresentationDefault: HZNumberRepresentation = 0
let HZNumberRepresentationCurrency: HZNumberRepresentation = 1
let HZNumberRepresentationDistance: HZNumberRepresentation = 2
let HZNumberRepresentationDriveTime: HZNumberRepresentation = 3
let HZNumberRepresentationSurfaceArea: HZNumberRepresentation = 4
