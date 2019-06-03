import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';


// TODO: Recommended to not use static method only classes --
// https://dart.dev/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// TODO: Refactor at some point

class StringFormatUtils {
  static String formatDepthAndHold(/*int numberOfHands,*/ double depth,
      String depthMeasurementSystem, String fingerConfiguration, String hold) {
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
        return ' hang at bodyweight';
      } else {
        return ' hang with $resistance$resistanceMeasurementSystem';
      }
    } else {
      if (resistance == null || resistance == 0) {
        return ' hangs at bodyweight';
      }
      return ' hangs with $resistance$resistanceMeasurementSystem';
    }
  }

  /// Formatter for the different [FingerConfiguration]s I have available. This basically just
  /// takes the enum form and makes it a better looking String for the dropdown.
  static String formatFingerConfiguration(
      FingerConfiguration fingerConfiguration) {
    if (fingerConfiguration != null) {
      var fingerConfigurationArray =
          fingerConfiguration.toString().substring(20).split('_');
      String formattedConfiguration = '';
      for (int i = 0; i < fingerConfigurationArray.length; i++) {
        formattedConfiguration = formattedConfiguration +
            '${fingerConfigurationArray[i].substring(0, 1).toUpperCase()}${fingerConfigurationArray[i].substring(1).toLowerCase()}';
        if (!(i == fingerConfigurationArray.length - 1)) {
          formattedConfiguration += '-';
        }
      }
      return formattedConfiguration;
    }
    return '';
  }

  /// Formatter for the different [Holds] I have available. This basically just
  /// takes the enum form and makes it a better looking String for the dropdown.
  static String formatHold(Hold hold) {
    if (hold != null) {
      var holdArray = hold.toString().substring(5).split('_');
      String formattedHold = '';
      for (int i = 0; i < holdArray.length; i++) {
        formattedHold = formattedHold +
            '${holdArray[i].substring(0, 1).toUpperCase()}${holdArray[i].substring(1).toLowerCase()}';
        if (!(i == holdArray.length - 1)) {
          formattedHold += ' ';
        }
      }
      return formattedHold;
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
}
