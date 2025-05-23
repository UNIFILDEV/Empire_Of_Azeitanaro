# [Empire_Of_Azeitanaro](https://64.181.178.127)


### Godot para Navegador Web
🌐 Portfólio
[Olive Studios Portfolio](https://sites.google.com/edu.unifil.br/olive-studios?usp=sharing)

---

## 🌟 Recursos do Jogo
- **Desenvolvido em Godot Engine 4.x**
- **Compatível com navegadores modernos** (Chrome, Firefox, Edge, etc.)
- Funciona offline após o carregamento
- Exportado para **HTML5/WebAssembly**

---

# 🚀 Como Fazer o Deploy do Jogo Godot na Oracle Cloud com NGINX

## Pré-requisitos
- Conta na **Oracle Cloud**.
- Instância criada no serviço **Compute Instance (VM)** com sistema operacional Linux (ex: Ubuntu).
- Porta **80** liberada no **Security List** da sua VCN.
- Acesso via SSH à instância.


### 1. Exportar o Jogo
- No **Godot Engine**, configure a exportação para **HTML5**.
- Gere os arquivos:  
  - `index.html`  
  - `game.wasm`  
  - `game.js`  
  - `game.pck`


### 2. Conectar na Instância
Conecte-se via SSH com o comando:

```bash
ssh -i caminho/para/sua-chave.pem ubuntu@IP_DA_INSTANCIA
```


### 3. Instalar o NGINX
Execute:

```bash
sudo apt update
sudo apt install nginx -y
```

### 4. Enviar os Arquivos do Jogo
Do seu computador, envie os arquivos usando `scp`:

```bash
scp -i caminho/para/sua-chave.pem index.html game.* ubuntu@IP_DA_INSTANCIA:/tmp
```

Depois, mova para a pasta pública do NGINX:

```bash
sudo mv /tmp/index.html /var/www/html/
sudo mv /tmp/game.* /var/www/html/
```

### 5. Verificar Permissões

```bash
sudo chown www-data:www-data /var/www/html/*
sudo chmod 644 /var/www/html/*
```

### 6. Reiniciar o NGINX

```bash
sudo systemctl restart nginx
```

### 7. Testar no Navegador

Abra o navegador e acesse:

```
http://IP_DA_INSTANCIA
```

---

## 🎮 Jogar o Jogo Localmente

1. **Pré-requisitos:**
   - Navegador moderno com suporte a WebAssembly.
   - Um servidor HTTP simples (necessário para evitar problemas de segurança ao carregar arquivos locais).

2. **Iniciar o Servidor Local:**
   Execute um dos seguintes comandos no terminal para rodar um servidor HTTP local:
   - Python 3:
     ```bash
     python3 -m http.server
     ```
   - Node.js:
     ```bash
     npx http-server
     ```
   - Outros servidores, como `Live Server` (extensão do VSCode), também funcionam.

3. **Acessar o Jogo:**
   - Abra o navegador e acesse: `http://localhost:8000` (ou a porta configurada pelo servidor).

---

## 📄 Licença
Este projeto está licenciado sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais informações.

