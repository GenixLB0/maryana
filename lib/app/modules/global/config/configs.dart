import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';

const APP_NAME = 'Maryana';
var defaultPrimaryColor = Color(0xFFD4B0FF);

const DOMAIN_URL =
    'https://mariana.genixarea.pro'; // Don't add slash at the end of the url
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';
const LOGO = 'assets/images/logo.svg';
const String cachedRandomQuote = 'CACHED_RANDOM_QUOTE';
const String contentType = 'Content-Type';
const String applicationJson = 'application/json';
const String serverFailure = 'Server Failure';
const String cacheFailure = 'Cache Failure';
const String networkError = 'Network Error';
const String unexpectedError = 'Unexpected Error';
const String unAuthorizedFailure = 'unAuthorizedFailures';

final smallSpacing = 5.w;
