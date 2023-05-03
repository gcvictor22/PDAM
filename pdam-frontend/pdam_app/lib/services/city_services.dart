import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/city.dart';
import 'package:pdam_app/repositories/city_repository.dart';

@Order(2)
@singleton
class CityService {
  final CityRepository _cityRepository = CityRepository();

  Future<List<GetCityDto>> findAll() async {
    List<GetCityDto> response = await _cityRepository.findAll();
    return response;
  }
}
