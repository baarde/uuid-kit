import Swift

struct FakeRandomNumberGenerator: RandomNumberGenerator {
    var values: [UInt64]
    var count = 0
    
    mutating func next() -> UInt64 {
        defer { count += 1 }
        return values[count % values.count]
    }
}
