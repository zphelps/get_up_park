// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.https.onCall((data, context) => {
    const payload = {
        notification: {
            title: data["title"],
            body: data["body"], //Or you can set a server value here.
//            imageURL: data["imageURL"] == null ? 'https://firebasestorage.googleapis.com/v0/b/get-up-park.appspot.com/o/groupLogos%2FpantherHead.png?alt=media&token=2502dcaf-6206-4359-9940-4b6af967cd5a' : data['imageURL']
        },
        //If you want to send additional data with the message,
        //which you dont want to show in the notification itself.
        data: {
            data_to_send: "msg_from_the_cloud",
        }
    };
    admin.messaging().sendToTopic("News", payload).then(value => {
        console.info("function executed succesfully");
        return { msg: "function executed succesfully" };
    })
    .catch(error => {
        console.info("error in execution");
        console.log(error);
        return { msg: "error in execution" };
    });
});

//export const sendToTopic = functions.firestore
//  .document('puppies/{puppyId}')
//  .onCreate(async snapshot => {
//    const puppy = snapshot.data();
//
//    const payload: admin.messaging.MessagingPayload = {
//      notification: {
//        title: 'New Puppy!',
//        body: `${puppy.name} is ready for adoption`,
//        icon: 'your-icon-url',
//        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
//      }
//    };
//
//    return fcm.sendToTopic('puppies', payload);
//  });