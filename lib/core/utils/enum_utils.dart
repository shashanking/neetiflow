/// Utility class for handling enum conversions and transformations
class EnumUtils {
  /// Converts an enum to its string representation without the enum class name
  /// 
  /// Example: 
  /// ```dart
  /// LeadStatus.hot.toShortString() // returns 'hot'
  /// ```
  static String toShortString<T>(T enumValue) {
    return enumValue.toString().split('.').last;
  }

  /// Converts a string to an enum value of a specific type
  /// 
  /// Example:
  /// ```dart
  /// EnumUtils.fromString(LeadStatus.values, 'hot') // returns LeadStatus.hot
  /// ```
  static T fromString<T>(List<T> enumValues, String value) {
    return enumValues.firstWhere(
      (enumItem) => toShortString(enumItem).toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('No enum value found for $value'),
    );
  }

  /// Safely converts a string to an enum value, returning a default if not found
  /// 
  /// Example:
  /// ```dart
  /// EnumUtils.fromStringOrDefault(LeadStatus.values, 'hot', LeadStatus.cold)
  /// ```
  static T fromStringOrDefault<T>(List<T> enumValues, String? value, T defaultValue) {
    if (value == null) return defaultValue;
    try {
      return fromString(enumValues, value);
    } catch (_) {
      return defaultValue;
    }
  }
}
