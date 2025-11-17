// server.js (ESM + Express 5 대응)
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
const PORT = process.env.PORT || 3000;

// __dirname 대체 (ESM)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// dist 정적 파일 경로
const distPath = path.join(__dirname, 'dist');

// 정적 파일 서빙
app.use(express.static(distPath));

// ✅ React SPA 라우팅을 위한 catch-all 라우트
//    * 는 반드시 "이름"을 가져야 함 → /*splat 사용
app.get('/*splat', (req, res) => {
  res.sendFile(path.join(distPath, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
