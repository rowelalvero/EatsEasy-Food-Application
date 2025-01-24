import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

import '../store/user.dart';
import '../values/cache.dart';
import '../values/server.dart';
import 'loading.dart';

/*
  * HTTP utility class
  *
  * Manual:
  * https://github.com/flutterchina/dio/blob/master/README.md
  *
  * Upgrade from 3 to 4:
  * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
*/
class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = new CancelToken();

  HttpUtil._internal() {
    // BaseOptions, Options, and RequestOptions can all configure parameters, with priority increasing in that order. Parameters can be overridden based on priority.
    BaseOptions options = new BaseOptions(
      // Base URL, can include sub-paths
      baseUrl: SERVER_API_URL,

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      // Connection timeout to the server in milliseconds.
      connectTimeout: Duration(seconds: 10000),

      // Interval between receiving data streams in milliseconds.
      receiveTimeout: Duration(seconds: 500),

      // HTTP request headers.
      headers: {},

      /// Content-Type of the request. The default value is "application/json; charset=utf-8".
      /// If you want to encode the request data in "application/x-www-form-urlencoded" format,
      /// you can set this option to `Headers.formUrlEncodedContentType`. In that case, [Dio]
      /// will automatically encode the request body.
      contentType: 'application/json; charset=utf-8',

      /// [responseType] indicates the expected format to receive the response data.
      /// Currently, [ResponseType] accepts three types: `JSON`, `STREAM`, and `PLAIN`.
      ///
      /// The default value is `JSON`. When the content-type in the response header is "application/json", dio will automatically convert the response content to a json object.
      /// If you want to receive the response data in binary format, such as downloading a binary file, you can use `STREAM`.
      ///
      /// If you want to receive the response data in text (string) format, use `PLAIN`.
      responseType: ResponseType.json,
    );

    dio = new Dio(options);

    // Cookie management
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // Add interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before the request is sent
        return handler.next(options); // continue
        // If you want to complete the request and return some custom data, you can resolve a Response object with `handler.resolve(response)`.
        // This will terminate the request and the then block will be called with the custom response data.
        //
        // If you want to terminate the request and trigger an error, you can return a `DioError` object, like `handler.reject(error)`,
        // This will terminate the request and trigger an exception, and the upper catchError block will be called.
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
        // If you want to terminate the request and trigger an error, you can reject a `DioError` object, like `handler.reject(error)`,
        // This will terminate the request and trigger an exception, and the upper catchError block will be called.
      },
      onError: (DioError e, handler) {
        // Do something with response error
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); // continue
        // If you want to complete the request and return some custom data, you can resolve a `Response`, like `handler.resolve(response)`.
        // This will terminate the request and the then block will be called with the custom response data.
      },
    ));
  }

  /*
   * Unified error handling
   */

  // Error handling
  void onError(ErrorEntity eInfo) {
    print('error.code -> ' + eInfo.code.toString() + ', error.message -> ' + eInfo.message);
    switch (eInfo.code) {
      case 401:
        UserStore.to.onLogout();
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError('Unknown error');
        break;
    }
  }

  // Error information
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: "Request cancelled");
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: "Connection timeout");
      case DioErrorType.sendTimeout:
        return ErrorEntity(code: -1, message: "Request timeout");
      case DioErrorType.receiveTimeout:
        return ErrorEntity(code: -1, message: "Response timeout");
      case DioErrorType.cancel:
        {
          try {
            int errCode = error.response != null ? error.response!.statusCode! : -1;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                return ErrorEntity(code: errCode, message: "Request syntax error");
              case 401:
                return ErrorEntity(code: errCode, message: "Unauthorized");
              case 403:
                return ErrorEntity(code: errCode, message: "Server refuses to execute");
              case 404:
                return ErrorEntity(code: errCode, message: "Cannot connect to server");
              case 405:
                return ErrorEntity(code: errCode, message: "Request method forbidden");
              case 500:
                return ErrorEntity(code: errCode, message: "Internal server error");
              case 502:
                return ErrorEntity(code: errCode, message: "Invalid request");
              case 503:
                return ErrorEntity(code: errCode, message: "Server is down");
              case 505:
                return ErrorEntity(code: errCode, message: "HTTP protocol not supported");
              default:
                {
                  // return ErrorEntity(code: errCode, message: "Unknown error");
                  return ErrorEntity(
                    code: errCode,
                    message: error.response != null ? error.response!.statusMessage! : "",
                  );
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "Unknown error");
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message!);
        }
    }
  }

  /*
   * Cancel request
   *
   * The same cancel token can be used for multiple requests. When a cancel token is cancelled, all requests using that cancel token will be cancelled.
   * Therefore, the parameter is optional.
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// Read local configuration
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  /// RESTful GET operation
  /// refresh: Whether to pull down to refresh, default is false
  /// noCache: Whether to disable caching, default is true
  /// list: Whether it is a list, default is false
  /// cacheKey: Cache key
  /// cacheDisk: Whether to cache on disk
  Future get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool refresh = false,
        bool noCache = !CACHE_ENABLE,
        bool list = false,
        String cacheKey = '',
        bool cacheDisk = false,
      }) async {
    Options requestOptions = options ?? Options();
    if (requestOptions.extra == null) {
      requestOptions.extra = Map();
    }
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful POST operation
  Future post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful PUT operation
  Future put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful PATCH operation
  Future patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful DELETE operation
  Future delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful POST form submission operation
  Future postForm(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful POST Stream data
  Future postStream(
      String path, {
        dynamic data,
        int dataLength = 0,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

// Exception handling
class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
