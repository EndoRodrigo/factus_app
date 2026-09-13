import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/municipality_model.dart';

class ReferenceRemoteDataSource {
  final Dio dio;

  ReferenceRemoteDataSource(this.dio);

  Future<List<MunicipalityModel>> getMunicipalities() async {
    try {
      final response = await dio.get(ApiConstants.municipalities);

      final data = response.data;
      if (data == null) return [];

      // Si por alguna razón recibimos un String, intentamos parsearlo
      final Map<String, dynamic> body;
      if (data is String) {
        body = jsonDecode(data) as Map<String, dynamic>;
      } else if (data is Map) {
        body = Map<String, dynamic>.from(data);
      } else {
        return [];
      }

      final rawData = body['data'];
      if (rawData is! List) {
        return [];
      }

      return rawData
          .whereType<Map<dynamic, dynamic>>()
          .map((item) =>
              MunicipalityModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      debugPrint('Error en getMunicipalities: $e');
      rethrow;
    }
  }
}
