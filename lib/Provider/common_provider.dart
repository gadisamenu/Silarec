import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import "package:permission_handler/permission_handler.dart";

Widget subtitle(FileSystemEntity entity) {
  return FutureBuilder<FileStat>(
    future: entity.stat(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (entity is File) {
          int size = snapshot.data!.size;

          return Text(
            "${FileManager.formatBytes(size)}",
          );
        }
        return Text(
          "${snapshot.data!.modified}".substring(0, 10),
        );
      } else {
        return Text("");
      }
    },
  );
}

get_permission() async {
  return await Permission.storage.status;
}

selectStorage(BuildContext context, controller) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: FutureBuilder<List<Directory>>(
        future: FileManager.getStorageList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FileSystemEntity> storageList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((e) => ListTile(
                            title: Text(
                              "${FileManager.basename(e)}",
                            ),
                            onTap: () {
                              controller.openDirectory(e);
                              Navigator.pop(context);
                            },
                          ))
                      .toList()),
            );
          }
          return Dialog(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ),
  );
}

sort(BuildContext context, controller) async {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                title: Text("Name"),
                onTap: () {
                  controller.sortBy(SortBy.name);
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text("Size"),
                onTap: () {
                  controller.sortBy(SortBy.size);
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text("Date"),
                onTap: () {
                  controller.sortBy(SortBy.date);
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text("type"),
                onTap: () {
                  controller.sortBy(SortBy.type);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    ),
  );
}

// createFolder(BuildContext context) async {
//   showDialog(
//     context: context,
//     builder: (context) {
//       TextEditingController folderName = TextEditingController();
//       return Dialog(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: TextField(
//                   controller: folderName,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     // Create Folder
//                     await FileManager.createFolder(
//                         controller.getCurrentPath, folderName.text);
//                     // Open Created Folder
//                     controller.setCurrentPath =
//                         controller.getCurrentPath + "/" + folderName.text;
//                   } catch (e) {}

//                   Navigator.pop(context);
//                 },
//                 child: Text('Create Folder'),
//               )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
// }
Widget getFileIcon(FileSystemEntity entity) {
  if (FileManager.isFile(entity)) {
    if (isVideo(entity)) {
      return const Icon(Icons.play_arrow);
    }
    return const Icon(Icons.image);
  }
  return const Icon(Icons.folder);
}

isVideo(FileSystemEntity entity) {
  List videoTypes = ["mp4", "mkv", "webm"];
  String type = FileManager.getFileExtension(entity);
  for (var videoType in videoTypes) {
    if (videoType == type) {
      return true;
    }
  }
  return false;
}
