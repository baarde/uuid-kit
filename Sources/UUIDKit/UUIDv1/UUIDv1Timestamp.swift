import Foundation

extension UUIDv1 {
    public struct Timestamp: Comparable, Hashable, RawRepresentable {
        public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
            rawValue = UInt64(truncatingIfNeeded: source) & ~(.max << 60)
        }
        
        public init?(rawValue: UInt64) {
            guard rawValue & (.max << 60) == 0 else {
                return nil
            }
            self.rawValue = rawValue
        }
        
        public init(secondsSinceEpoch seconds: Int64, nanoseconds: Int) {
            let ticksInNanoseconds = Int64(nanoseconds / .nanosecondsPerUUIDTick)
            let ticksInSeconds = seconds.multipliedReportingOverflow(by: .uuidTicksPerSecond)
            let ticks = ticksInSeconds.partialValue.addingReportingOverflow(ticksInNanoseconds)
            guard !ticksInSeconds.overflow, !ticks.overflow else {
                self = seconds < 0 ? .min : .max
                return
            }
            guard ticks.partialValue >= 0 else {
                self = .min
                return
            }
            guard ticks.partialValue < 1 << 60 else {
                self = .max
                return
            }
            self.rawValue = UInt64(bitPattern: ticks.partialValue)
        }
        
        public init(secondsSince1970: Int64, nanoseconds: Int) {
            let (secondsSinceEpoch, overflow) = secondsSince1970.addingReportingOverflow(.secondsFromUUIDEpochTo1970)
            if overflow {
                self = .max
            } else {
                self.init(secondsSinceEpoch: secondsSinceEpoch, nanoseconds: nanoseconds)
            }
        }
        
        public init(_ date: Date) {
            let quotient = date.timeIntervalSince1970.rounded(.towardZero)
            let remainder = date.timeIntervalSince1970.truncatingRemainder(dividingBy: 1)
            let seconds = Int64(quotient)
            let nanoseconds = Int((remainder * .nanosecondsPerSecond).rounded())
            self.init(secondsSince1970: seconds, nanoseconds: nanoseconds)
        }
        
        public init() {
            var time = timespec()
            clock_gettime(CLOCK_REALTIME, &time)
            self.init(secondsSince1970: Int64(time.tv_sec), nanoseconds: time.tv_nsec)
        }
        
        public let rawValue: UInt64
        
        public var secondSinceEpoch: Int64 {
            Int64(truncatingIfNeeded: rawValue / .uuidTicksPerSecond)
        }
        
        public var secondSince1970: Int64 {
            secondSinceEpoch - .secondsFromUUIDEpochTo1970
        }
        
        public var nanoseconds: Int {
            Int(truncatingIfNeeded: rawValue % .uuidTicksPerSecond)
        }
        
        public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        public static let zero: Timestamp = .min
        public static let min: Timestamp = Timestamp(truncatingIfNeeded: UInt64.min)
        public static let max: Timestamp = Timestamp(truncatingIfNeeded: UInt64.max)
    }
}

extension Date {
    public init(_ timestamp: UUIDv1.Timestamp) {
        let timeInterval = Double(timestamp.secondSince1970) + Double(timestamp.nanoseconds) / .nanosecondsPerSecond
        self.init(timeIntervalSince1970: timeInterval)
    }
}

extension ExpressibleByIntegerLiteral {
    fileprivate static var nanosecondsPerSecond: Self { 1_000_000_000 }
    fileprivate static var nanosecondsPerUUIDTick: Self { 100 }
    fileprivate static var secondsFromUUIDEpochTo1970: Self { 12_219_292_800 }
    fileprivate static var uuidTicksPerSecond: Self { 10_000_000 }
}
