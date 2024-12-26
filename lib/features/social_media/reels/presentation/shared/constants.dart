// Customize
import 'package:flutter/material.dart';

import '../../../../../routes/pages.dart';

const int kPreloadLimit = 5;

// Customize
const int kNextLimit = 500;

// For better UX, latency should be minimum.
// For demo: 2s is taken but something under a second will be better
const int kLatency = 200;

BuildContext currentContext =
    AppPages.router.configuration.navigatorKey.currentContext!;
