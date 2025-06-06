FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm cache clean --force

RUN npm config set registry https://registry.npmjs.org/

RUN npm install

COPY . .

RUN npm run build

# CMD ["npm", "start"]

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.env ./

RUN npm install --only=production

EXPOSE 3000

CMD ["npm", "start"]
