import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_event.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_state.dart';
import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/utils/string_format_utils.dart';
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
          event is DepthMeasurementSystemChanged);
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
    } else if(event is ValidExerciseFormSaved) {
      yield* _mapValidExerciseFormSavedToState();
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

  Stream<ExerciseFormState> _mapHoldChangedToState(Holds hold) async* {
    List<FingerConfigurations> availableFingerConfigurations =
        FingerConfigurations.values;
    bool isFingerConfigurationVisible = false;
    bool isDepthVisible = true;

    if(hold == Holds.POCKET) {
      availableFingerConfigurations = FingerConfigurations.values.sublist(0, 7);
      isFingerConfigurationVisible = true;
      isDepthVisible = false;
    } else if(hold == Holds.OPEN_HAND) {
      availableFingerConfigurations = FingerConfigurations.values.sublist(4);
      isFingerConfigurationVisible = true;
    } else if(hold == Holds.SLOPER) {
      isDepthVisible = false;
    } else if(hold == Holds.WIDE_PINCH) {
      isDepthVisible = false;
    } else if(hold == Holds.MEDIUM_PINCH) {
      isDepthVisible = false;
    } else if(hold == Holds.NARROW_PINCH) {
      isDepthVisible = false;
    } else if(hold == Holds.JUGS) {
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
      FingerConfigurations fingerConfiguration) async* {
    yield currentState.update(fingerConfiguration: fingerConfiguration);
  }

  Stream<ExerciseFormState> _mapDepthChangedToState(String depth) async* {
    double depthValue = double.tryParse(depth);
    depthValue = (null != depthValue && depthValue > 0) ? depthValue : null;

    yield currentState.update(
      depth: depthValue,
    );
  }

  Stream<ExerciseFormState> _mapTimeOffChangedToState(String timeOff) async* {
    int timeOffValue = int.tryParse(timeOff);
    timeOffValue =
    (null != timeOffValue && timeOffValue > 0) ? timeOffValue : null;

    yield currentState.update(
      timeOff: timeOffValue,
    );
  }

  Stream<ExerciseFormState> _mapTimeOnChangedToState(String timeOn) async* {
    int timeOnValue = int.tryParse(timeOn);
    timeOnValue = (null != timeOnValue && timeOnValue > 0) ? timeOnValue : null;

    yield currentState.update(
      timeOn: timeOnValue,
    );
  }

  Stream<ExerciseFormState> _mapHangsPerSetChangedToState(
      String hangsPerSet) async* {
    int hangsPerSetValue = int.tryParse(hangsPerSet);

    hangsPerSetValue = (null != hangsPerSetValue && hangsPerSetValue > 0)
        ? hangsPerSetValue
        : null;

    yield currentState.update(hangsPerSet: hangsPerSetValue);
  }

  Stream<ExerciseFormState> _mapTimeBetweenSetsChangedToState(
      String timeBetweenSets) async* {
    int timeBetweenSetsValue = int.tryParse(timeBetweenSets);
    timeBetweenSetsValue =
    (null != timeBetweenSetsValue && timeBetweenSetsValue > 0)
        ? timeBetweenSetsValue
        : null;

    yield currentState.update(
      timeBetweenSets: timeBetweenSetsValue,
    );
  }

  Stream<ExerciseFormState> _mapNumberOfSetsChangedToState(
      String numberOfSets) async* {
    int numberOfSetsValue = int.tryParse(numberOfSets);
    numberOfSetsValue = (null != numberOfSetsValue && numberOfSetsValue > 0)
        ? numberOfSetsValue
        : null;

    yield currentState.update(
      numberOfSets: numberOfSetsValue,
    );
  }

  Stream<ExerciseFormState> _mapResistanceChangedToState(
      String resistance) async* {
    int resistanceValue = int.tryParse(resistance);
    resistanceValue = (null != resistanceValue) ? resistanceValue : null;

    yield currentState.update(
      resistance: resistanceValue,
    );
  }

  Stream<ExerciseFormState> _mapInvalidExerciseFormSavedToState() async* {
    yield currentState.update(autoValidate: true);
  }

  Stream<ExerciseFormState> _mapValidExerciseFormSavedToState() async* {
    var formattedFingerConfiguration =
    StringFormatUtils.formatFingerConfiguration(
        currentState.fingerConfiguration);
    var formattedHold = StringFormatUtils.formatHold(currentState.hold);
    var numberOfHandsSelected = currentState.numberOfHandsSelected;
    var depthMeasurementSystem = currentState.depthMeasurementSystem;
    var depth = currentState.depth;

    firestoreHangboardWorkoutsRepository.addNewExercise(workoutTitle,
        HangboardExercise(
            StringFormatUtils.createHangboardExerciseTitle(
              numberOfHandsSelected,
              depth,
              formattedFingerConfiguration,
              formattedHold,
              depthMeasurementSystem,
            ),
            depthMeasurementSystem,
            currentState.resistanceMeasurementSystem,
            numberOfHandsSelected,
            formattedHold,
            depth,
            currentState.hangsPerSet,
            currentState.numberOfSets,
            currentState.timeOn,
            currentState.timeOff,
            fingerConfiguration: formattedFingerConfiguration,
            breakDuration: currentState.timeBetweenSets,
            resistance: currentState.resistance));
    yield currentState.update(autoValidate: true);
  }
}
