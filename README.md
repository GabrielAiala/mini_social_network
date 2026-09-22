# Mini Rede Social — Projeto de Estudo

Uma implementação simplificada de uma rede social (estilo Twitter/Instagram), construída para estudar modelagem de dados em grafo, queries SQL complexas e problemas reais de performance em sistemas com feed social.

## Sobre o projeto

O produto em si é simples: usuários se cadastram, seguem uns aos outros, publicam posts, curtem e comentam. O foco do projeto não está nas funcionalidades básicas, e sim em como o sistema decide **o que mostrar e em que ordem** — os mesmos desafios enfrentados por redes sociais reais em escala.

## Funcionalidades

- Cadastro de usuários e relação de "seguir"
- Publicação de posts, curtidas e comentários
- **Feed cronológico**: timeline simples ordenada por data
- **Feed por relevância**: ranking de posts combinando engajamento (curtidas/comentários) e recência, com decaimento ao longo do tempo — inspirado no algoritmo de ranking do Hacker News
- **Sugestão de conexões**: recomendação de "pessoas que você talvez conheça", baseada em conexões em comum (amigos de amigos)
- **Paginação por cursor**: navegação estável no feed mesmo quando a ordenação muda dinamicamente (evita duplicar ou pular posts entre páginas)

## Motivação técnica

Este projeto foi criado para praticar:

- Modelagem de grafos em banco relacional (relação de "seguir", conexões em comum)
- Window functions e CTEs para cálculo de métricas agregadas
- Estratégias de paginação além do `OFFSET`/`LIMIT` tradicional
- Trade-offs entre calcular o feed em tempo real vs. pré-computar (feed materializado)
- Otimização de queries com `EXPLAIN ANALYZE` e indexação adequada

## Stack

- Backend: Ruby on Rails + PostgreSQL
- Frontend: React + TypeScript

## Status

Em desenvolvimento — projeto pessoal de estudo.