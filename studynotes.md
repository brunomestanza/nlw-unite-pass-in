# Etapas na criação de DevOps
## 1. Analisar a aplicação e entender o fluxo feito para rodar a aplicação e seus requisitos

É necessário entender as etapas para rodar a aplicação antes de fazermos a conterização dela.

**No caso dessa aplicação utilizamos o seguinte fluxo em localhost:**

- pnpm install
  - Instalação das dependencias da aplicação
- pnpm prisma generate
  - Gerar tabela do prisma utilizando as migrations
- pnpm dev
  - Iniciar a aplicação em si, em ambiente de desenvolvimento

**Para rodar a aplicação em ambiente produtivo, serão necessários alguns outros passos mas a ideia se mantém:**

- pnpm install
  - Instalaçào das dependencias da aplicação (o pnpm deve ser instalado antes dessa etapa)
- pnpm build e prone
  - Instalar as dependencias de produção e remover as devDependencies
- pnpm start
  - Rodar a aplicação usando a build feita anteriormente