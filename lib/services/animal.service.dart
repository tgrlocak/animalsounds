import 'dart:convert';

import 'package:animound/models/animal.dart';
import 'package:flutter/services.dart';

class AnimalService {

  Future<List<Animal>> getAnimals() async {
    List<Animal> animals = List();

    String data = await rootBundle.loadString('assets/data/animals.json');

    Map<String, dynamic> json = jsonDecode(data);
    
    animals = json['animals'] != null ? (json['animals'] as List)
        ?.map((e) => 
          e == null ? null : Animal.fromJson(e as Map<String, dynamic>))
        ?.toList() : null;

    return animals;
  }
}