from ultralytics import YOLO

model = YOLO("./models/yolov11x.pt") 

model.predict(source=0, show=True) 

results.show()
