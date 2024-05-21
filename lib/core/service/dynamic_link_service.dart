import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

abstract class DynamicLinkService {
  Future<void> initDynamicLink(bool isLoggedIn);
  Future<String> createProductLink({
    required int id,
    required String name,
    required String seName,
    required String description,
    String? imageUrl,
  });
}

class DynamicLinkServiceImpl implements DynamicLinkService {
  @override
  Future<void> initDynamicLink(bool isLoggedIn) async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data, true, isLoggedIn);

    FirebaseDynamicLinks.instance.onLink.listen(
      (data) => _handleDeepLink(data, false, isLoggedIn),
      onError: (_) => log('Error dynamic links'),
    );
  }

  Future<void> _handleDeepLink(
    PendingDynamicLinkData? data, [
    bool isInit = false,
    bool isLoggedIn = false,
  ]) async {
    final deepLink = data?.link;
    if (deepLink == null) return;

    if (isInit) await Future.delayed(const Duration(seconds: 1));

    final nextPage = _selectNextPage(deepLink.pathSegments);

    // navigatorKey.currentState?.push(
    //   MaterialPageRoute(builder: (_) => nextPage),
    // );
  }

  Widget _selectNextPage(List<String> pathSegments) {
    String lastSeg = pathSegments.last;
    if (pathSegments.contains('Product')) {
      return Container();
    } else
      throw Exception('Unknown deep link');
  }

  @override
  Future<String> createProductLink({
    required int id,
    required String name,
    required String seName,
    required String description,
    String? imageUrl,
  }) async {
    final picture = imageUrl;
    final url = Uri.parse('https://montagatna.com/Product/$id');
    // final fallbackUrl = Uri.parse('https://montagatna.com/$seName');
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://montagtna.page.link',
      link: url,
      androidParameters: const AndroidParameters(
        // fallbackUrl: fallbackUrl,
        packageName: 'com.devedesign.montagtna',
      ),
      iosParameters: const IOSParameters(
        // fallbackUrl: fallbackUrl,
        appStoreId: '6448727597',
        bundleId: 'com.devedesign.montagtna',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: name,
        // description: description,
        imageUrl: picture == null ? null : Uri.parse(picture),
      ),
    );
    final dynamicLinks = FirebaseDynamicLinks.instance;
    final dynamicUri = await dynamicLinks.buildLink(parameters);
    log(dynamicUri.toString());
    return dynamicUri.toString();
  }
}
