# 🧠 Smart Cache System
### *Cache Sob Demanda — Limpeza Automática Inteligente*

<div align="center">
<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=4CAF50&center=true&vCenter=true&width=600&lines=SMART_CACHE+ACTIVE;1.+Limpando+caches+automaticamente;2.+Restore+sob+demanda;3.+Libera+GBs+de+espaco;4.+Seu+terminal+mais+leve;5.+Auto-detecta+projeto;6.+NPM/Cargo/Gradle;7.+CACHE_CLEAN_EXECUTED_[OK];8.+Espaco+liberado;9.+BUILD_WILL_DOWNLOAD_DEPS;10.+SYSTEM_READY" alt="Typing SVG" />
</div>

---

## 🧠 O Problema

Caches de dependências (`.npm`, `.gradle`, `.cargo`) podem ocupar **vários gigabytes** mesmo quando não usados.

Exemplos típicos:
- `.npm/` → 300-500 MB
- `.gradle/` → 500 MB - 2 GB
- `.cargo/` → 200 MB - 1 GB

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

### Opção 1: Instalador Automático (Recomendado)

```bash
# Via curl (instala e configura tudo)
curl -fsSL https://raw.githubusercontent.com/opassoca/smart-cache-system/master/install.sh | bash

# Ou via git
git clone https://github.com/opassoca/smart-cache-system.git
cd smart-cache-system
./install.sh
```

### Opção 2: Manual

```bash
# Clone no seu diretório de scripts
cd ~
mkdir -p .local/bin

# Baixe os scripts
curl -o ~/.local/bin/smart-cache.sh \
    https://raw.githubusercontent.com/opassoca/smart-cache-system/master/smart-cache.sh
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