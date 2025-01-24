importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyD0qJ8g9xMPeYh-rFGmgYjBTCezWWwy6AY",
    authDomain: "eatseasy-49a0d.firebaseapp.com",
    projectId: "eatseasy-49a0d",
    storageBucket: "eatseasy-49a0d.firebasestorage.app",
    messagingSenderId: "1054069052055",
    appId: "1:1054069052055:web:edf17a48746c5547e38fd2"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});