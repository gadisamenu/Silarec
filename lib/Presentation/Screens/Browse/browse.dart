import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silarec/Application/StoragePermission/st_permission_bloc.dart';

import '../../../Provider/common_provider.dart';

class Browse extends StatelessWidget {
  final FileManagerController controller = FileManagerController();
  Browse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stPermissionBloc = BlocProvider.of<StPermissionBloc>(context);
    return BlocConsumer<StPermissionBloc, StPermissionState>(
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
                            // delete a folder
                            // await entity.delete(recursive: true);
                            // rename a folder
                            // await entity.rename("newPath");
                            // Check weather folder exists
                            // entity.exists();
                            // get date of file
                            // DateTime date = (await entity.stat()).modified;
                          } else {
                            // delete a file
                            // await entity.delete();
                            // rename a file
                            // await entity.rename("newPath");

                            // Check weather file exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;

                            // get the size of the file
                            // int size = (await entity.stat()).size;
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
          stPermissionBloc.add(GetPermission());
        }
        return Text("Give Storage Permission");
      },
      listener: (BuildContext context, Object? state) {},
    );
  }

  String get_title() => "Browse";
}
