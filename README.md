# 💻 Sistema de Votação do CAESI  📩

![logo do caesi](https://github.com/caesiufcg/caesiufcg.github.io/blob/master/images/logo-vazado.png?raw=true)

O Centro Acadêmico de Ciência da Computação (CAESI) é o órgão de representação dos estudantes do curso de Ciência da Computação da UFCG. Este órgão é dirigido por um grupo de estudantes (a Diretoria) eleitos anualmente.

## 👨‍💻 O que é o sistema? 👩‍💻

Atualmente, as eleições do CAESI se dão de forma presencial e através de cédulas impressas. O nosso objetivo é implementar um sistema de votação para as eleições do CAESI mais moderno, seguro e eficiente.

## 🖇️ Funcionalidades 🖇️

O sistema tem dois atores: os administradores do sistema e o estudante. Os administradores cadastram login e senha, enquanto o cadastro dos estudantes é feito através de um arquivo csv contendo login e senha padrão: matricula e data de aniversário do estudante, respectivamente.

### Cabe ao administrador:
1. Cadastrar outros administradores
2. Editar informações de administradores
3. Remover outros administradores
4. Cadastrar estudantes
5. Desativar estudantes
6. Cadastrar chapas
7. Cadastrar estudante em chapa
8. Remover estudante da chapa
9. Editar informação das chapas
10. Remover chapas
11. Cadastrar votação
12. Encerrar votações

### Cabe ao estudante:
1. Votar
2. Editar a própria senha

### Outras funcionalidades do sistema:
1. Comparar eleições
2. Ver informações de uma eleição especifica
3. Listar histórico de eleições

## ⚠️ Pré-requisitos para usar o sistema ⚠️
Devem estar instalados na máquina:
- [GHC 8.10.7](https://www.haskell.org/ghc/): the Glasgow Haskell Compiler
- [cabal 3.6.2.0](https://cabal.readthedocs.io/): the Cabal installation tool for managing Haskell software
- [PostgreSQL](https://www.postgresql.org/)

Dependências isoladas do C que foram baixadas: 
```bash
    sudo apt-get install libgmp3-dev
    sudo apt install -y libpq-dev
```


## Usando o sistema funcional
```bash
    git clone https://github.com/emys-alb/votacao-caesi.git
    cd votacao-caesi/
    cd funcional/
    
    cabal build
    cabal run
```

Será apresentado o seguinte menu de atividades:

```python
Menu de atividades: 
 1 - Cadastra o primeiro admin
 2 - Cadastra novo administrador
 3 - Remove administrador
 4 - Edita senha do administrador
 5 - Cadastra estudantes
 6 - Edita senha do estudante
 7 - Desativa estudante
 8 - Cadastra votação
 9 - Cadastra chapa
 10 - Cadastra estudante em chapa
 11 - Remove estudante da chapa
 12 - Edita chapa
 13 - Remove chapa
 14 - Cadastra voto de estudante
 15 - Encerra votação
 16 - Lista dados da votação
 17 - Lista histórico de votações
 18 - Compara votações
 19 - Sair
```

O sistema precisa de pelo menos 1 administrador registrado para ter acesso a demais funcionalidades, para isso deve escolher a opção 1. Em seguida está livre para usar as demais funcionalidades apresentadas no menu de atividades.

### Para acessar o banco de dados 📂

Mantemos todas nossas informações em um banco de dados, é possivel acessá-lo remotamente com o seguinte comando:
```
psql -h "ec2-54-235-108-217.compute-1.amazonaws.com" -p 5432 -d "dbehln4jerq4b" -U "jzrhucvekfwaal"
Password for user jzrhucvekfwaal: fc13fbfff03b8b15a7186f8cabf894bcb3bacee463dd080a803690d72658217d
```