// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gestionapp/controllers/localization_controller.dart';
import 'package:gestionapp/helpers/prefs_helper.dart';
import 'package:gestionapp/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser; // Import for parsing
import 'package:html/dom.dart' as dom; // Import for DOM manipulation

import '../../../../utils/app_dimensions.dart';
import '../../base/custom_text.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading = false;
  String privacyPolicyHtml = ''; // Store the extracted HTML here

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      PrefsHelper.getInt(AppConstants.language).then((value) async {
        final url =
            value == -1 || value == 0
                ? 'https://gestionviviendavacacional.com/en/policies/privacy-policy'
                : 'https://gestionviviendavacacional.com/policies/privacy-policy';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Parse the HTML.
          final document = html_parser.parse(response.body);

          // Find the element with the privacy policy content.  Use a more specific selector.
          final privacyPolicyElement = document.querySelector(
            'div.shopify-policy__body > div.rte',
          );

          if (privacyPolicyElement != null) {
            // Extract the inner HTML of the element.
            setState(() {
              privacyPolicyHtml = privacyPolicyElement.innerHtml;
              isLoading = false;
            });
          } else {
            setState(() {
              privacyPolicyHtml =
                  "<p>Error: Could not find privacy policy content.</p>";
              isLoading = false;
            });
            debugPrint("Error: Could not find the privacy policy element.");
          }
        } else {
          // Handle HTTP errors.
          setState(() {
            privacyPolicyHtml =
                "<p>Error: Failed to load privacy policy. Status code: ${response.statusCode}</p>";
            isLoading = false;
          });
          debugPrint("HTTP Error: ${response.statusCode}");
        }
      });
    } catch (e) {
      // Handle any other errors (e.g., network connection issues).
      setState(() {
        privacyPolicyHtml = "<p>Error: Failed to load privacy policy. $e</p>";
        isLoading = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: 'Privacy Policy'.tr,
          fontsize: 18.h,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: 16.h,
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      HtmlWidget(
                        privacyPolicyHtml, // Display the *extracted* HTML.
                        // Add more styling and configuration as needed.
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
      ),
    );
  }
}
