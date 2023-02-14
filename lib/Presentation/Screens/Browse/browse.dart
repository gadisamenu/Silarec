import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Browse extends StatelessWidget {
  final FileManagerController controller = FileManagerController();
  final PermissionStatus storagePermission;
  Browse({required this.storagePermission, Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    if (storagePermission.isGranted) {
      var deviceWidth = MediaQuery.of(context).size.width;
      var storageIconSize = deviceWidth / 3;

      return ControlBackButton(controller: controller, child: Text("here"));
      // FileManager(
      //       controller: controller,
      //       builder: (context, snapshot) {
      //         final List<FileSystemEntity> entities = snapshot;
      //         return ListView.builder(
      //             itemCount: entities.length,
      //             itemBuilder: (context, index) {
      //               FileSystemEntity entity = entities[index];
      //               return Card(
      //                 child: ListTile(
      //                   leading: getFileIcon(entity),
      //                   title: Text(FileManager.basename(entity)),
      //                   subtitle: subtitle(entity),
      //                   onTap: () async {
      //                     if (FileManager.isDirectory(entity)) {
      //                       // open the folder
      //                       controller.openDirectory(entity);
      //                       // delete a folder
      //                       // await entity.delete(recursive: true);
      //                       // rename a folder
      //                       // await entity.rename("newPath");
      //                       // Check weather folder exists
      //                       // entity.exists();
      //                       // get date of file
      //                       // DateTime date = (await entity.stat()).modified;
      //                     } else {
      //                       // delete a file
      //                       // await entity.delete();
      //                       // rename a file
      //                       // await entity.rename("newPath");

      //                       // Check weather file exists
      //                       // entity.exists();

      //                       // get date of file
      //                       // DateTime date = (await entity.stat()).modified;

      //                       // get the size of the file
      //                       // int size = (await entity.stat()).size;
      //                     }
      //                   },
      //                 ),
      //               );
      //             });
      //       },
      //     )
    } else {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: ElevatedButton(
                    onPressed: () async => {
                          await Permission.storage.request(),
                          if (storagePermission.isGranted) {}
                          // await openAppSettings()
                        },
                    child: Text("Permission Denied")),
              ));
    }
    return Text("Give Storage Permission");
  }

  String get_title() => "Browse";
}
