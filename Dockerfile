FROM rust:1.77.2 AS builder

RUN rustup target add wasm32-unknown-unknown
RUN cargo install dioxus-cli@0.5.4

WORKDIR /usr/src/dioxus-fullstack-docker-example

COPY . ./
RUN dx build --release --features web
RUN cargo build --release --features server

FROM debian:bookworm-slim

COPY --from=builder /usr/src/dioxus-fullstack-docker-example/dist /usr/local/bin/dist
COPY --from=builder /usr/src/dioxus-fullstack-docker-example/target/release/dioxus-fullstack-docker-example /usr/local/bin/dist

EXPOSE 8080

WORKDIR /usr/local/bin/

CMD ["./dist/dioxus-fullstack-docker-example"]
