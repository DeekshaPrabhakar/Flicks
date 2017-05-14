//: Playground - noun: a place where people can play

import UIKit

var str = "Wishing everyone peace and happiness this #Diwali! Stunning photos by @prashvish #shotoniphone https://t.co/EfFaiJ1guy"
//var attrString = NSMutableAttributedString.init(string: str)


// turn string in to NSString
let nsText:NSString = str as NSString
// this needs to be an array of NSString.  String does not work.
let words:[String] = nsText.components(separatedBy: " ")

// you can't set the font size in the storyboard anymore, since it gets overridden here.
let attrs = [
    NSFontAttributeName : UIFont.systemFont(ofSize: 17.0)
]

// you can staple URLs onto attributed strings
let attrString = NSMutableAttributedString.init(string: str, attributes: attrs)

// tag each word if it has a hashtag
for word in words {
    
    // found a word that is prepended by a hashtag!
    // homework for you: implement @mentions here too.
    if word.hasPrefix("#") {
        
        // a range is the character position, followed by how many characters are in the word.
        // we need this because we staple the "href" to this range.
        let matchRange:NSRange = nsText.range(of: word)
        // convert the word from NSString to String
        // this allows us to call "dropFirst" to remove the hashtag
        var stringifiedWord:String = word as String
        
        // drop the hashtag
        stringifiedWord = String(stringifiedWord.characters.dropFirst())
        
        // check to see if the hashtag has numbers.
        // ribl is "#1" shouldn't be considered a hashtag.
        let digits = NSCharacterSet.decimalDigits
        
        if let numbersExist = stringifiedWord.rangeOfCharacter(from: digits) {
            // hashtag contains a number, like "#1"
            // so don't make it clickable
        } else {
            // set a link for when the user clicks on this word.
            // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
            // note:  since it's a URL now, the color is set to the project's tint color
            attrString.addAttribute(NSLinkAttributeName, value: "hash:\(stringifiedWord)", range: matchRange)
        }
        
    }
}

// we're used to textView.text
// but here we use textView.attributedText
// again, this will also wipe out any fonts and colors from the storyboard,
// so remember to re-add them in the attrs dictionary above
attrString

let string = "Wishing everyone peace and happiness this #Diwali! Stunning photos by @prashvish #shotoniphone https://t.co/EfFaiJ1guy"
let types: NSTextCheckingResult.CheckingType = [ .link]
let detector = try? NSDataDetector(types: types.rawValue)
detector?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length)) { (result, flags, _) in
    //print(result)
}

enum HappinessLevel: Int {
    case sad=0
    case happy=5
    case excited=10
}

let s = HappinessLevel.sad
print(s.rawValue)

let calender = NSCalendar.current
//let dateComponent = calender.components([Calendar.Component.weekOfYear], fromDate:NSDate())
let dateComponent = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfYear, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: NSDate() as Date)

print("Week: = \(dateComponent.weekOfYear)")
dateComponent


































let relDt = "2016-10-13"


var dateFormatter = DateFormatter()
//dateFormatter.dateStyle = DateFormatter.Style.medium
//dateFormatter.timeStyle = DateFormatter.Style.none
dateFormatter.dateFormat = "yyyy-MM-dd"

var reldate = dateFormatter.date(from: relDt)
//dateFormatter.dateFormat = "MMM dd, yyyy"
//dateFormatter.string(from: reldate!)

dateFormatter.dateFormat = "MM/dd/yy, h:mm aa";
dateFormatter.string(from: reldate!)

let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: reldate!)

let mTitle = "The peculiar children"
let index = mTitle.index(mTitle.startIndex, offsetBy: 5)
mTitle.substring(to: index)



func shortTimeAgoSinceDate(date: NSDate) -> String {
    //let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date as Date)
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    
    let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfYear, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: earliest, to: latest as Date)
    
    
    if (components.year! >= 1) {
        return "\(components.year)y"
    } else if (components.month! >= 1) {
        return "\(components.month)m"
    } else if (components.weekOfYear! >= 1) {
        return "\(components.weekOfYear)w"
    } else if (components.day! >= 1) {
        return "\(components.day)d"
    } else if (components.hour! >= 1) {
        return "\(components.hour)h"
    } else if (components.minute! >= 1) {
        return "\(components.minute)m"
    } else if (components.second! >= 3) {
        return "\(components.second)s"
    } else {
        return "now"
    }
}
