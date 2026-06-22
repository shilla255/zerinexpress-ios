import 'package:flutter_test/flutter_test.dart';
import 'package:zerin_express/util/app_constants.dart';

void main() {
  test('app constants are configured for production', () {
    expect(AppConstants.baseUrl, 'https://zerinexpress.com');
    expect(AppConstants.appName, 'Zerin Express');
    expect(AppConstants.configFromBackend, isTrue);
  });
}
