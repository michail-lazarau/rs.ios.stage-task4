import Foundation

public extension Int {
    
        var roman: String? {
            var number = self
            var romanString = ""
            
            guard (1...3999).contains(self) else {
                   return nil
               }

            let romanDigits : [String] = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
            let integerDigits : [Int] = [1000,900,500,400,100,90,50,40,10,9,5,4,1]

            var i = 0
            while number > 0 && i < romanDigits.count {
                var div = number/integerDigits[i]
                number = number % integerDigits[i]

                while div != 0 {
                    romanString += romanDigits[i]
                    div -= 1
                }
                i+=1
            }
            return romanString
            
        }
}
