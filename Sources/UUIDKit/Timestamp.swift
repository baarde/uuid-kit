import Foundation

extension UUID {
    internal struct Timestamp: Comparable {
        public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
            rawValue = UInt64(truncatingIfNeeded: source) & (0x1 << 60 - 1)
        }
        
        public init?(secondsSinceEpoch: Int64, nanoseconds: Int) {
            var value: Int64 = 0
            var overflow = false
            (value, overflow) = secondsSinceEpoch.multipliedReportingOverflow(by: .uuidTicksPerSecond)
            guard !overflow else {
                return nil
            }
            (value, overflow) = value.addingReportingOverflow(Timestamp.uuidTicksInNanoseconds(nanoseconds))
            guard !overflow,
                  let rawValue = UInt64(exactly: value)
            else {
                return nil
            }
            guard rawValue < 0x1 << 60 else {
                return nil
            }
            self.rawValue = rawValue
        }
        
        public init?(secondsSince1970: Int64, nanoseconds: Int) {
            let (secondsSinceEpoch, overflow) = secondsSince1970.addingReportingOverflow(.secondsFromUUIDEpochTo1970)
            guard !overflow else {
                return nil
            }
            self.init(secondsSinceEpoch: secondsSinceEpoch, nanoseconds: nanoseconds)
        }
        
        public init() {
            var time = timespec()
            clock_gettime(CLOCK_REALTIME, &time)
            self.init(secondsSince1970: Int64(time.tv_sec), nanoseconds: time.tv_nsec)!
        }
        
        public let rawValue: UInt64
        
        public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        public static var zero = Timestamp(truncatingIfNeeded: 0)
        
        private static func uuidTicksInNanoseconds(_ nanoseconds: Int) -> Int64 {
            let (quotient, remainder) = Int64(nanoseconds).quotientAndRemainder(dividingBy: .nanosecondsPerUUIDTick)
            if abs(remainder) >= .nanosecondsPerUUIDTick / 2 {
                return quotient + remainder.signum()
            } else {
                return quotient
            }
        }
    }
}

extension ExpressibleByIntegerLiteral {
    fileprivate static var nanosecondsPerUUIDTick: Self { 100 }
    fileprivate static var secondsFromUUIDEpochTo1970: Self { 12_219_292_800 }
    fileprivate static var uuidTicksPerSecond: Self { 10_000_000 }
}
