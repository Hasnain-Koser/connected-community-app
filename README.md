# connected-community-app

## Inspiration

Nowadays with growing housing societies it is extremely hard to keep up and maintain the society, as the housing society grows larger and larger communication gap is created and can cause multiple conflicts and problems with the society, especially during this time of pandemic where face-to-face communication and collaboration is not possible and announcements on society billboards or posters are not effective as a result of nobody ever leaving their homes. Even though some housing societies might have some sort of communication on social media platforms such as WhatsApp, it is yet hard to keep up with the different initiatives, events and occurrences happening in the society.

I was able to notice a similar problem with the housing society that I reside in during the COVID-19 pandemic where most of the communication was done online. I aim to solve this issue through the creation of a platform that will be able to connect the entire community effectively.

## What it does

The application is generally built to connect a community through various means. It has management as well as communication features. Society admins can manage users and setup notices and events and handle or resolve complaints. The residents have multiple means of communication where they can chat with either specific users or the whole community and can also setup community posts. In order to help each other, residents can also setup community services and contact each other regarding the same in-app. New users and residents are greeted with a informational video to help accomodate them better into the community.


## How it was built

The application was built with Flutter and Dart, using Firebase as a backend. It was created using flutter to better optimize the reach of the application to both iOS and Android devices. The project has a structured folder layout with a highly flexible design pattern to allow for flexibility for any future updates and changes to be made to the application.

Firebase was used as a NoSQL database and backend, with FireAuth for user authentication and Cloud firestore to store and manipulate user and application data. The authentication was setup with email verification to avoid scam users. The firestore database was structured into seperate collections to allow for scalable and flexible development of features such as the chat app, community posts, notice board etc. 

## Application Screenshots

<table>
  <tr>
    <td>Cover Screen</td>
    <td>Sign Up Screen</td>
    <td>Sign In Screen</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520487-c7c17b33-2894-4f99-8bd2-f3f39c94a42b.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520506-253abbda-955f-4707-8fe2-5ad28abd33f8.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520535-da3771a3-b528-4f11-a745-ab9a91856307.png" width=270 height=330></td>
  </tr>
  <tr>
    <td>Home Screen</td>
    <td>Profile Screen</td>
    <td>Help Screen</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/56708015/189523280-099d06c9-94e0-4661-acca-283b5d10b08b.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189523358-0ecd10c7-0516-4548-93b2-5774b4241d1e.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520793-8a831eaf-ef77-47aa-8522-10e767e3b21c.png" width=270 height=590></td>
  </tr>
  <tr>
    <td>Event Timeline</td>
    <td>Notice Board</td>
    <td>Services Screen</td>   
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520715-a679c042-a78a-4e41-a3a9-81ffa01ff81c.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189523565-f4894339-f263-428a-b340-afbf9e99fd10.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520671-8206e516-a409-4f14-a8ae-5bf569c0eec3.png" width=270 height=590></td>
  </tr>
  <tr>
    <td>Personal Chat</td>
    <td>Community Chat</td>
    <td>Community Posts</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520750-4a8343bd-5dc1-4e5e-9311-636636d6fa8b.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520756-c9c9dd94-2bb5-46bf-b81a-6512c363a793.png" width=270 height=590></td>
    <td><img src="https://user-images.githubusercontent.com/56708015/189520777-710da52d-63e6-482a-873f-87d41502ec33.png" width=270 height=590></td>
  </tr>
 </table>


