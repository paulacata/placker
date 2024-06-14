import 'package:flutter/material.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla per modificar els temps de focus, pausa i sessions del registre
class EditTimeRegisterScreen extends StatefulWidget {

  final int sessions;
  final int tempsFocus;
  final int tempsPausa;
  final TimerController timerController;
  final void Function(int) updateRemainingTime;

  const EditTimeRegisterScreen({
    Key? key,
    required this.sessions,
    required this.tempsFocus,
    required this.tempsPausa,
    required this.timerController,
    required this.updateRemainingTime,
  }) : super(key: key);

@override
  _EditTimeRegisterScreenState createState() => _EditTimeRegisterScreenState();
}

class _EditTimeRegisterScreenState extends State<EditTimeRegisterScreen> {
  
  final TextEditingController _sessionsController = TextEditingController();
  final TextEditingController _tempsFocusController = TextEditingController();
  final TextEditingController _tempsPausaController = TextEditingController();
  late TimerController _timerController;

  @override
  void initState() {
    super.initState();
    _sessionsController.text = widget.sessions.toString();
    _tempsFocusController.text = (widget.tempsFocus ~/ 60).toString();
    _tempsPausaController.text = (widget.tempsPausa ~/ 60).toString();
    _timerController = widget.timerController;
    _timerController.remainingTime = widget.tempsFocus;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFCDE7FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            //creu a dalt a la dreta per tornar a la pantalla anterior
            Padding(
              padding: const EdgeInsets.only(right: 5, left:5, top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                const SizedBox(height: 100),
                buildTimeText(text: 'FOCUS:', controller: _tempsFocusController),
                const SizedBox(height: 80),
                buildTimeText(text: 'PAUSA:', controller: _tempsPausaController),
                const SizedBox(height: 80),
                buildTimeText(text: 'SESSIONS:', controller: _sessionsController),
                const SizedBox(height: 100),
            
                ElevatedButton(
                  onPressed: () {
                    int sessions = int.parse(_sessionsController.text);
                    int tempsFocus = int.parse(_tempsFocusController.text) * 60;
                    int tempsPausa = int.parse(_tempsPausaController.text) * 60;
                    widget.updateRemainingTime(tempsFocus);
                    Navigator.pop(context, {'sessions': sessions, 'tempsFocus': tempsFocus, 'tempsPausa': tempsPausa});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF506EA4),
                    elevation: 0,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('GUARDAR', style: TextStyle(fontSize: 18)), 
                ),

                const SizedBox(height: 50),

              ],
            ),
          ]
        ),
      ),
    );
  }

  Row buildTimeText({required String text, required TextEditingController controller}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff506EA4),
          ),
        ),

        const SizedBox(width: 20),

        SizedBox(
          width: 100,
          height: 45,
          child: TextField(
            controller: controller,
            cursorColor: Colors.grey,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),          
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xff506EA4),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
            
            style: const TextStyle(fontSize: 23, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}