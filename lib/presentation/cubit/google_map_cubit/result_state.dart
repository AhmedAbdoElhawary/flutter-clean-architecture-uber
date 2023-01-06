import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uber/core/functions/network_exceptions.dart';
import 'package:uber/data/models/place_suggestion/places_suggestions.dart';
import 'package:uber/data/models/place_location_info/place_location_info.dart';

part 'result_state.freezed.dart';

@freezed
class ResultState with _$ResultState {
  const factory ResultState.initial() = Initial;

  const factory ResultState.loading() = Loading;

  const factory ResultState.placesSuggestionsLoaded(PlacesSuggestions placeInfo) =
      PlacesSuggestionsLoaded;

  const factory ResultState.placeLocationLoaded(
      PlaceLocationInfo placeLocationInfo) = PlaceLocationLoaded;

  const factory ResultState.error(NetworkExceptions networkExceptions) = Error;
}
