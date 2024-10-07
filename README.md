App Structure and Functionality
Key Files:
main.dart: The entry point of the app.
mainscreen.dart: This is the home page where image handling, classification logic, and other core functionalities are implemented.
App Flow:
Loading Screen >
Intro Screen >
Leaf Diagnosis Screen >
Monitoring Screen >
Ready Screen >
Main Screen
This is the flow of the app as the user navigates through it.

Main App Functionality:
Main Screen >
Recommendation Page >
Treatment Page
This is the core flow of the app where an image is classified, and treatment or remedies are recommended based on the classification.

Data and Localization:
recommendation_data.dart: Contains all the translated disease recommendations in English, Tagalog, and Cebuano.
Navigation Bar:
The navigation bar includes:
Main Screen
History Page
Feedback Page (currently not fully functional; an issue with the keyboard pushing the navigation bar when shown is still unresolved).
Notes on This Version:
This version ignores R8 optimizations due to dependency compatibility issues. As a result, the app is functional but not ready for uploading to the Play Store at this time.
