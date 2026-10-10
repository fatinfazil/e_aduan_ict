importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"
);


firebase.initializeApp({

  apiKey: "AIzaSyC3_k0Hs0FjFlVpPYdLwzH4s9iXoVrjsu4",

  authDomain:
  "e-aduan-ict-kuypj.firebaseapp.com",

  projectId:
  "e-aduan-ict-kuypj",

  storageBucket:
  "e-aduan-ict-kuypj.firebasestorage.app",

  messagingSenderId:
  "116343591068",

  appId:
  "1:116343591068:web:ecfd61c2d51e03f77b9d59"

});


const messaging = firebase.messaging();