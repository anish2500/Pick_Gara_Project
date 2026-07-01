abstract interface class IBookmarkRemoteDataSource {
  Future<List<String>> getBookmarkedIds();
  Future<bool> toggleBookmark(String placeId);
  Future<List<Map<String, dynamic>>> getBookmarkedPlaces();
}
