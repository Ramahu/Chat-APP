# chat app (HapHat)

A real-time chat application is built with **Flutter** and follows a structured and scalable architecture. It integrates **Firebase** services for authentication and real-time data storage, ensuring a smooth and secure user experience. The app supports both **light and dark themes**, provides a **responsive UI**, and maintains **clean architecture** with **Cubit state management** and **SOLID principles**.


## **Features**

### 🔐 **Authentication (Firebase Auth)**
- **Sign in with email & password**
- **Sign in with Google**
- **Sign up with email & password**
- **Email verification**

### 📂 **Firestore Database**
- Stores registered users in a **users collection**
- Chats are stored in a **chats collection**
- Messages are stored in a **messages collection** under each chat

### 💬 **Chat System**
- **Home Page:** Displays a list of active chats fetched from the **chats collection**
- **Chat Page:** Displays messages in real-time from the **messages collection**

### 🎨 **Theming & UI**
- **Light and dark theme support**
- **Fully responsive UI** for different screen sizes

### ⚙ **State Management **
- **Cubit** for efficient state management


![5800727494075206082](https://github.com/user-attachments/assets/63a0cb0e-234f-4888-b3e5-0459b7da8352)


### ⚙ **structure & Architecture**
- **Clean Architecture with an MVVM-like structure** to maintain scalability and separation of concerns
- **SOLID principles** for maintainable and extensible code

![5800727494075206084](https://github.com/user-attachments/assets/76aefd8b-a3b3-4dae-92f0-06b3107cef96)

![5800727494075206083](https://github.com/user-attachments/assets/06107e46-2f17-4bbd-802d-fab27afb8122)

![5800727494075206085](https://github.com/user-attachments/assets/329f9be7-623a-4170-bdcd-7f979582d93e)

![5861731951122172251](https://github.com/user-attachments/assets/557c10d5-e157-457d-ba9e-97769a4460ff)

![5861731951122172252](https://github.com/user-attachments/assets/f0c70486-14da-43fc-aaa0-3d4ad24baaa6)


### 💾 **Local Storage (Shared Preferences)**
- Caches **user ID** locally for session persistence

## **Interface**  

- Splash Screen , Login (light and dark themes) :
  
![Mobile App Screen Mockup (2)](https://github.com/user-attachments/assets/8840c4ef-8194-47ee-a061-9761b2ac041e)

-  Create account (light and dark themes) :

  ![Mobile App Screen Mockup (1)](https://github.com/user-attachments/assets/a897b358-1a26-45b0-b6ed-cec6becf5576)

-  Home page (all chats Screen) , chat screem (dark themes) :
  
![Mobile App Screen Mockup (3)](https://github.com/user-attachments/assets/6d50c907-2335-40d8-9e17-fb74a408bfb6)
