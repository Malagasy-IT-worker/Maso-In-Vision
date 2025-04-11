from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import cv2
import numpy as np
from ultralytics import YOLO
import easyocr
from pydantic import BaseModel
import base64

app = FastAPI()

class DetectionResult(BaseModel):
    vehicle_type: str
    license_plate: str
    confidence: float
    image: str  # Base64 encoded image

# Modèles préchargés
vehicle_model = YOLO('../models/yolo/yolov8x.pt')
plate_model = YOLO('../models/license_plate/license_plate_detector.pt')
reader = easyocr.Reader(['en'])

def get_vehicle_type(class_id):
    vehicle_classes = {
        2: 'voiture',
        3: 'moto',
        5: 'bus',
        7: 'camion'
    }
    return vehicle_classes.get(class_id, 'véhicule inconnu')

async def process_image(file):
    image = np.frombuffer(await file.read(), np.uint8)
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)
    results = []
    
    # Détection des véhicules
    vehicles = vehicle_model.predict(image, classes=[2, 3, 5, 7], verbose=False)[0]
    
    for box in vehicles.boxes:
        vehicle_type = get_vehicle_type(int(box.cls))
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        
        # Détection plaque
        vehicle_roi = image[y1:y2, x1:x2]
        plates = plate_model.predict(vehicle_roi, verbose=False)[0]
        
        for plate in plates.boxes:
            px1, py1, px2, py2 = map(int, plate.xyxy[0])
            plate_img = vehicle_roi[py1:py2, px1:px2]
            
            # OCR
            ocr_result = reader.readtext(plate_img)
            if ocr_result:
                text = max(ocr_result, key=lambda x: x[2])[1]
                
                # Dessiner les résultats
                cv2.rectangle(image, (x1+px1, y1+py1), (x1+px2, y1+py2), (0,255,0), 2)
                cv2.putText(image, text, (x1+px1, y1+py1-10), 
                          cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,0,255), 2)
                
                # Encodage image
                _, buffer = cv2.imencode('.jpg', image)
                img_str = base64.b64encode(buffer).decode()
                
                results.append({
                    "vehicle_type": vehicle_type,
                    "license_plate": text,
                    "confidence": float(plate.conf),
                    "image": img_str
                })
    
    return results

@app.post("/detect")
async def detect_plate(file: UploadFile = File(...)):
    try:
        detections = await process_image(file)
        if not detections:
            return JSONResponse(content={"message": "Aucune plaque détectée"})
        
        return JSONResponse(content={
            "count": len(detections),
            "results": detections
        })
    
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"message": f"Erreur de traitement: {str(e)}"}
        )