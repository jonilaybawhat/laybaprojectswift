//
//  RevenueEntry.swift
//  Layba_project
//
//  Created by Mac-LAB on 9/10/26.
//


import Foundation

struct RevenueEntry: Identifiable {
    let id = UUID()
    var tripID: String
    var client: String
    var origin: String
    var destination: String
    var payMethod: PaymentMethod
    var amount: Double
    var notes: String
    var plate: String
    var date: Date = Date()
}