import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
// GLOBAL VARIABLES
//
// new (private) instance of CLOUD FIRESTORE
// NOTE Firestore replaced in modern Flutter with FirebaseFirestore
//
final _firestore = FirebaseFirestore.instance;
//
// FirebaseUser rename in modern Firebase to 'User'
// use '?' for null safety
User? loggedInUser;

//
//
class ChatScreen extends StatefulWidget {
  //
  static const String id = 'chat_screen';
  //
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //
  // VARIABLES
  //
  final messageTextController = TextEditingController();
  //
  final _auth = FirebaseAuth.instance;
  //
  // for message text
  String messageText = '';

  //
  // initialise state
  //
  @override
  void initState() {
    super.initState();
    //
    getCurrentUser();
  }

  //
  // FUTURE METHOD to check if there is a current user signed in
  //
  getCurrentUser() {
    //
    // set this to the current user if signed in
    //
    // use try in case of user errors, show exceptions
    //
    try {
      //
      // 'currentUser' is no longer a async method, it's a property (getter)
      // and it's SYNCHRONOUS, no need for async, await
      //
      final user = _auth.currentUser;
      //
      // check for null
      if (user != null) {
        loggedInUser = user;
        //
        // added '!' because it could be null
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }

    //
    //
  }

  //
  // METHOD for streaming through a list of (future objects) messages
  // subscribing to this stream
  //
  void messageStream() async {
    //
    // FIRST for-in loop to recover each snapshot
    // CLAUDE/GOOGLE AI suggest ordering messages by time/stamp
    await for (var snapshot
        in _firestore.collection('messages').orderBy('timestamp').snapshots()) {
      // SECOND for-in loops through each snapshot's document
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    ;
  }

  //
  // BUILD
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //
                // log out & return to the login screen
                //
                //messageStream();
                //getMessages();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          '⚡️Chat Away!',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //  ROW removed
            //
            MessagesStream(),
            //
            // isolate text input field and send button from message list above
            //
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      // use this property to later clear this field
                      controller: messageTextController,
                      onChanged: (value) {
                        //
                        // user input text message
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  //
                  //
                  TextButton(
                    onPressed: () {
                      // messageText + loggerInUser.email
                      //
                      // clear text inside field
                      messageTextController.clear();
                      // start by checking if loggedInUser in null
                      if (loggedInUser != null) {
                        //
                        // add function requires mapping
                        // keys need to match fields in Firebase database
                        //
                        _firestore.collection('messages').add(
                            // '?' handles if loggedInUser is null
                            // if so, then don't crash, stop & return null for this expression
                            // 'timestamp' field needed to correctly order messages, unlike in tutorial!!
                            {
                              'text': messageText,
                              'sender': loggedInUser?.email,
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            //
            // SEND BUTTON
            //
            // (FlatButton deprecated, use TextButton instead)
            //
          ],
        ),
      ),
    );
  }
}

//
//
// CLASS for message stream
//
class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          //
          // build messages stream with these attributes
          stream: _firestore
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          //
          // this snapshot is not the same as the one in messageStream method above
          // this is an AsyncSnapshot containing a QuerySnapshot from Firebase,
          // ...accessed by 'data' property, which contains a list of document snapshots
          //
          builder: (context, snapshot) {
            // check for errors
            //
            if (snapshot.hasError) {
              // print this if it shows up in console
              print('Firestore stream error: ${snapshot.error}');
              //
              return Center(
                child: Text('Error loading message'),
              );
            }
            //
            // check for data
            if (snapshot.hasData) {
              // snapshot of type AsyncSnapshot
              // '!' to assert it's not null
              // 'reversed' ensures newest message appears at the bottom
              final messages = snapshot.data!.docs.reversed;
              // show how many messages
              // this is a 'debug line' (CLAUDE AI)
              print('Number of messages: ${messages.length}');

              //
              // FOR loop for building a lot of text widgets
              //
              List<MessageBubble> messageBubbles = [];
              //
              for (var message in messages) {
                //
                // from CLAUDE/GOOGLE AI
                final data = message.data() as Map<String, dynamic>;
                // message is a document snapshot from Firebase
                // use the field names from collection
                // data is a method not property
                final messageText = data['text'] ?? '';
                final messageSender = data['sender'] ?? '';
                //
                //
                final currentUser = loggedInUser?.email;
                //
                if (currentUser == messageSender) {
                  // message is from logged in user
                }
                //
                // display message detail inside this widget
                // MESSAGE BUBBLE class
                //
                final messageBubble = MessageBubble(
                  sender: messageSender,
                  text: messageText,
                  //
                  // depending on the user (email), assign them a different colour massage bubble
                  //
                  isMe: currentUser == messageSender,
                );
                //
                //
                // add it to our list
                messageBubbles.add(messageBubble);
              }
              //
              // return messages in a list, take up available space
              return ListView(
                //
                // messages stick towards bottom of the screen and show
                reverse: true,
                //
                //
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                children: messageBubbles,
              );
            }
            //
            // only shows whilst waiting for data
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }),
    );
  }
}

//
//
// CLASS for message bubbles
//
class MessageBubble extends StatelessWidget {
  //
  // CONSTRUCTOR
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});
  //
  // PROPERTIES
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // moves text widgets to left or right side depending on current user status
        //
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          //
          // separate SENDER from MESSAGE TEXT
          Text(
            sender,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white70,
            ),
          ),
          //
          Material(
            // rounded bubbles
            // with speech points
            // moving the ternary inside the constructor call rather than around it
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isMe ? 0.0 : 30.0),
              topLeft: Radius.circular(isMe ? 30.0 : 0.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            // drop-shadow
            elevation: 6.0,
            //
            // change bubble colour according to who is logged in
            color: isMe ? Colors.indigoAccent : Colors.purpleAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              //
              // TEXT inside its own bubble, separate from SENDER
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isMe ? Colors.white : Colors.yellowAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
