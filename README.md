# Camera Test Application

This repository contains a camera application with features for capturing photos, recording videos, and handling camera permissions. Below is an overview of the key libraries used, features, and known issues.

## Before running the project, please execute the following command:
`dart run build_runner build --delete-conflicting-outputs`

## Library Choices

- **Gallery Access**: The `image_picker` library was chosen for invoking the gallery. According to its documentation, `image_picker` uses the native PhotoPicker for gallery access, ensuring a seamless and platform-consistent user experience.
- **Media File Saving**: The `image_gallery_saver_plus` library was selected for saving media files. While there is no explicit documentation confirming that this library interacts directly with the Media Store, tests indicate that saving media files does not require additional app permissions, suggesting compatibility with the platform's media storage system.

## Features

### 1. Camera Permission Dialog on App Start

**Description**: Upon launching the application, a dialog prompts the user to grant camera permissions. This ensures the app can access the camera functionality immediately, providing a seamless user experience.

![camera_permission_dialog_c](https://github.com/user-attachments/assets/6dbcc701-5808-45ff-aa61-89a531b4da8a)

### 2. Persistent Permission Prompt on Denial

**Description**: If the user denies camera permissions multiple times, the application will repeatedly suggest opening the device settings to grant permissions. This prompt continues until the user grants the necessary permissions, ensuring the app remains usable.

![permission_denial_prompt](https://github.com/user-attachments/assets/166cc748-8636-4caa-825d-4ec1fb9303e9)

### 3. Camera Switching

**Description**: The application allows users to switch between the rear and front cameras seamlessly. 

![camera_switching](https://github.com/user-attachments/assets/8c2854ca-5679-4edc-aa99-8c8e28a0c7ac)

### 4. Take Photo

**Description**: Users can capture photos using the active camera (rear or front).

![take_photo](https://github.com/user-attachments/assets/4316bc81-0c0b-48a9-9e79-33f838be262a)

### 5. Video Recording

**Description**: The application supports video recording.

![video_recording](https://github.com/user-attachments/assets/5b2d2fcc-a433-484d-8d61-7fde4edd85ec)

### 6. Pick Overlay Image

**Description**: Users can select an overlay image to apply over their photos or videos, adding a customizable layer to their media.

![pick_overlay_image](https://github.com/user-attachments/assets/75952d2f-c7ea-40ca-90c3-4ac356e5b132)

### 7. Pause Video on Long Press

**Description**: The video recording feature includes the ability to pause recording by long-pressing the record button.

![pause_video_long_press](https://github.com/user-attachments/assets/251b3fba-36d9-4c22-b3cb-4831f6939c1e)

## Known Issues

- **Android Video Save Format**: Videos recorded on Android devices are saved with a `.temp` extension. The reason for this behavior is currently under investigation. As a temporary workaround, the `CameraRepositoryImpl` class includes a hardcoded MIME type to handle video saving.
