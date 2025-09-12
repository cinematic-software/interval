FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma

ENV PRISMA_SKIP_POSTINSTALL_GENERATE=1

RUN corepack enable pnpm && pnpm install --frozen-lockfile

COPY . .

RUN pnpm exec prisma generate

RUN pnpm build

FROM node:20-bookworm-slim AS runner

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/email-templates ./email-templates
COPY --from=builder /app/public ./public

CMD [ "node", "dist/src/entry.js", "start" ]