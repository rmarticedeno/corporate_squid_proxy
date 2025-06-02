FROM nginx:alpine3.17

RUN apk add python3

WORKDIR /app

COPY nginx/generate_pac.py squid/allowed_hostnames ./

RUN chmod +x generate_pac.py && ./generate_pac.py