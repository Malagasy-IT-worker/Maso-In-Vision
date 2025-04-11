import cv2
import numpy as np
import re

def preprocess_plate(plate_img):
    gray = cv2.cvtColor(plate_img, cv2.COLOR_RGB2GRAY)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    enhanced = clahe.apply(gray)
    denoised = cv2.fastNlMeansDenoising(enhanced, h=10)
    _, thresh = cv2.threshold(denoised, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    return thresh

def validate_plate(text):
    cleaned = re.sub(r'[^A-Z0-9]', '', text.upper())
    patterns = [
        r'^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$',  # Format Français
        r'^[A-Z]{3}\d{3}$',               # Format Allemand
        r'^\d{2}-[A-Z]{3}-\d{2}$'         # Format Néerlandais
    ]
    return any(re.match(p, cleaned) for p in patterns)