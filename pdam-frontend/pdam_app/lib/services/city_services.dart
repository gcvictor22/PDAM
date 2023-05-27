import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/city.dart';
import 'package:pdam_app/repositories/city_repository.dart';

import '../config/locator.dart';

@Order(2)
@singleton
class CityService {
  late CityRepository _cityRepository;

  CityService() {
    _cityRepository = getIt<CityRepository>();
  }

  Future<List<GetCityDto>> findAll() async {
    List<GetCityDto> response = await _cityRepository.findAll();
    return response;
  }
}
