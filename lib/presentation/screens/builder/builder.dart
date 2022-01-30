import 'package:flutter/material.dart';
import 'package:quria/data/services/backend/bungie_backend_api.service.dart';
import 'package:quria/data/models/BuildResponse.model.dart';
import 'package:quria/data/services/manifest/manifest.service.dart';
import 'package:quria/presentation/components/loader.dart';
import 'package:quria/presentation/screens/builder/components/singleBuild.dart';

class BuilderWidget extends StatelessWidget {
  final BackendService _backendService = BackendService();
  final manifest = ManifestService();

  Future<BuildResponse> promise() async {
    BuildResponse response = await _backendService.getBuilds();
    return response;
  }

  BuilderWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<BuildResponse?> future = promise();
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(
                  "https://www.bungie.net/common/destiny2_content/screenshots/1715842350.jpg"))),
      child: FutureBuilder(
          future: future,
          builder:
              (BuildContext context, AsyncSnapshot<BuildResponse?> snapshot) {
            if (snapshot.hasData) {
              List<Widget> list = <Widget>[];
              list.add(const SizedBox(height: 25));
              for (var i = 0; i < snapshot.data!.builds.length; i++) {
                list.add(SingleBuild(buildInfo: snapshot.data!.builds[i]));
              }
              return ListView(
                children: list,
              );
            } else {
              return const Loader(
                  waitingMessage:
                      'Veuillez patienter nous recherchons les meilleurs builds pour vous!');
            }
          }),
    );
  }
}
