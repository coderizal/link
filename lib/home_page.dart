import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:share_plus/share_plus.dart';
import 'package:flutter_share/flutter_share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title1 = 'This is Post 1';
  String title2 = 'This is Post 2';
  String test='';
  TextEditingController c=TextEditingController();

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      // onSuccess: (PendingDynamicLinkData dynamicLink),
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;

        if (deepLink != null) {
          print("ini deep "+deepLink.queryParameters['title'].toString());
      // print("ini deep 2 "+deepLink.toString());
      Navigator.pushNamed(context, '/post',arguments: deepLink.queryParameters['title']);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data!.link;

    if (deepLink != null) {
      print("ini deep 2"+deepLink.queryParameters['title'].toString());
      // print("ini deep 2 "+deepLink.toString());
      Navigator.pushNamed(context, '/post',arguments: deepLink.queryParameters['title']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PostCard(title1),
            SizedBox(height: 30,),
            PostCard(title2),
            TextButton(onPressed: (){
              // share();
              hehe(context,c.text);
              // coba(c.text);
              // waw(context,c.text);
            }, child: Text("Cetak")),
            Text(test),
            TextField(
              
              controller: c,
                    decoration: const InputDecoration(
                      labelText: 'Share text:',
                      hintText: 'Enter some text and/or link to share',
                    ),
                    maxLines: 2,
                    // onChanged: (String value) => setState(() {
                    //   value = value;
                    // }),
                  ),
        
          ],
        ),
      ),
    );
  }

  Future<void> hehe(BuildContext context,String cc) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://rizal.page.link',
        link: Uri.parse('https://www.rizal.in/post?title=$cc'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.link',
        ),
    );

final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
final Uri uri = shortDynamicLink.shortUrl;

 setState(() {
   test=uri.toString();
   c.text=uri.toString();
   waw(context,test);
 });


  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
// final RenderObject? box = context.findRenderObject();
// var title= 'Example share';
//     final urlPrefix = 'https://www.jualbuy.com/home/vendor_profile/';
//     await Share.shareFiles("hehe",
//           text:
//               'Guys, ada toko "$title" di jualBuy, harganya murah - murah banget. Coba Cek deh',
//           sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  // Future<void> coba(String text) async {
  //    final RenderObject? box = context.findRenderObject();
  //   final urlPrefix = 'https://www.jualbuy.com/home/vendor_profile/';
  //   final slug = text
  //       .toLowerCase()
  //       .replaceAllMapped('/ /g', (match) => '-')
  //       .replaceAllMapped('/[^\w-]+/g', (match) => '');

  //     // await Share.shareFiles("imagePaths",
  //     //     text:
  //     //         'Guys, ada toko "$text" di jualBuy, harganya murah - murah banget. Coba Cek deh ',
  //     //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box!.size);

  //     await Share.share("text");
    
  // }
}

Future<void> waw(BuildContext context,String text) async {
  final box = context.findRenderObject() as RenderBox?;
   await Share.share(text,
          subject: "subject",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}

class PostCard extends StatelessWidget {
  final String title;
  PostCard(this.title);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/post', arguments: title);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(title),
        ),
      ),
    );
  }
}

Future<String> createFirstPostLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://rizal.page.link',
      link: Uri.parse('https://www.rizal.in/post?title=$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.link',
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();
}