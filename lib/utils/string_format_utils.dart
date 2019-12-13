import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';

// TODO: Recommended to not use static method only classes --
// https://dart.dev/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// TODO: Refactor at some point

class StringFormatUtils {
  static String formatDepthAndHold(double depth, String depthMeasurementSystem,
                                   String fingerConfiguration, String hold) {
    if (depth == null || depth == 0) {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return hold;
      }
      return '$fingerConfiguration $hold';
    } else {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return '${formatDecimals(depth)}$depthMeasurementSystem $hold';
      }
      return '${formatDecimals(depth)}$depthMeasurementSystem $fingerConfiguration $hold';
    }
  }

  static formatHangsAndResistance(
      int hangs, int resistance, String resistanceMeasurementSystem) {
    if (hangs == null || hangs == 1) {
      if (resistance == null || resistance == 0) {
        return ' Hang At Bodyweight';
      } else {
        return ' Hang With $resistance$resistanceMeasurementSystem';
      }
    } else {
      if (resistance == null || resistance == 0) {
        return ' Hangs At Bodyweight';
      }
      return ' Hangs With $resistance$resistanceMeasurementSystem';
    }
  }

  /// Formatter for the different [FingerConfiguration] available. Takes the
  /// enum form and makes it a better looking String for the dropdown.
  static String formatFingerConfiguration(
      FingerConfiguration fingerConfiguration) {
    if (fingerConfiguration != null) {
      return fingerConfiguration
          .toString()
          .substring(20)
          .split('_')
          .map((word) {
        return '${word.substring(0, 1).toUpperCase()}'
            '${word.substring(1).toLowerCase()}';
      }).join("-");
    }
    return '';
  }

  /// Formatter for the different [Hold] available. Takes the enum form and
  /// makes it a better looking String for the dropdown.
  static String formatHold(Hold hold) {
    if (hold != null) {
      return hold.toString().substring(5).split('_').map((word) {
        return '${word.substring(0, 1).toUpperCase()}'
            '${word.substring(1).toLowerCase()}';
      }).join(" ");
    }
    return '';
  }

  static String formatDecimals(double decimal) {
    if (decimal == 1.75) return '1 3/4';
    if (decimal == 1.5) return '1 1/2';
    if (decimal == 1.25) return '1 1/4';
    if (decimal == 0.875) return '7/8';
    if (decimal == 0.75) return '3/4';
    if (decimal == 0.625) return '5/8';
    if (decimal == 0.5) return '1/2';
    if (decimal == 0.375) return '3/8';
    if (decimal == 0.25) return '1/4';
    if (decimal == 0.125) return '1/8';
    var decimalString = decimal.toString().split('.');
    if (decimalString[1] == '0')
      return int.tryParse(decimalString[0]).toString();
    return decimal.toString();
  }

  static String createHangboardExerciseTitle(int numberOfHands, double depth,
                                             String fingerConfiguration,
                                             String hold,
                                             String depthMeasurementSystem) {
    String exerciseTitle = '${numberOfHands.toString()} Handed';

    if(depth == null) {
      if(fingerConfiguration == null || fingerConfiguration == '') {
        exerciseTitle += ' $hold';
      } else {
        exerciseTitle += ' $fingerConfiguration $hold';
      }
    } else {
      /// Truncate .0 if possible
      if(depth.floor() == depth) {
        exerciseTitle +=
        ' ${depth
            .truncate()}$depthMeasurementSystem $fingerConfiguration $hold';
      } else {
        exerciseTitle +=
        ' $depth$depthMeasurementSystem $fingerConfiguration $hold';
      }
    }
    return exerciseTitle;
  }
}
