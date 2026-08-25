import os
import io
import numpy as np
from PIL import Image
import cv2
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from insightface.app import FaceAnalysis

# ── InsightFace 초기화 (최초 실행 시 buffalo_l 모델 자동 다운로드 ~500MB) ──
print("InsightFace 모델 초기화 중...")
face_app = FaceAnalysis(name='buffalo_l', providers=['CPUExecutionProvider'])
face_app.prepare(ctx_id=0, det_size=(640, 640))
print("모델 초기화 완료.")

# ── 앱 설정 ──────────────────────────────────────────────────────────────────
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],
    allow_methods=["*"],
    allow_headers=["*"],
)

FACE_DATA_DIR = "face_data"
REGISTER_DUP_THRESHOLD = 0.40  # 중복 등록 차단 (관대하게)
RECOGNIZE_THRESHOLD    = 0.45  # 로그인 인식 (엄격하게)

os.makedirs(FACE_DATA_DIR, exist_ok=True)


# ── 핵심 함수 ─────────────────────────────────────────────────────────────────
def extract_embedding(image_bytes: bytes):
    """
    이미지에서 InsightFace ArcFace 임베딩 추출.
    얼굴이 여러 개면 가장 큰 얼굴 선택. 없으면 None.
    반환: 512차원 L2 정규화 벡터
    """
    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img_bgr = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)
    faces = face_app.get(img_bgr)
    if not faces:
        return None
    face = max(faces, key=lambda f: (f.bbox[2] - f.bbox[0]) * (f.bbox[3] - f.bbox[1]))
    return face.normed_embedding  # 512차원, L2 정규화됨


def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    denom = np.linalg.norm(a) * np.linalg.norm(b)
    if denom == 0:
        return 0.0
    return float(np.dot(a, b) / denom)


# ── 엔드포인트 ────────────────────────────────────────────────────────────────
@app.get("/health")
def health():
    return {"status": "ok", "engine": "insightface-arcface"}


@app.post("/face/register")
async def register_face(
    member_id: str = Form(...),
    image: UploadFile = File(...)
):
    image_bytes = await image.read()
    embedding = extract_embedding(image_bytes)

    if embedding is None:
        raise HTTPException(status_code=400, detail="얼굴을 감지할 수 없습니다. 정면을 보고 다시 시도해주세요.")

    # 기존 등록된 얼굴과 중복 검사 (자기 자신 제외)
    for filename in os.listdir(FACE_DATA_DIR):
        if not filename.endswith(".npy"):
            continue
        existing_id = filename[:-4]
        if existing_id == member_id:
            continue
        stored = np.load(os.path.join(FACE_DATA_DIR, filename))
        if stored.shape != embedding.shape:
            continue
        if cosine_similarity(embedding, stored) >= REGISTER_DUP_THRESHOLD:
            raise HTTPException(status_code=409, detail="이미 다른 계정에 등록된 얼굴입니다.")

    np.save(os.path.join(FACE_DATA_DIR, f"{member_id}.npy"), embedding)
    return {"success": True, "message": "얼굴이 등록되었습니다."}


@app.get("/face/status/{member_id}")
async def face_status(member_id: str):
    registered = os.path.exists(os.path.join(FACE_DATA_DIR, f"{member_id}.npy"))
    return {"registered": registered}


@app.delete("/face/{member_id}")
async def delete_face(member_id: str):
    path = os.path.join(FACE_DATA_DIR, f"{member_id}.npy")
    if os.path.exists(path):
        os.remove(path)
    return {"success": True}


@app.post("/face/recognize")
async def recognize_face(image: UploadFile = File(...)):
    image_bytes = await image.read()
    unknown = extract_embedding(image_bytes)

    if unknown is None:
        raise HTTPException(status_code=400, detail="얼굴을 감지할 수 없습니다. 정면을 보고 다시 시도해주세요.")

    best_member_id = None
    best_similarity = -1.0

    for filename in os.listdir(FACE_DATA_DIR):
        if not filename.endswith(".npy"):
            continue
        member_id = filename[:-4]
        stored = np.load(os.path.join(FACE_DATA_DIR, filename))
        if stored.shape != unknown.shape:
            continue
        similarity = cosine_similarity(unknown, stored)
        if similarity > best_similarity:
            best_similarity = similarity
            best_member_id = member_id

    if best_member_id is None or best_similarity < RECOGNIZE_THRESHOLD:
        raise HTTPException(
            status_code=404,
            detail=f"일치하는 회원을 찾을 수 없습니다. (유사도: {best_similarity:.3f})"
        )

    return {
        "success": True,
        "memberId": best_member_id,
        "confidence": round(best_similarity, 3)
    }
