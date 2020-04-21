import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/blocs/shifts/shifts.dart';
import 'package:shifts_repository/shifts_repository.dart';


class ShiftsBloc extends Bloc<ShiftsEvent, ShiftsState> {
  final ShiftsRepository _shiftsRepository;
  StreamSubscription _shiftsSubscription;

  ShiftsBloc({@required ShiftsRepository shiftsRepository})
    : assert(shiftsRepository != null),
    _shiftsRepository = shiftsRepository;

  @override
  ShiftsState get initialState => ShiftsLoading();

  @override
  Stream<ShiftsState> mapEventToState(ShiftsEvent event) async* {
    if (event is LoadShifts) {
      yield* _mapLoadShiftsToState();
    } else if (event is AddShift) {
      yield* _mapAddShiftToState(event);
    } else if (event is UpdateShift) {
      yield* _mapUpdateShiftToState(event);
    } else if (event is DeleteShift) {
      yield* _mapDeleteShiftToState(event);
    } else if (event is ShiftsUpdated) {
      yield* _mapShiftsUpdateToState(event);
    }
  }

  Stream<ShiftsState> _mapLoadShiftsToState() async* {
    _shiftsSubscription?.cancel();
    _shiftsSubscription = _shiftsRepository.shifts().listen(
      (shifts) => add(ShiftsUpdated(shifts)),
    );
    print(_shiftsSubscription);
  }

  Stream<ShiftsState> _mapAddShiftToState(AddShift event) async* {
    _shiftsRepository.addNewShift(event.shift);
  }

  Stream<ShiftsState> _mapUpdateShiftToState(UpdateShift event) async* {
    _shiftsRepository.updateShift(event.updatedShift);
  }

  Stream<ShiftsState> _mapDeleteShiftToState(DeleteShift event) async* {
    _shiftsRepository.deleteShift(event.shift);
  }

  Stream<ShiftsState> _mapShiftsUpdateToState(ShiftsUpdated event) async* {
    yield ShiftsLoaded(event.shifts);
  }

  @override
  Future<void> close() {
    _shiftsSubscription?.cancel();
    return super.close();
  }
}