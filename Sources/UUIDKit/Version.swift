import Foundation

extension UUID {
    /// The version number of the UUID.
    ///
    /// This property is `nil` when `variant` is not equal to `.rfc4122`.
    public var version: Version? {
        variant == .rfc4122 ? uuid.6 >> 4 : nil
    }
    
    /// The version number determines which method was used to build a `.rfc4122` UUID.
    ///
    /// [RFC4122](https://tools.ietf.org/html/rfc4122) defines the following versions:
    /// - `1`: Time-based UUID.
    /// - `2`: DCE Security UUID.
    /// - `3`: Name-based UUID using MD5 hashing.
    /// - `4`: Random UUID.
    /// - `5`: Name-based UUID using SHA-1 hashing.
    public typealias Version = UInt8
}
