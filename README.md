---
Title: Sem título
Created_at: 2024-05-11 19:49
father_file: 
tags:
---
---

# OcoMon Dockerfile

Arquivo Dockerfile para montar uma imagem Docker com o OcoMon 5.0.

A imagem é montada sobre o Ubuntu 24.04 com:
- Apache
- PHP 8.3
- Mysql

O download do OcoMon 5.0 é realizado durante o build da imagem.

A criação do banco e importação da estrutura e dos dados é feita durante a inicialização do contêiner.


## Requisitos

É necessário que você tenha o Docker instalado em seu ambiente.

## Instruções

- Clone este repositório
```shell
git clone https://github.com/flaviorib-dev/ocomon-dockerfile.git
```


- No seu ambiente, a partir do diretório onde está o `Dockerfile`, monte a imagem:
```shell
docker build .
```

- Para rodar a imagem criada:
```shell
docker run -it -p 8080:80 <IMAGE_ID> /start_ocomon
```

- Pronto! Basta acessar o sistema diretamente em seu navegar na porta 8080:

```
http://localhost:8080
```

Usuário: admin
Senha: admin

