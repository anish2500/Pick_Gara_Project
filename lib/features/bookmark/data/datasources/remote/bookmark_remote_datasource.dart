import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import '../bookmark_datasource.dart';

final bookmarkRemoteDatasourceProvider = Provider<BookmarkRemoteDatasource>((
  ref,
) {
  return BookmarkRemoteDatasource(dio: ref.read(apiClientProvider));
});

class BookmarkRemoteDatasource implements IBookmarkRemoteDataSource {
  final Dio _dio;
  BookmarkRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<List<String>> getBookmarkedIds() async {
    final response = await _dio.get(ApiEndpoints.bookmarks);
    final data = response.data;
    final List<dynamic> list = (data is Map && data.containsKey('bookmarks'))
        ? data['bookmarks']
        : [];
    return list.map((p) => p['_id'] as String).toList();
  }

  @override
  Future<bool> toggleBookmark(String placeId) async {
    final response = await _dio.post(ApiEndpoints.toggleBookmark(placeId));
    return response.data['isBookmarked'] as bool;
  }

  @override
  Future<List<Map<String, dynamic>>> getBookmarkedPlaces() async {
    final response = await _dio.get(ApiEndpoints.bookmarks);
    final data = response.data;
    final List<dynamic> list = (data is Map && data.containsKey('bookmarks'))
        ? data['bookmarks']
        : [];
    return list.cast<Map<String, dynamic>>();
  }
}
