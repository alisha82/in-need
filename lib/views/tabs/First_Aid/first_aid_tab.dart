import 'package:flutter/material.dart';
import 'package:inneed_practice/Providers/FirstAid_provider/first_aid_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class FirstAidTab extends StatefulWidget {
  const FirstAidTab({super.key});

  @override
  State<FirstAidTab> createState() => _FirstAidTabState();
}

class _FirstAidTabState extends State<FirstAidTab> {
  final TextEditingController _messageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final firstAidProvider = Provider.of<FirstAidProvider>(context);
    final List<String> emrgencySuggestions = [
      "Choking",
      "Bleeding",
      "Burns",
      "Chest Pain",
      "Unconscious Person",
      "Broken Bone/Fracture",
      "Seizure",
      "Poisoning",
      "Allergic Reaction",
      "Other Emergency",
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 30, ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //top card
          Container(
            padding: const EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0), // Light Pink background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfffee2e2)
                  ),
                  child: Icon(Icons.favorite_border, size: 20, color: Colors.red,),

                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Aid Assistant / فرسٹ ایڈ \nاسسٹنٹ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFB71C1C),
                          ),),
                       const SizedBox(height: 2,),
                        Text('Get immediate first aid guidance with Urdu support - For emergencies, call 1122',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey
                          ),),

                      ],
                    ),),
                IconButton(
                  onPressed: (){
                    firstAidProvider.clearChat();

                  },
                  icon: const Icon(Icons.delete_outline,
                    color: Colors.red,
                    size: 20,),),
              ],
            ),
          ),
          const SizedBox(height: 16),
          //chat display box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                //  default greeting card
                if (firstAidProvider.messages.isEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hello! I'm the IN NEED First Aid Assistant. I'm here to help guide you through emergency situations. Please choose your emergency or ask any first-aid question:",
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                              const Divider(height: 24, thickness: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: const Text(
                                      'اردو',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.volume_up_outlined, size: 14, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text('Listen', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "ہیلو! میں IN NEED فرسٹ ایڈ اسسٹنٹ ہوں۔ میں ہنگامی حالات میں آپ کی رہنمائی کے لیے حاضر ہوں۔ براہ کرم اپنی ہنگامی صورتحال منتخب کریں یا سوال پوچھیں:",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                //  Live Chat Messages (User Right Blue Pill, AI Left Grey Card)
                if (firstAidProvider.messages.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: firstAidProvider.messages.map((msg) {
                      if (msg.isUser) {
                        // User Bubble (Blue Pill Button style on Right Side)
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5), // Reference Blue Color
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg.text.replaceAll("Give immediate first aid instructions for: ", ""),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // AI Response Card (Light Grey Box on Left Side)
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              msg.text,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  ),

                // Loading Indicator
                if (firstAidProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Assistant is thinking...",
                      style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
   // EMERGENCY SUGGESTIONS BUTTONS (CHIPS)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emrgencySuggestions.map((title){
                return GestureDetector(
                  onTap: (){
                    firstAidProvider.sendMessage("Give immediate first aid instructions for: $title");
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                  ),
                      child: Text(title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      ),),
                );
              },
              ).toList(),

            ),
          ),

          const SizedBox(height: 16),
          //input bar and disclaimer
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5), // Light Grey Input Box
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message or select an emergency...",
                            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),

                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: (){
                          if (_messageController.text.trim().isNotEmpty) {
                            final text = _messageController.text;
                            _messageController.clear(); // clear field
                            firstAidProvider.sendMessage(text); // send to gemini
                          }

                        },
                        icon: Icon(Icons.send_rounded,
                          size: 14,
                          color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                //Disclaimer
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                      size: 12,
                      color: Colors.amber,),
                    SizedBox(width: 4,),
                    Text(
                      "This is guidance only, not medical advice. Always call 1122 for \nemergencies.",
                      style: TextStyle(fontSize: 10,
                          color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(
                    children: [

                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Life-Threatening \nEmergency?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFB71C1C)),),
                            Text(
                              "Don't wait - Call for help immediately",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red),
                            ),
                          ],
                        ),

                      ),
                      ElevatedButton(
                        onPressed: () async{
                          final Uri url = Uri.parse('tel:1122');
                          if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Call Emergency',
                          style: TextStyle(fontSize: 11, color: Colors.white),),)

                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
