import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_event.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_state.dart';
import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:crux/utils/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ExerciseFormBloc extends Bloc<ExerciseFormEvent, ExerciseFormState> {
  final FirestoreHangboardWorkoutsRepository
  firestoreHangboardWorkoutsRepository;
  final String workoutTitle;

  ExerciseFormBloc({@required this.firestoreHangboardWorkoutsRepository,
                     @required this.workoutTitle});

  @override
  ExerciseFormState get initialState => ExerciseFormState.initial();

  @override
  Stream<ExerciseFormState> transformEvents(Stream<ExerciseFormEvent> events,
                                            Stream<
                                                ExerciseFormState> Function(ExerciseFormEvent event) next) {
    final observableStream = events as Observable<ExerciseFormEvent>;

    /// Non text box fields don't need debounce
    final nonDebounceStream = observableStream.where((event) {
      return (event is NumberOfHandsChanged ||
          event is HoldChanged ||
          event is FingerConfigurationChanged ||
          event is HoldChanged ||
          event is InvalidExerciseFormSaved ||
          event is ValidExerciseFormSaved ||
          event is ResistanceMeasurementSystemChanged ||
          event is DepthMeasurementSystemChanged ||
          event is ExerciseFormFlagsReset);
    });

    /// Debounce any field with a text box to delay validation
    final debounceStream = observableStream.where((event) {
      return (event is DepthChanged ||
          event is TimeOffChanged ||
          event is TimeOnChanged ||
          event is HangsPerSetChanged ||
          event is TimeBetweenSetsChanged ||
          event is NumberOfSetsChanged ||
          event is ResistanceChanged);
    }).debounceTime(Duration(milliseconds: 500));

    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<ExerciseFormState> mapEventToState(ExerciseFormEvent event) async* {
    if(event is ResistanceMeasurementSystemChanged) {
      yield* _mapResistanceMeasurementSystemChangedToState(
          event.resistanceMeasurementSystem);
    } else if(event is DepthMeasurementSystemChanged) {
      yield* _mapDepthMeasurementSystemChangedToState(
          event.depthMeasurementSystem);
    } else if(event is NumberOfHandsChanged) {
      yield* _mapNumberOfHandsChangedToState(event.numberOfHandsSelected);
    } else if(event is HoldChanged) {
      yield* _mapHoldChangedToState(event.hold);
    } else if(event is FingerConfigurationChanged) {
      yield* _mapFingerConfigurationChangedToState(event.fingerConfiguration);
    } else if(event is DepthChanged) {
      yield* _mapDepthChangedToState(event.depth);
    } else if(event is TimeOffChanged) {
      yield* _mapTimeOffChangedToState(event.timeOff);
    } else if(event is TimeOnChanged) {
      yield* _mapTimeOnChangedToState(event.timeOn);
    } else if(event is HangsPerSetChanged) {
      yield* _mapHangsPerSetChangedToState(event.hangsPerSet);
    } else if(event is TimeBetweenSetsChanged) {
      yield* _mapTimeBetweenSetsChangedToState(event.timeBetweenSets);
    } else if(event is NumberOfSetsChanged) {
      yield* _mapNumberOfSetsChangedToState(event.numberOfSets);
    } else if(event is ResistanceChanged) {
      yield* _mapResistanceChangedToState(event.resistance);
    } else if(event is InvalidExerciseFormSaved) {
      yield* _mapInvalidExerciseFormSavedToState();
    } else if(event is ExerciseFormFlagsReset) {
      yield* _mapExerciseFormFlagsResetToState();
    } else if(event is ValidExerciseFormSaved) {
      yield* _mapValidExerciseFormSavedToState(event);
    }
  }

  Stream<ExerciseFormState> _mapResistanceMeasurementSystemChangedToState(
      String resistanceMeasurementSystem) async* {
    yield currentState.update(
        resistanceMeasurementSystem: resistanceMeasurementSystem);
  }

  Stream<ExerciseFormState> _mapDepthMeasurementSystemChangedToState(
      String depthMeasurementSystem) async* {
    yield currentState.update(depthMeasurementSystem: depthMeasurementSystem);
  }

  Stream<ExerciseFormState> _mapNumberOfHandsChangedToState(
      int numberOfHandsSelected) async* {
    yield currentState.update(numberOfHandsSelected: numberOfHandsSelected);
  }

  Stream<ExerciseFormState> _mapHoldChangedToState(Hold hold) async* {
    List<FingerConfiguration> availableFingerConfigurations =
        FingerConfiguration.values;
    bool isFingerConfigurationVisible = false;
    bool isDepthVisible = true;

    if(hold == Hold.POCKET) {
      availableFingerConfigurations = FingerConfiguration.values.sublist(0, 7);
      isFingerConfigurationVisible = true;
      isDepthVisible = false;
    } else if(hold == Hold.OPEN_HAND) {
      availableFingerConfigurations = FingerConfiguration.values.sublist(4);
      isFingerConfigurationVisible = true;
    } else if(hold == Hold.SLOPER) {
      isDepthVisible = false;
    } else if(hold == Hold.WIDE_PINCH) {
      isDepthVisible = false;
    } else if(hold == Hold.MEDIUM_PINCH) {
      isDepthVisible = false;
    } else if(hold == Hold.NARROW_PINCH) {
      isDepthVisible = false;
    } else if(hold == Hold.JUGS) {
      isDepthVisible = false;
    }

    yield currentState.update(
      hold: hold,
      isFingerConfigurationVisible: isFingerConfigurationVisible,
      availableFingerConfigurations: availableFingerConfigurations,
      isDepthVisible: isDepthVisible,
    );
  }

  Stream<ExerciseFormState> _mapFingerConfigurationChangedToState(
      FingerConfiguration fingerConfiguration) async* {
    yield currentState.update(fingerConfiguration: fingerConfiguration);
  }

  Stream<ExerciseFormState> _mapDepthChangedToState(String depth) async* {
    yield currentState.update(isDepthValid: Validators.validateDepth(depth));
  }

  Stream<ExerciseFormState> _mapTimeOffChangedToState(String timeOff) async* {
    yield currentState.update(isTimeOffValid: Validators.validateTime(timeOff));
  }

  Stream<ExerciseFormState> _mapTimeOnChangedToState(String timeOn) async* {
    yield currentState.update(isTimeOnValid: Validators.validateTime(timeOn));
  }

  Stream<ExerciseFormState> _mapHangsPerSetChangedToState(
      String hangsPerSet) async* {
    yield currentState.update(
        isHangsPerSetValid: Validators.validateHangsPerSet(hangsPerSet));
  }

  Stream<ExerciseFormState> _mapTimeBetweenSetsChangedToState(
      String timeBetweenSets) async* {
    yield currentState.update(
        isTimeBetweenSetsValid: Validators.validateTime(timeBetweenSets));
  }

  Stream<ExerciseFormState> _mapNumberOfSetsChangedToState(
      String numberOfSets) async* {
    yield currentState.update(
        isNumberOfSetsValid: Validators.validateNumberOfSets(numberOfSets));
  }

  Stream<ExerciseFormState> _mapResistanceChangedToState(
      String resistance) async* {
    yield currentState.update(
        isResistanceValid: Validators.validateResistance(resistance));
  }

  /// Don't autoValidate form until form is submitted incorrectly
  Stream<ExerciseFormState> _mapInvalidExerciseFormSavedToState() async* {
    yield currentState.update(autoValidate: true);
  }

  Stream<ExerciseFormState> _mapValidExerciseFormSavedToState(
      ValidExerciseFormSaved event) async* {
    /// Depth can be left over from a previous exercise submission - remove it
    /// if the depth field was made not visible in case a value is still there.
    var depth = double.tryParse(event.depth);
    if (!currentState.isDepthVisible) {
      depth = null;
    }

    /// FingerConfiguration can be left over from a previous exercise submission
    /// - remove it if the fingerConfiguration field was made not visible in
    /// case a value is still there.
    var formattedFingerConfiguration =
        StringFormatUtils.formatFingerConfiguration(event.fingerConfiguration);
    if (!currentState.isFingerConfigurationVisible) {
      formattedFingerConfiguration = "";
    }

    var timeBetweenSets = int.tryParse(event.timeBetweenSets);
    if (!currentState.isTimeBetweenSetsVisible) {
      timeBetweenSets = null;
    }

    var formattedHold = StringFormatUtils.formatHold(event.hold);
    var numberOfHandsSelected = event.numberOfHandsSelected;
    var depthMeasurementSystem = event.depthMeasurementSystem;

    var hangboardExerciseTitle = StringFormatUtils.createHangboardExerciseTitle(
      numberOfHandsSelected,
      depth,
      formattedFingerConfiguration,
      formattedHold,
      depthMeasurementSystem,
    );

    var hangboardExercise = HangboardExercise(
      hangboardExerciseTitle,
      depthMeasurementSystem,
      event.resistanceMeasurementSystem,
      numberOfHandsSelected,
      formattedHold,
      depth,
      int.tryParse(event.hangsPerSet),
      int.tryParse(event.numberOfSets),
      int.tryParse(event.timeOn),
      int.tryParse(event.timeOff),
      fingerConfiguration: formattedFingerConfiguration,
      breakDuration: timeBetweenSets,
      resistance: int.tryParse(event.resistance),
    );

    bool isFailure = false;
    bool isSuccess = await firestoreHangboardWorkoutsRepository
        .addExerciseToWorkout(workoutTitle, hangboardExercise)
        .catchError((error) {
      print(error);
      isFailure = true;
    });

    yield currentState.update(
        exerciseTitle: hangboardExerciseTitle,
        isSuccess: isSuccess,
        isFailure: isFailure,
        isDuplicate: !isSuccess && !isFailure);
  }

  Stream<ExerciseFormState> _mapExerciseFormFlagsResetToState() async* {
    yield currentState.update(
      isSuccess: false,
      isFailure: false,
      isDuplicate: false,
    );
  }
}
