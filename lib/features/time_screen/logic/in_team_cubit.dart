import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';

class InTeamState {
  final List<InTeamUsers> users;
  InTeamState(this.users);
}

class InTeamCubit extends Cubit<InTeamState> {
  Timer? _timer;

  InTeamCubit() : super(InTeamState([]));

  Future<void> loadUsers() async {
    final response = await Supabase.instance.client.from("in_team").select();
    final users = (response as List)
        .map(
          (e) => InTeamUsers(
            name: e['name'],
            number: e['number'],
            timer: DateTime.parse(e['timer']),
            code: e['code'],
            collage: e['collage'],
            partnershipCode: e['partnership_code'],
            isSub: e['is_sub'],
          ),
        )
        .toList();
    emit(InTeamState(users));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      emit(InTeamState(List.from(state.users)));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> deleteUser(String number) async {
    try {
      print('Deleting user with number: $number');

      // Call the Supabase delete function
      await SupabaseInTeam.deleteUser(number);

      // Remove the user from the local state
      final updatedUsers = List<InTeamUsers>.from(state.users)
        ..removeWhere((user) => user.number == number);

      // Emit the new state without the deleted user
      emit(InTeamState(updatedUsers));

      print('User with number $number deleted successfully from cubit');
    } catch (e) {
      print("Error deleting user in cubit: $e");
      // You can emit an error state here if needed
      rethrow; // Re-throw to handle in the UI
    }
  }

  Future<bool> updateUser({
    required String number,
    String? name,
    String? collage,
    String? code,
    String? partnershipCode,
    bool? isSub,
    DateTime? timer,
  }) async {
    final success = await SupabaseInTeam.updateInTeamUser(
      number: number,
      name: name,
      collage: collage,
      code: code,
      partnershipCode: partnershipCode,
      isSub: isSub,
      timer: timer,
    );
    if (success) {
      // Optionally reload users after update
      await loadUsers();
    }
    return success;
  }
}
