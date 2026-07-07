# 🧠 Smart Cache System
### *Cache Sob Demanda — Limpeza Automática Inteligente*

<div align="center">
<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=4CAF50&center=true&vCenter=true&width=600&lines=SMART_CACHE+ACTIVE;1.+Limpando+caches+automaticamente;2.+Restore+sob+demanda;3.+Sem+1.6GB+ocupado+a+toa;4.+Seu+terminal+mais+leve;5.+Auto-detecta+projeto;6.+NPM/Cargo/Gradle;7.+CACHE_CLEAN_EXECUTED_[OK];8.+Espaco+liberado;9.+BUILD_WILL_DOWNLOAD_DEPS;10.+SYSTEM_READY" alt="Typing SVG" />
</div>

---

## 🧠 O Problema

Caches de dependências (`.npm`, `.gradle`, `.cargo`) ocupam **1.6 GB+** mesmo quando não usados.

## ⚡ A Solução

Limpeza automática no startup + download sob demanda quando você precisa compilar.

---

## 🚀 Como Funciona

### 1. **Auto-Limpeza no Startup**
Toda vez que abrir o Termux, o sistema:
- Detecta caches grandes
- Remove automaticamente
- Reporta espaço liberado

### 2. **Restore Transparente**
Ao invocar comandos em projetos:
```bash
$ cd meu-projeto-node
$ npm run build
📦 NPM cache missing - installing deps...
[restaurando automaticamente]
```

### 3. **Detecta Tipo de Projeto**
| Arquivo | Tipo | Ação |
|---------|------|------|
| `Cargo.toml` | Rust | `cargo fetch` |
| `package.json` | Node | `npm install` |
| `build.gradle` | Android | `gradle deps` |

---

## 🛠️ Instalação

```bash
# Clone no seu diretório de scripts
cd ~
mkdir -p .local/bin
curl -o ~/.local/bin/smart-cache.sh <URL_DO_REPO>/raw/main/smart-cache.sh
chmod +x ~/.local/bin/smart-cache.sh

# Adicione ao .bashrc
echo 'source "$HOME/.local/bin/smart-cache.sh"' >> ~/.bashrc
source ~/.bashrc
```

---

## 📊 Comandos

| Comando | Descrição |
|---------|-----------|
| `cache-status` | Mostra status dos caches |
| `cache-clean` | Limpa todos os caches manualmente |

---

## 🔧 Configuração

Para **desativar** limpeza automática no startup:
```bash
# No ~/.local/bin/smart-cache.sh
AUTO_CLEAN_ON_START=0
```

---

## 👨‍💻 Créditos

**Lead Architect:** [Paçoca (@opassoca)](https://github.com/opassoca)
<sub>Otimizado com precisão cirúrgica via **Qwen3.5-397B-a17b**</sub>

---

## 📄 Licença

MIT — Use em produção sem medo (mas faça backup 😅)