// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestionapp/controllers/property_controller.dart';
import 'package:gestionapp/views/base/custom_loader.dart';
import 'package:get/get.dart';

import '../../../controllers/get_user_controller.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final GetUserController controller = Get.put(GetUserController());

  @override
  void initState() {
    controller.getUserList();
    controller.getAllRoomList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('User List'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isAllUserGetLoading.value) {
              return const Center(child: CustomLoader());
            }
            // Show ListView when data is loaded
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.allUserList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                          key: ValueKey(controller.allUserList[index].id),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  controller.deleteUser(
                                    controller.allUserList[index].id!,
                                  );
                                },
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                borderRadius: BorderRadius.circular(8),
                                label: 'Delete User'.tr,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6E6E6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Name:'.tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            ' '.tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${controller.allUserList[index].name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'E-Mail:'.tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            ' '.tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${controller.allUserList[index].email}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      if (controller.allUserList.isNotEmpty &&
                                          controller
                                                  .allUserList[index]
                                                  .roomIds !=
                                              null &&
                                          controller
                                              .allUserList[index]
                                              .roomIds!
                                              .isNotEmpty)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Room IDs:'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                ' '.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              ...controller
                                                  .allUserList[index]
                                                  .roomIds!
                                                  .map((xid) {
                                                    return Text(
                                                      xid ==
                                                              controller
                                                                  .allUserList[index]
                                                                  .roomIds!
                                                                  .last
                                                          ? "$xid   "
                                                          : "$xid, ",
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AddRoomPopup(
                                                index: index,
                                                userController: controller,
                                              ),
                                        );
                                      },
                                      child: Container(
                                        height: 32.h,
                                        width: 32.h,
                                        decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    GestureDetector(
                                      onTap: () {
                                        final rooms =
                                            controller
                                                .allUserList[index]
                                                .roomIds;
                                        final userId =
                                            controller.allUserList[index].id;
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => DeleteRoomPopup(
                                                index: index,
                                                userController: controller,
                                                userId: userId,
                                                rooms: rooms,
                                              ),
                                        );
                                      },
                                      child: Container(
                                        height: 32.h,
                                        width: 32.h,
                                        decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class AddRoomPopup extends StatelessWidget {
  final TextEditingController roomIdController = TextEditingController();
  final GetUserController controller = Get.put(GetUserController());
  final PropertyController propertyController = Get.put(PropertyController());
  final GetUserController userController;
  final int index;

  AddRoomPopup({super.key, required this.index, required this.userController});
  String? selectedRoom;
  String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Room".tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown for selecting a room
            DropdownButtonFormField<String>(
              value: selectedRoom,
              items:
                  userController.roomList.map((room) {
                    return DropdownMenuItem<String>(
                      value: room.id.toString(),
                      child: Text(room.name),
                    );
                  }).toList(),
              onChanged: (value) {
                selectedRoom = value;
                selectedRoomId = roomIdController.text = value ?? "";
                print(selectedRoomId);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select a Room".tr,
              ),
            ),
            const SizedBox(height: 20),

            // Add Room button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await propertyController.property(
                    owner: controller.allUserList[index].id.toString(),
                    zakRoomId: roomIdController.text.toString(),
                  );
                  print("Room ID: ${roomIdController.text}");
                  controller.getUserList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 32,
                  ),
                ),
                child: Text(
                  "Add Room".tr,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteRoomPopup extends StatelessWidget {
  final TextEditingController roomIdController = TextEditingController();
  final GetUserController controller = Get.put(GetUserController());
  final PropertyController propertyController = Get.put(PropertyController());
  final GetUserController userController;
  final int index;
  String? selectedRoom;
  String? selectedRoomId;

  DeleteRoomPopup({
    super.key,
    required this.index,
    required this.userController,
    required this.userId,
    required this.rooms,
  });

  String? userId;
  List<String>? rooms;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Room".tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown for selecting a room
            DropdownButtonFormField<String>(
              value: selectedRoom,
              items:
                  rooms?.map((room) {
                    return DropdownMenuItem<String>(
                      value: room,
                      child: Text(room),
                    );
                  }).toList(),
              onChanged: (value) {
                selectedRoom = value;

                print(selectedRoomId);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select a Room".tr,
              ),
            ),
            const SizedBox(height: 20),

            // Delete Room button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await propertyController.deleteProperty(
                    propertyId: userId!,
                    roomName: selectedRoom!,
                  );
                  controller.getUserList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 32,
                  ),
                ),
                child: Text(
                  "Delete Room".tr,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
