import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';

// Check if cache exist
apiCacheExist(String keyName) async {
  return await APICacheManager().isAPICacheKeyExist(keyName);
}

// Add cache
apiAddCache(String keyName, String json) async {
  APICacheDBModel model = APICacheDBModel(key: keyName, syncData: json);
  await APICacheManager().addCacheData(model);
}

// Get cache
apiGetCache(String keyName) async {
  return await APICacheManager().getCacheData(keyName);
}

// Delete cache
apiDeleteCache(String keyName) async {
  return await APICacheManager().deleteCache(keyName);
}

// Empty cache
apiEmptyCache() async {
  await APICacheManager().emptyCache();
}
