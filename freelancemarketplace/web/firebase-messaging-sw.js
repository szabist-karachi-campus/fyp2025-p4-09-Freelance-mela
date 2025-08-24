 importScripts("https://www.gstatic.com/firebasejs/9.19.1/firebase-app-compat.js");
 importScripts("https://www.gstatic.com/firebasejs/9.19.1/firebase-messaging-compat.js");

 firebase.initializeApp({
  apiKey: "AIzaSyDWL6WOhE6Amk-JH8N-Xdkwcjqd0DL7A9c",
  authDomain: "freelancing-f0bd1.firebaseapp.com",
  databaseURL: "https://freelancing-f0bd1-default-rtdb.firebaseio.com",
  projectId: "freelancing-f0bd1",
  storageBucket: "freelancing-f0bd1.firebasestorage.app",
  messagingSenderId: "775995148373",
  appId: "1:775995148373:web:dc653274308fdbae946cdc",
  measurementId: "G-5GVCLJJZPJ"
 });

 const messaging = firebase.messaging();

 // Handle background messages
 messaging.onBackgroundMessage(async (payload) => {
   console.log('Received background message:', payload);

   const notificationTitle = payload.notification.title;
   const notificationOptions = {
     body: payload.notification.body,
     icon: '/icons/Icon-192.png',
     badge: '/icons/Icon-192.png',
     data: payload.data,
     click_action: payload.notification.click_action,
   };

   self.registration.showNotification(notificationTitle, notificationOptions);
 });