import 'package:get_it/get_it.dart';

import '../preference/user_preferences.dart';

/// Centralized helper for the "hide spoilers" feature: decides whether an
/// item's overview/synopsis should be hidden from the user based on its
/// type and watched state, respecting the user's "Hide Movie Descriptions"
/// and "Hide Episode Descriptions" preferences.
class SpoilerUtils {
  SpoilerUtils._();

  /// Movie overviews are gated by [UserPreferences.hideMovieOverviews];
  /// season and episode overviews are gated by
  /// [UserPreferences.hideShowOverviews]. Series overviews are never hidden,
  /// since they describe the show's general premise rather than specific
  /// plot events.
  static bool isGatedType(String? type) =>
      type == 'Movie' || type == 'Season' || type == 'Episode';

  /// Returns true when the overview for an item of [type] should be hidden,
  /// given whether it has been fully watched ([isPlayed]). Partially watched
  /// items (started but not finished) are treated the same as unwatched
  /// items and remain hidden.
  static bool shouldHideOverview({
    required String? type,
    required bool isPlayed,
    UserPreferences? prefs,
  }) {
    if (isPlayed) return false;
    final effectivePrefs = prefs ?? GetIt.instance<UserPreferences>();
    switch (type) {
      case 'Movie':
        return effectivePrefs.get(UserPreferences.hideMovieOverviews);
      case 'Season':
      case 'Episode':
        return effectivePrefs.get(UserPreferences.hideShowOverviews);
      default:
        return false;
    }
  }
}
