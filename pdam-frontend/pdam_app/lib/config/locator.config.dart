// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:pdam_app/repositories/authentication_repository.dart' as _i4;
import 'package:pdam_app/repositories/city_repository.dart' as _i5;
import 'package:pdam_app/repositories/events_repository.dart' as _i6;
import 'package:pdam_app/repositories/post_repository.dart' as _i7;
import 'package:pdam_app/repositories/user_repository.dart' as _i8;
import 'package:pdam_app/rest/rest_client.dart' as _i3;
import 'package:pdam_app/services/authentication_service.dart' as _i11;
import 'package:pdam_app/services/city_services.dart' as _i9;
import 'package:pdam_app/services/event_service.dart' as _i10;
import 'package:pdam_app/services/post_service.dart' as _i12;
import 'package:pdam_app/services/user_service.dart' as _i13;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.RestAuthenticatedClient>(_i3.RestAuthenticatedClient());
    gh.singleton<_i3.RestClient>(_i3.RestClient());
    gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());
    gh.singleton<_i5.CityRepository>(_i5.CityRepository());
    gh.singleton<_i6.EventRepository>(_i6.EventRepository());
    gh.singleton<_i7.PostRepository>(_i7.PostRepository());
    gh.singleton<_i8.UserRepository>(_i8.UserRepository());
    gh.singleton<_i9.CityService>(_i9.CityService());
    gh.singleton<_i10.EventService>(_i10.EventService());
    gh.singleton<_i11.JwtAuthenticationService>(
        _i11.JwtAuthenticationService());
    gh.singleton<_i12.PostService>(_i12.PostService());
    gh.singleton<_i13.UserService>(_i13.UserService());
    return this;
  }
}
