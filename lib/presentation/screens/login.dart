import "package:universal_html/html.dart" as html;
import 'dart:developer';
import 'package:bungie_api/helpers/bungie_net_token.dart';
import 'package:quria/data/services/bungie_api/account.service.dart';
import 'package:quria/presentation/var/routes.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_io/io.dart';

import 'package:bungie_api/helpers/oauth.dart';
import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:bungie_api/models/user_membership_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quria/data/services/auth.service.dart';
import 'package:quria/data/services/bungie_api/bungie_api.service.dart';
import 'package:quria/data/services/bungie_api/profile.service.dart';
import 'package:quria/presentation/components/misc/button.dart';

typedef LoginCallback = void Function(String code);
typedef SkipCallback = void Function();

class LoginWidget extends StatefulWidget {
  final String title = "Login";
  final BungieApiService api = BungieApiService();
  final AuthService auth = AuthService();
  final AccountService account = AccountService();
  final ProfileService profile = ProfileService();
  final LoginCallback? onLogin;
  final SkipCallback? onSkip;
  final bool forceReauth;

  LoginWidget({Key? key, this.onLogin, this.onSkip, this.forceReauth = true})
      : super(key: key);

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  void initState() {
    super.initState();
    widget.auth.getToken().then((value) => {
          if (value != null) {checkMembership()}
        });

    getInitialUri().then((value) {
      if (!value.toString().contains('code=')) {
      } else {
        // You are connected, you can grab the code from the url.
        final fragments = value!.toString().split('=');
        authCode(fragments[1].replaceAll("#/", ""));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              authorizeClick(context);
            },
            child:
                const Button(value: 'Se connecter', width: 250.0, height: 60),
          ),
          const SizedBox(
            height: 50.0,
          ),
          InkWell(
            onTap: () => yannisooLogin(),
            child: const Button(
                value: 'Je suis yannisoo', width: 250.0, height: 60),
          ),
        ],
      ),
    );
  }

  void authorizeClick(BuildContext context) async {
    try {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        String clientId = BungieApiService.clientId!;
        final authorizationEndpoint =
            "https://www.bungie.net/fr/OAuth/Authorize?client_id=$clientId&response_type=code";
        html.window.location.assign(authorizationEndpoint);
      });
    } on OAuthException catch (e) {
      bool isIOS = Platform.isIOS;
      String platformMessage =
          "If this keeps happening, please try to login with a mainstream browser.";
      if (isIOS) {
        platformMessage =
            "Please dont open the auth process in another safari window, this could prevent you from getting logged in.";
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: <Widget>[
                  MaterialButton(
                    textColor: Colors.blueGrey.shade300,
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
                title: Text(e.error),
                content: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        e.errorDescription ?? "error",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        platformMessage,
                        textAlign: TextAlign.center,
                      )
                    ])),
              ));
    }
    WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment = false;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
  }

  authCode(String code) async {
    try {
      await widget.auth.requestToken(code);
      checkMembership();
    } catch (e) {
      inspect(e);
    }
  }

  void checkMembership() async {
    GroupUserInfoCard? membership = await widget.account.getMembership();
    if (membership == null) {
      showSelectMembership();
    }
    Navigator.pushNamed(context, routeProfile);
  }

  void showSelectMembership() async {
    UserMembershipData? membershipData = await widget.api.getMemberships();

    if (membershipData?.destinyMemberships?.length == 1) {
      await widget.account.saveMembership(
          membershipData!, membershipData.destinyMemberships![0].membershipId!);
    }
  }

  void yannisooLogin() async {
    final AuthService auth = AuthService();
    final AccountService account = AccountService();
    final ProfileService profile = ProfileService();
    BungieNetToken token = BungieNetToken.fromJson({
      'access_token':
          "CKz7AxKGAgAgeUtts6Ss0etJ4v74fspqQMJUw03kC5u0Mzy45BRlG8bgAAAAUS2EA1MTJ4wTlOMk5lAdPMc/JaJEBKmobmBLYLxraR9MuZgC3HRldFkjaJBOjpgUCm/DrSpR6QKYXPADmrxXluNAsIqvtdBkRG+jC1PFjkp3lesmfN87OzON3594IbRotxBMe+WvAzjpcNSsu70lJPcuy2uCfYCp5DWjhkhF6hem2TBG1/4GytKb1zVZA7iXqPIYfzwJlGkNI0ibJ8xdjCJCLxu9c4GQZzoff6rLNPcBk+hfQnVyft0xEKYXBLDg7PaV6s3In7uYCfSBMkG/Xa2nyDcD3lWrVQDUDn4+6ww=",
      'expires_in': 3600,
      'membership_id': "11319478",
      'refresh_expires_in': 7776000,
      'refresh_token':
          "CKz7AxKGAgAghSc565zJ3/6Z3QOWGqhr5vjUPZFkn35tLnqoqXByZRTgAAAAVy6LETOkAR+zjX4+PP8eB6XnoqVqd0u6SAk4lkJ6jSSm7dh2bxuydpGnGXAE3PvRL8ZzvA0qboKU/hG67i3tju180xeAJqLIXKOwHliZe+6LM7bv6tg32+Qk7w5c5pk/RpfzgDgp2qQTyf7K+PXJ7Tm/TIDtamDDVNfDIq6QDjeF8sxZPPTiR4LgHzBUHWG7zUGEi6Obcn9CRSTRGmBQHcROgdaaJSEDKb99M/soU5xr+27VK1KsQkFS6XMN60u3BF/CY+ofcYS/luYxfWHKRay/SIgdsn2NNWi85NHQ1Sk="
    });

    if (await auth.getToken() == null) await auth.saveToken(token);
    await account.getMembership();
    await profile.loadProfile();
    Navigator.pushNamed(context, routeProfile);
  }
}
