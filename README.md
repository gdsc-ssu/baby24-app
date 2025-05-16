# 🍼 Baby24
What if there were a guardian angel that could watch over your child even while they sleep?

Baby 24 is an inclusive, AI-powered sleep safety system that stays by your child’s side throughout the night and instantly alerts you in moments of danger.

## ⚙️ Features
<img width="821" alt="image" src="https://github.com/user-attachments/assets/ea736ece-4550-4dc6-98df-6b006aa9a98b" />


### 🛌 Real-time Infant Sleep Monitoring

Reuses unused smartphones as 24/7 baby monitors, continuously streaming video using WebRTC.  
Allows caregivers to remotely check the baby’s status in real time, anytime and anywhere.  

⸻

### 🤖 AI-based Suffocation Risk Detection

Employs Google Vertex AI with Gemini, which performs real-time video analysis to detect suffocation risks with high precision.   
Detects dangerous situations such as blankets or pillows covering the baby’s face, and sends alerts immediately.  

⸻

### 🏠 Smart Home Device Integration Alerts

When a threat is detected, sends multi-channel alerts through existing smart home devices via SmartThings API.   
Customized alerts are provided depending on the caregiver’s needs:  
	•	👂 Hearing-impaired: Flashing lights, vibration pads, TV warnings  
	•	👁️ Visually impaired: Audio alarms via smart speakers  
	•	🚶 Mobility-impaired: Emergency messages sent automatically to pre-set contacts  

⸻

### 🔄 Continuous Feature Expansion  

Upcoming features will include:  
	•	👶 Cry detection  
	•	🤕 Fall detection  
	•	🌐 Broader smart device support using Google Home API integration  

These improvements aim to further enhance safety and accessibility for all types of caregivers.

 ## 💻 Technology

 ### Used Google Technology
 <img width="1043" alt="image" src="https://github.com/user-attachments/assets/d099b109-4b40-43f3-b8f4-0ec85c34ec8c" />


 🏠 Smart Home Device

The **Google Home API** allows to utilize many smart home devices.
When the AI detects a danger situation, it can use smart home devices already installed and registered on Google Home to notify a danger situation.
Smart home devices are used to provide a form of notification that is easy for anyone to recognize.

⸻

🧠 AI Analysis

**Firebase Vertex AI’s Gemini** analyzes a child’s sleep situation in real time.
We are constantly learning models to improve the accuracy of our analysis and to expand the scope of our analysis.
It detects choking hazards, such as blankets or pillows that cover a baby’s face, or risks of crying or falling.

⸻

🎥 Video Streaming

It provides real-time video streaming using **WebRTC**.
WebRTC allows direct communication between devices, which enables fast communication without delay.
Caregiver can remotely monitor the baby’s sleep status 24 hours a day with their phones, using their smartphones as cameras that are no longer in use.

⸻

⚙️ DevOps

Server images are deployed through Artifact Registry.
**Cloud Run** continuously deploys the server by pulling these images.
The database is managed with **Cloud SQL**.
The overall infrastructure is managed using Terraform.

 ### 🔎 System Architecture
![image](https://github.com/user-attachments/assets/6aeb0c9b-e520-4f12-81cd-01c454434bdf)


 ### 📑 Co-working Tool
 ![swagger](https://img.shields.io/badge/swagger-85EA2D.svg?style=flat-square&logo=swagger&logoColor=white)
![Notion](https://img.shields.io/badge/Notion-%23000000.svg?style=flat-square&logo=notion&logoColor=white)


## 👶 Authors  
|          FE          |          BE          |          BE          |          BE          |            
| :------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------: |  :---------------------------------------------------------------------------------------: |  :---------------------------------------------------------------------------------------: | 
| <img src="https://avatars.githubusercontent.com/u/80393332?v=4" width=150px alt="성나영"/> | <img src="https://avatars.githubusercontent.com/u/87802191?v=4" width=150px alt="손시연"/> | <img src="https://avatars.githubusercontent.com/u/150361814?v=4" width=150px alt="손영웅"/> |  <img src="https://avatars.githubusercontent.com/u/147161502?v=4" width=150px alt="이상은"/> | 
|          [성나영](https://github.com/sna0e)          |          [손시연](https://github.com/siyeonSon)          |          [손영웅](https://github.com/handher0)          |          [이상은](https://github.com/KkomSang)          |
