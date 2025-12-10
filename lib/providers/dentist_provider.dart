
import 'package:flutter/material.dart';
import '../models/dentist.dart';
import '../services/dentist_service.dart';

class DentistsProvider with ChangeNotifier {
  List<Dentist> _dentists = [];
  List<Dentist> get dentist => _dentists;

  final DentistService _service = DentistService();

  Future<void> fetchAllDentists() async {
    try {
      final data = await _service.fetchAllDentists();
      _dentists = data.map((e) => Dentist.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }


Future<bool> addDentist(
  String name,
  String specialization,
  String experience,
  String qualification,
  String image,
) async {
  try {
    final response = await _service.addDentist(
      name,
      specialization,
      experience,
      qualification,
      image,
    );

    if (response) {
      // refresh list again so UI updates
      await fetchAllDentists();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Add dentist error: $e");
    return false;
  }
}

// ⭐ ADD MORE INFO
Future<bool> addMoreInfo({
  required String dentistId,
  required String bio,
  required String days,
  required String timings,
  required String languages,
  required String awards,
  required String procedures,
  required String website,
}) async {
  print("saving information of dentistId");
  print(timings);
  try {
    return await _service.addMoreInfo(
      dentistId: dentistId,
      bio: bio,
      days: days,
      timings: timings,
      languages: languages,
      awards: awards,
      procedures: procedures,
      website: website,
    );
  } catch (e) {
    print("Error adding more info: $e");
    return false;
  }
}

// remove dentists

Future<bool> removeDentist(String dentistId) async {
  try {
    final success = await _service.deleteDentist(dentistId);

    if (success) {
      _dentists.removeWhere((d) => d.id == dentistId);
      notifyListeners();
    }

    return success;
  } catch (e) {
    print("Delete error: $e");
    return false;
  }
}

// update dentist

Future<bool> updateDentist(
  String id,
  String name,
  String specialization,
  String experience,
  String qualification,
) async {
  try {
    final response = await _service.updateDentist(
      id: id,
      name: name,
      specialization: specialization,
      experience: experience,
      qualification: qualification,
    );

    if (response) {
      await fetchAllDentists(); // refresh list after update
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Update dentist error: $e");
    return false;
  }
}



}
