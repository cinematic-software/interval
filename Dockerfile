FROM node:20-bookworm-slim AS builder

# Install OpenSSL for Prisma generate
RUN apt-get update -y && \
    apt-get install -y openssl libssl3 ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
COPY prisma ./prisma

ENV PRISMA_SKIP_POSTINSTALL_GENERATE=1

RUN corepack enable pnpm && pnpm install --frozen-lockfile

COPY . .

RUN pnpm exec prisma generate

RUN pnpm build

FROM node:20-bookworm-slim AS runner

# Install OpenSSL for Prisma runtime
RUN apt-get update -y && \
    apt-get install -y openssl libssl3 ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/email-templates ./email-templates
COPY --from=builder /app/public ./public

CMD [ "node", "dist/src/entry.js", "start" ]