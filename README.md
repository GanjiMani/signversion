# SignVision - Production-Ready Traffic Sign Recognition System

A production-ready, end-to-end traffic sign recognition system for ADAS (Advanced Driver Assistance Systems) using a hybrid deep learning architecture combining YOLOv8 and Faster R-CNN.

## Features

- **Hybrid Deep Learning Architecture**: YOLOv8 + Faster R-CNN for robust detection
- **Weather-Robust Performance**: Advanced preprocessing for rain, fog, glare, and low light conditions
- **Real-Time Detection**: Process video streams (webcam or video file) in real-time
- **Intelligent Decision Fusion**: Combines predictions from both models for improved accuracy
- **Real-Time Audio Alerts**: TTS integration for voice announcements
- **Production-Grade Dashboard**: Clean UI with live video, statistics, and detection history
- **API Key Authentication**: Secure mutating endpoints
- **Structured Logging**: JSON logs with request tracking
- **Data Retention**: Configurable automatic cleanup
- **Docker Support**: Full containerization for easy deployment

## Tech Stack

### Backend
- FastAPI with structured error handling
- SQLAlchemy (sync) + MySQL (pymysql)
- PyTorch with GPU/CPU selection
- Ultralytics YOLOv8
- TorchVision Faster R-CNN
- OpenCV
- Albumentations
- pyttsx3
- pydantic-settings for configuration

### Frontend
- React
- Vite
- JavaScript
- TailwindCSS
- Responsive design (1366×768, 1920×1080)

## Prerequisites

- Python 3.11+
- Node.js 18+
- MySQL 8.0+ (or use Docker Compose)
- Webcam (optional, for live detection)
- GPU (optional, for faster inference)

## Quick Start with Docker Compose

The easiest way to run SignVision:

```bash
# 1. Create .env file in project root
cp signvision-backend/.env.example signvision-backend/.env
# Edit signvision-backend/.env with your settings

# 2. Start all services
docker-compose up -d

# 3. Access the application
# Frontend: http://localhost
# Backend API: http://localhost:8000
# API Docs: http://localhost:8000/docs
```

## Manual Installation

### 1. MySQL Setup

Create a MySQL database:

```sql
CREATE DATABASE signvision;
CREATE USER 'signvision'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON signvision.* TO 'signvision'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Backend Setup

```bash
# Create and activate virtual environment (Windows)
python -m venv signvision-backend/venv
signvision-backend\venv\Scripts\activate

# Or on Linux/Mac:
# source signvision-backend/venv/bin/activate

# Install dependencies
cd signvision-backend
pip install --upgrade pip
pip install -r requirements.txt
```

### 3. Backend Configuration

Create a `.env` file in `signvision-backend/`:

```env
# Database Configuration
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=signvision
MYSQL_PASSWORD=your_password_here
MYSQL_DB=signvision

# Security
SIGNVISION_API_KEY=your-secure-api-key-here
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# Model Configuration
YOLO_MODEL_SIZE=n
YOLO_WEIGHTS_PATH=
FASTER_RCNN_WEIGHTS_PATH=
SIGNVISION_DEVICE=cpu  # or 'cuda' for GPU

# Detection Thresholds
CONFIDENCE_THRESHOLD=0.5
IOU_THRESHOLD=0.5
FUSION_IOU_THRESHOLD=0.3

# Preprocessing Flags
ENABLE_DEHAZE=false
ENABLE_DEBLUR=false
ENABLE_CONTRAST=false

# TTS Configuration
TTS_ENABLED=true
TTS_DEBOUNCE_SECONDS=3.0

# Video Settings
DEFAULT_WEBCAM_INDEX=0
FRAME_WIDTH=640
FRAME_HEIGHT=480
FPS_TARGET=30

# Logging
LOG_LEVEL=INFO

# Data Retention
DATA_RETENTION_DAYS=30
```

### 4. Frontend Setup

```bash
cd signvision-frontend
npm install
```

## Running the Application

### Using Makefile

```bash
# Install backend dependencies
make backend-install

# Run backend (in one terminal)
make backend-run

# Install frontend dependencies
make frontend-install

# Run frontend (in another terminal)
make frontend-run
```

### Manual Commands

**Backend:**
```bash
cd signvision-backend
# Activate virtual environment
. venv/Scripts/activate  # Windows
# or
source venv/bin/activate  # Linux/Mac

# Run server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Frontend:**
```bash
cd signvision-frontend
npm run dev
```

### Using Docker

```bash
# Build images
make docker-build
# or
docker-compose build

# Start services
make docker-up
# or
docker-compose up -d

# View logs
make docker-logs
# or
docker-compose logs -f

# Stop services
make docker-down
# or
docker-compose down
```

## Usage

1. **Start the Backend**: The API will be available at `http://localhost:8000`
2. **Start the Frontend**: The UI will be available at `http://localhost:5173` (dev) or `http://localhost` (Docker)
3. **Set API Key**: Click "Set API Key" in the navbar and enter your API key from `.env`
4. **Configure Pipeline**: 
   - Select source type (webcam or video file)
   - Adjust confidence and IoU thresholds
   - Enable/disable preprocessing options
   - Click "Start Pipeline"
5. **View Results**:
   - Live video stream with bounding boxes
   - Real-time statistics (FPS, latency, device)
   - Detection history table
   - Audio alerts for detected signs

## API Endpoints

### Public Endpoints
- `GET /health` - Health check
- `GET /api/info` - API information
- `GET /pipeline/status` - Get pipeline status
- `GET /pipeline/stream/video` - MJPEG video stream
- `GET /detections/recent?limit=50` - Get recent detections
- `GET /detections/summary?session_id=1&minutes=60` - Get detection summary
- `GET /sessions/recent?limit=20` - Get recent sessions

### Protected Endpoints (Require API Key)
- `POST /pipeline/start` - Start inference pipeline
- `POST /pipeline/stop` - Stop inference pipeline

All protected endpoints require the `x-api-key` header.

## Data Maintenance

Purge old data to manage database size:

```bash
cd signvision-backend
python -m signvision.maintenance.purge_old_data --days 30

# Or purge only sessions
python -m signvision.maintenance.purge_old_data --sessions-only --days 30

# Or purge only detections
python -m signvision.maintenance.purge_old_data --detections-only --days 30
```

## Training Models

### YOLOv8 Training

```bash
cd signvision-backend/training
python train_yolov8.py configs/yolov8_config.yaml
```

### Faster R-CNN Training

```bash
cd signvision-backend/training
python train_faster_rcnn.py configs/faster_rcnn_config.yaml
```

**Note**: Training scripts are templates. You need to:
1. Prepare your dataset in the required format (YOLO for YOLOv8, COCO for Faster R-CNN)
2. Update the config files with your dataset paths
3. Implement custom dataset loaders if needed

## Testing

Run tests:

```bash
cd signvision-backend
pytest tests/ -v

# Or with Makefile
make test
```

## Hardware Requirements

### Minimum (CPU-only)
- CPU: 4+ cores
- RAM: 8GB
- Storage: 10GB free space
- Webcam: USB 2.0+

### Recommended (GPU)
- CPU: 6+ cores
- RAM: 16GB
- GPU: NVIDIA GPU with 4GB+ VRAM (CUDA compatible)
- Storage: 20GB free space
- Webcam: USB 3.0+

### Switching Between CPU and GPU

Set `SIGNVISION_DEVICE=cuda` in `.env` for GPU mode, or `SIGNVISION_DEVICE=cpu` for CPU mode. The system will automatically fall back to CPU if CUDA is not available.

## Project Structure

```
SignVision/
├── signvision-backend/
│   ├── main.py                 # FastAPI app entry point
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── .env.example
│   ├── signvision/
│   │   ├── config.py           # Configuration (pydantic-settings)
│   │   ├── middleware/          # API key authentication
│   │   ├── db/                 # Database models and CRUD
│   │   ├── models/             # ML models (YOLOv8, Faster R-CNN, fusion)
│   │   ├── preprocessing/      # Image enhancement and augmentation
│   │   ├── inference/          # Main inference pipeline
│   │   ├── tts/                # Text-to-speech service
│   │   ├── utils/              # Utilities (metrics, video, logging)
│   │   ├── api/                # FastAPI routes
│   │   └── maintenance/        # Data retention utilities
│   ├── tests/                  # Unit tests
│   └── training/               # Training scripts and configs
├── signvision-frontend/
│   ├── src/
│   │   ├── components/         # React components
│   │   ├── services/          # API client
│   │   ├── utils/             # Utilities (toast notifications)
│   │   └── App.jsx
│   ├── package.json
│   ├── Dockerfile
│   └── nginx.conf
├── docker-compose.yml
├── Makefile
└── README.md
```

## Troubleshooting

### Database Connection Issues
- Ensure MySQL is running
- Verify database credentials in `.env`
- Check that the database `signvision` exists
- For Docker, ensure MySQL container is healthy

### Model Loading Issues
- YOLOv8 will download pretrained weights automatically on first run
- Faster R-CNN uses torchvision pretrained weights
- For custom models, set `YOLO_WEIGHTS_PATH` and `FASTER_RCNN_WEIGHTS_PATH` in `.env`
- Check GPU availability: `python -c "import torch; print(torch.cuda.is_available())"`

### Webcam Not Working
- Check camera permissions
- Try different camera indices (0, 1, 2, etc.)
- Verify camera is not being used by another application
- On Linux, ensure user is in `video` group

### TTS Not Working
- On Linux, install `espeak`: `sudo apt-get install espeak espeak-data`
- On Windows, TTS should work out of the box
- On Mac, TTS should work out of the box
- Check `TTS_ENABLED=true` in `.env`

### API Key Authentication
- Set `SIGNVISION_API_KEY` in `.env`
- Use the same key in the frontend (stored in localStorage)
- For development, leave empty to disable auth (not recommended for production)

### Docker Issues
- Ensure Docker and Docker Compose are installed
- Check container logs: `docker-compose logs backend`
- Rebuild images if code changes: `docker-compose build --no-cache`

## Production Checklist

- [x] API key authentication for mutating endpoints
- [x] Structured JSON logging with request IDs
- [x] Comprehensive error handling with structured responses
- [x] Database indexes on frequently queried fields
- [x] Data retention and cleanup utilities
- [x] GPU/CPU device selection
- [x] Resource cleanup on pipeline stop
- [x] Rate limiting via FPS target
- [x] TTS debouncing
- [x] Health check endpoints
- [x] Docker containerization
- [x] Responsive frontend design
- [x] Toast notifications for user feedback
- [x] Environment-based configuration
- [x] CORS configuration
- [x] Production-ready error messages

## License

This project is provided as-is for educational and research purposes.

## Contributing

This is a production-ready template. Customize it for your specific use case and dataset.
