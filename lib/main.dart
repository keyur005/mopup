import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:mopub_flutter/mopub_rewarded.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MoPubInterstitialAd interstitialAd;
  MoPubRewardedVideoAd videoAd;

  @override
  void initState() {
    super.initState();
    try {
      MoPub.init('b195f8dd8ded45fe847ad89ed1d016da', testMode: true).then((_) {
        _loadRewardedAd();
        _loadInterstitialAd();
      });
    } on PlatformException {}
  }

  void _loadRewardedAd() {
    videoAd = MoPubRewardedVideoAd('920b6145fb1546cf8b5cf2ac34638bb7',
        (result, args) {
      setState(() {
        rewardedResult = '${result.toString()}____$args';
      });
      print('$result');
      if (result == RewardedVideoAdResult.GRANT_REWARD) {
        print('Grant reward: $args');
      }
    }, reloadOnClosed: true);
  }

  void _loadInterstitialAd() {
    interstitialAd = MoPubInterstitialAd(
      '24534e1901884e398f1253216226017e',
      (result, args) {
        print('Interstitial $result');
      },
      reloadOnClosed: true,
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  String rewardedResult = "unknown";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MoPub SDK Sample',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await interstitialAd.load();
                  },
                  child: Text('Load interstitial'),
                ),
                RaisedButton(
                  onPressed: () async {
                    interstitialAd.show();
                  },
                  child: Text('Show interstitial'),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await videoAd.load();
                  },
                  child: Text('Load Video'),
                ),
                RaisedButton(
                  onPressed: () async {
                    var result = await videoAd.isReady();
                    print('Is Ready $result');
                    if (result) {
                      videoAd.show();
                    }
                  },
                  child: Text('Show Video'),
                ),
              ],
            ),
            MoPubBannerAd(
              adUnitId: 'b195f8dd8ded45fe847ad89ed1d016da',
              bannerSize: BannerSize.STANDARD,
              keepAlive: true,
              listener: (result, dynamic) {
                print('$result');
              },
            ),
            Text(rewardedResult)
          ],
        ),
      ),
    );
  }
}
