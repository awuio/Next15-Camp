# --- Build stage ---
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

RUN npx prisma generate
# RUN npm run build

# --- Production run stage ---
FROM node:20-alpine

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app ./

RUN npx prisma generate && npx prisma migrate deploy

EXPOSE 3000
CMD ["npm", "dev"]
