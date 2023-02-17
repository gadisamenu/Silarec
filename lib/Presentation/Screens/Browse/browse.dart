import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silarec/Application/StoragePermission/st_permission_bloc.dart';
import 'package:silarec/Presentation/Screens/Videos/samplePlayer.dart';
import 'package:video_player/video_player.dart';

import '../../../Provider/common_provider.dart';

class Browse extends StatelessWidget {
  Browse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileManagerController controller = FileManagerController();
    final stPermissionBloc = BlocProvider.of<StPermissionBloc>(context);
    return BlocBuilder<StPermissionBloc, StPermissionState>(
      builder: (context, state) {
        if (stPermissionBloc.stPermission.isGranted) {
          var deviceWidth = MediaQuery.of(context).size.width;
          var storageIconSize = deviceWidth / 3;
          return ControlBackButton(
            controller: controller,
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities = snapshot;

                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    FileSystemEntity entity = entities[index];

                    return Card(
                      child: ListTile(
                        leading: getFileIcon(entity),
                        title: Text(FileManager.basename(entity)),
                        subtitle: subtitle(entity),
                        onTap: () async {
                          if (FileManager.isDirectory(entity)) {
                            controller.openDirectory(entity);
                          } else {
                            context.go("/video_player", extra: entity);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              height: 200,
              child: Dialog(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Permission Denied"),
                  ElevatedButton(
                    child: const ListTile(
                        title: Text("Give Permission"),
                        leading: Icon(Icons.settings)),
                    onPressed: () async {
                      await Permission.storage.request();
                      if (stPermissionBloc.stPermission.isGranted) {
                        stPermissionBloc.add(OpenFile());
                      } else {
                        context.go("/");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const ListTile(
                        title: Text("Exit"), leading: Icon(Icons.cancel)),
                    onPressed: () => {
                      context.go("/"),
                    },
                  ),
                ],
              )),
            ),
          );
        }
      },
    );
  }

  String get_title() => "Browse";
}

open_video(FileSystemEntity entity, BuildContext context) {
  late VideoPlayerController _controller =
      VideoPlayerController.contentUri(entity.uri);

  showDialog(
      context: context,
      builder: (context) {
        return MaterialApp(
          title: 'Video Demo',
          home: Scaffold(
            body: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     setState(() {
            //       _controller.value.isPlaying
            //           ? _controller.pause()
            //           : _controller.play();
            //     });
            //   },
            //   child: Icon(
            //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            //   ),
            // ),
          ),
        );
        //   @override
        // void dispose() {
        //   super.dispose();
        //   _controller.dispose();
        // }
      });
}
