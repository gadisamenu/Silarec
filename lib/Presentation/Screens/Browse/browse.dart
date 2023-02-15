import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silarec/Application/StoragePermission/st_permission_bloc.dart';
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
        if (state is Granted) {
          var deviceWidth = MediaQuery.of(context).size.width;
          var storageIconSize = deviceWidth / 3;
          return ControlBackButton(
            controller: controller,
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities = snapshot;
                print(entities.length);
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
                            // open the folder
                            controller.openDirectory(entity);
                          } else {
                            // if (isVideo(entity)) {
                            //   open_video(entity, context);
                            // }
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
                  insetAnimationDuration: Duration(seconds: 5),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Permission Denied"),
                      ElevatedButton(
                        child: const ListTile(
                            title: Text("Give Permission"),
                            leading: const Icon(Icons.settings)),
                        onPressed: () async {
                          await Permission.storage.request();
                          stPermissionBloc.add(OpenFile());
                        },
                      ),
                      ElevatedButton(
                        child: const ListTile(
                            title: Text("Exit"),
                            leading: const Icon(Icons.cancel)),
                        onPressed: () => {
                          context.go("/navigator"),
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
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     });
  // }

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
