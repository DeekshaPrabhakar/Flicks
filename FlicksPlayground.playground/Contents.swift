//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let relDt = "2016-10-13"


var dateFormatter = DateFormatter()
dateFormatter.dateStyle = DateFormatter.Style.medium
dateFormatter.timeStyle = DateFormatter.Style.none
dateFormatter.dateFormat = "yyyy-MM-dd"

var reldate = dateFormatter.date(from: relDt)
dateFormatter.dateFormat = "MMM dd, yyyy"
dateFormatter.string(from: reldate!)



var dateString = dateFormatter.date(from: relDt)





let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: reldate!)

