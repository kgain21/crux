import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_event.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_state.dart';
import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/utils/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ExerciseFormBloc extends Bloc<ExerciseFormEvent, ExerciseFormState> {
  final FirestoreHangboardWorkoutsRepository
      firestoreHangboardWorkoutsRepository;

  ExerciseFormBloc({@required this.firestoreHangboardWorkoutsRepository});

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
          event is HoldChanged);
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
    }).debounceTime(Duration(milliseconds: 300));

    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<ExerciseFormState> mapEventToState(ExerciseFormEvent event) async* {
    if(event is NumberOfHandsChanged) {
      yield* _mapNumberOfHandsChangedToState(event.isTwoHandsSelected);
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
    } else if(event is ExerciseFormSaved) {
      yield* _mapExerciseFormSavedToState();
    }
    //todo: one more for form submission that passes all fields and creates exercise obj^
  }

  Stream<ExerciseFormState> _mapNumberOfHandsChangedToState(
      bool isTwoHandsSelected) async* {
    yield currentState.update(isTwoHandsSelected: isTwoHandsSelected);
  }

  Stream<ExerciseFormState> _mapHoldChangedToState(Hold hold) async* {
    List<FingerConfiguration> availableFingerConfigurations =
        FingerConfiguration.values;
    bool isFingerConfigurationVisible = false;

    if(hold == Hold.POCKET) {
      availableFingerConfigurations = FingerConfiguration.values.sublist(0, 6);
      isFingerConfigurationVisible = true;
    } else if(hold == Hold.OPEN_HAND) {
      availableFingerConfigurations = FingerConfiguration.values.sublist(4);
      isFingerConfigurationVisible = true;
    }

    yield currentState.update(
        holdSelected: hold,
        isFingerConfigurationVisible: isFingerConfigurationVisible,
        availableFingerConfigurations: availableFingerConfigurations);
  }

  Stream<ExerciseFormState> _mapFingerConfigurationChangedToState(
      FingerConfiguration fingerConfiguration) async* {
    yield currentState.update(fingerConfigurationSelected: fingerConfiguration);
  }

  Stream<ExerciseFormState> _mapDepthChangedToState(int depth) async* {
    yield currentState.update(isDepthValid: Validators.isDepthValid(depth));
  }

  Stream<ExerciseFormState> _mapTimeOffChangedToState(int timeOff) async* {
    yield currentState.update(isTimeOffValid: Validators.isValidTime(timeOff));
  }

  Stream<ExerciseFormState> _mapTimeOnChangedToState(int timeOn) async* {
    yield currentState.update(isTimeOnValid: Validators.isValidTime(timeOn));
  }

  Stream<ExerciseFormState> _mapHangsPerSetChangedToState(
      int hangsPerSet) async* {
    yield currentState.update(
        isHangsPerSetValid: Validators.isValidHangsPerSet(hangsPerSet));
  }

  Stream<ExerciseFormState> _mapTimeBetweenSetsChangedToState(
      int timeBetweenSets) async* {
    yield currentState.update(
        isTimeBetweenSetsValid: Validators.isValidTime(timeBetweenSets));
  }

  Stream<ExerciseFormState> _mapNumberOfSetsChangedToState(
      int numberOfSets) async* {
    yield currentState.update(
        isNumberOfSetsValid: Validators.isValidNumberOfSets(numberOfSets));
  }

  Stream<ExerciseFormState> _mapResistanceChangedToState(
      int resistance) async* {
    yield currentState.update(
        isResistanceValid: Validators.isValidResistance(resistance));
  }

  Stream<ExerciseFormState> _mapExerciseFormSavedToState() async* {
    yield currentState.update(
//      showContinueEditingPrompt: true
    );
  }
}
