# Change Log

## 1.4.0
- Compatible with Swift 5.0

## 1.3.0
- Compatible with Swift 4.0
- `CaptureGroup` conforms to `MatchProtocol`
- `matched` on `CaptureGroup` became Non-optional. Empty string is returned if conversion is failed.
- `range` on `Match` became Optional. `nil` is returned if conversion from NSRange is failed.
- `String.split` returns `[Substring]` instead of `[String]`
- Performance improved

## 1.2.1
- Compatible with Swift 3.2

## 1.2.0
- Named capture group
- `Regex.Options` is not type alias of `NSRegularExpession.Options` any longer.
- Add `Regex.Options.namedCaputreGroups`
- `Match.Options` is not type alias of `NSRegularExpession.MatchingOptions` any longer.
- Add `Match.Options.reportProgress` & `Match.Options.reportCompletion`
- 
## 1.1.1
- Compatible with Swift 3.2
- Swift Package Manager supported

## 1.1.0
- `Regex.init`` changed - one accepts string literal, the other one accepts string may throwing error.
- macOS, tvOS, watchOS supported.

## 1.0.0
- LLRegex initial version
