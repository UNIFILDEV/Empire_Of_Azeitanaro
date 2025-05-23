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

## 🚀 Como Fazer o Deploy no Oracle Cloud

### Pré-requisitos
- Conta na **Oracle Cloud**.
- Familiaridade com o serviço **Object Storage** ou **Compute Instance** (VM).

### Passo a Passo
1. **Exportar o Jogo:**
   - No **Godot Engine**, configure a exportação para **HTML5**.
   - Gere os arquivos necessários: `index.html`, `game.wasm`, `game.js`, `game.pck`.

2. **Configurar o Bucket no Object Storage:**
   - Acesse o painel da **Oracle Cloud** e crie um **Bucket público** no serviço **Object Storage**.
   - Faça o upload dos arquivos exportados (`index.html`, `game.wasm`, etc.) para o bucket.

3. **Configurar o Ponto de Entrada:**
   - No Bucket, configure o **index.html** como o arquivo padrão para requisições.

4. **Testar o Jogo:**
   - Acesse a URL pública gerada pelo bucket no navegador.
   - O jogo deve carregar e funcionar corretamente.

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

