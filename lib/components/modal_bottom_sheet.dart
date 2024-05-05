import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class CustomBottomSheet extends StatefulWidget {
  void Function(String) onChanged;
  CustomBottomSheet({super.key, required this.onChanged});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return IconButton(
      onPressed: () {
        locationController.clear();
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Container(
              // height: size.height * .6,
              height:
                  MediaQuery.of(context).viewInsets.bottom + size.height * .2,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff955cd1),
                    Color(0xff362A84),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Divider(
                      thickness: 3.5,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    cursorColor: Colors.white60,
                    onChanged: widget.onChanged,
                    controller: locationController,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: "Enter Location",
                      hintStyle: TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => locationController.clear(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
