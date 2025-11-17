# 빌드 스테이지: Vite로 React 앱 빌드
FROM node:20-alpine AS builder
WORKDIR /app
# 의존성 설치를 위한 package.json, package-lock.json만 먼저 복사
COPY package*.json ./
# 의존성 설치 (dev 포함, 빌드에 vite 필요)
RUN npm ci
# 나머지 소스 전체 복사
COPY . .
# 빌드 (dist 폴더 생성)
RUN npm run build
# 런타임 스테이지: Express로 dist 서빙
FROM node:20-alpine
WORKDIR /app
# 런타임에 필요한 패키지만 설치 (devDependencies 제외)
COPY package*.json ./
RUN npm ci --omit=dev
# 빌드 결과(dist)와 서버 파일(server.js)만 복사
COPY --from=builder /app/dist ./dist
COPY server.js .
ENV PORT=3000
EXPOSE 3000
CMD ["node", "server.js"]

