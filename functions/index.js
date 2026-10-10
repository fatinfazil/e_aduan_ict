const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();


exports.sendStatusNotification =
functions.firestore
.document("aduan/{aduanId}")
.onUpdate(async (change) => {


  const before = change.before.data();
  const after = change.after.data();


  if (before.status === after.status) {
    return null;
  }


  const uid = after.uid;


  const userDoc = await admin.firestore()
    .collection("users")
    .doc(uid)
    .get();


  if (!userDoc.exists) {
    return null;
  }


  const token = userDoc.data().fcmToken;


  if (!token) {
    return null;
  }


  const message = {

    notification: {

      title: "Aduan ICT Dikemaskini",

      body: `Status aduan anda: ${after.status}`,

    },

    token: token,

  };


  return admin.messaging()
    .send(message);


});