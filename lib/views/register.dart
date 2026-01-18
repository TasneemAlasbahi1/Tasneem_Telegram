import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Register',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:25 ),),
          backgroundColor: const Color.fromARGB(255, 78, 150, 194),
          iconTheme: const IconThemeData(color: Colors.white),
         
        
        
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            TextField(

              controller: name,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person,color: Color.fromARGB(255, 78, 150, 194),),
                border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                  borderSide:BorderSide(
                    color: Color.fromARGB(255, 78, 150, 194),
                    width: 2), 
                  
                ),


              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email,color: Color.fromARGB(255, 78, 150, 194),),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:BorderSide(
                    color: Color.fromARGB(255, 78, 150, 194),
                    width: 2), 
                  
                ),
                
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock,color: Color.fromARGB(255, 78, 150, 194),),
                border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                  borderSide:BorderSide(
                    color: Color.fromARGB(255, 78, 150, 194),
                    width: 2), 
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 78, 150, 194))
              
              
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Account Created")),
                );
              },
              child: Text("Register",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}