# 💰 Finance App — Controle Financeiro Pessoal
### Flutter · Riverpod · SQLite · API de Notícias

---

## 📋 Sobre o Projeto
Aplicativo de controle financeiro pessoal desenvolvido em Flutter, implementando o **nível avançado** do exercício (até 16 pontos).

---

## 🏗️ Arquitetura (MVVM)

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart     # SQLite (sqflite)
│   └── theme/
│       └── app_theme.dart           # Material Design 3
├── models/
│   ├── user_model.dart              # Modelo de Usuário
│   ├── transaction_model.dart       # Modelo de Transação
│   └── news_model.dart              # Modelo de Notícia
├── providers/                       # ViewModel (Riverpod)
│   ├── auth_provider.dart           # Estado de Autenticação
│   ├── transaction_provider.dart    # Estado das Transações
│   └── news_provider.dart           # Estado das Notícias
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart        # Tela de Login
│   │   └── register_screen.dart    # Tela de Cadastro
│   ├── home/
│   │   ├── home_screen.dart         # Navegação principal
│   │   └── dashboard_tab.dart      # Dashboard + Gráfico
│   ├── transactions/
│   │   └── transactions_tab.dart   # Lista + CRUD
│   └── news/
│       └── news_tab.dart            # Feed de Notícias
├── widgets/
│   ├── transaction_sheet.dart      # BottomSheet CRUD
│   └── skeleton_loader.dart        # Skeleton screens
└── main.dart
```

---

## ✅ Funcionalidades Implementadas

### Básicas (6 pontos)
- [x] **CRUD Completo** — Adicionar, listar, editar e excluir transações
- [x] **Saldo Automático** — Dashboard atualiza em tempo real via Riverpod
- [x] **Categorias** — 5 categorias de receita, 8 de despesa
- [x] **Campos obrigatórios** — Título, Valor, Data, Tipo (Entrada/Saída)
- [x] **Persistência SQLite** — Dados salvos com `sqflite`, não se perdem ao fechar
- [x] **Riverpod** — Estado gerenciado reativamente com `StateNotifierProvider`
- [x] **Autenticação real** — Login + Cadastro com validação e senha criptografada (SHA-256)
- [x] **CRUD na própria tela** — Todas as ações via `BottomSheet` sem mudar de rota
- [x] **Validação com GlobalKey<FormState>** — Todos os formulários validados
- [x] **MVVM** — Models, ViewModels (Providers) e Views bem separados
- [x] **Material Design 3** — NavigationBar, Cards, Chips, etc.

### Avançadas (16 pontos)
- [x] **Riverpod** — `StateNotifierProvider` para Auth, Transações e Notícias
- [x] **Injeção de Dependência** — `DatabaseHelper.instance` (Singleton)
- [x] **SQLite** — Schema com FK, queries por usuário, CRUD completo
- [x] **API Externa** — Feed de notícias financeiras (GNews/NewsAPI)
- [x] **Skeleton Screens** — Shimmer enquanto dados carregam
- [x] **Animações** — `flutter_animate` em todas as telas
- [x] **Gráfico** — Pizza chart com `fl_chart` no Dashboard
- [x] **Tratamento de erros** — Erro de rede mostra artigos mock + aviso
- [x] **Swipe para deletar** — `Dismissible` com confirmação
- [x] **Pull to refresh** — `RefreshIndicator` nas listas
- [x] **Filtros** — Filtrar transações por tipo (Todas/Receitas/Despesas)

---

## 🚀 Como Executar no GitHub Codespaces

### 1. Abrir no Codespaces
```bash
# No repositório GitHub, clique em:
# Code > Codespaces > Create codespace on main
```

### 2. Instalar Flutter (se necessário)
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### 3. Instalar dependências
```bash
cd finance_app
flutter pub get
```

### 4. Executar no web (Codespaces)
```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```
> Acesse a porta 8080 no painel de "Ports" do Codespaces

### 5. (Opcional) Gerar APK
```bash
flutter build apk --release
# APK em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 Configurar API de Notícias (Opcional)

Para notícias reais, edite `lib/providers/news_provider.dart`:

**Opção A — NewsAPI.org (gratuito)**
1. Cadastre-se em [newsapi.org](https://newsapi.org) e obtenha uma chave
2. Substitua `SUA_CHAVE_NEWSAPI_AQUI` pela sua chave
3. Defina `_useGNews = false`

**Opção B — GNews.io (gratuito, 100 req/dia)**
1. Cadastre-se em [gnews.io](https://gnews.io) e obtenha uma chave
2. Substitua `GNEWS_KEY` pela sua chave
3. Defina `_useGNews = true`

> Sem chave, o app exibe artigos de exemplo ilustrativos.

---

## 📦 Dependências

| Pacote | Uso |
|--------|-----|
| `flutter_riverpod` | Gerenciamento de estado |
| `sqflite` | Banco de dados SQLite local |
| `crypto` | Hash SHA-256 das senhas |
| `http` | Consumo da API de notícias |
| `fl_chart` | Gráfico de pizza no Dashboard |
| `shimmer` | Skeleton screens |
| `flutter_animate` | Animações de transição |
| `google_fonts` | Tipografia (Inter) |
| `intl` | Formatação de moeda e data |

---

## 🎨 Telas

| Tela | Descrição |
|------|-----------|
| **Login** | E-mail + senha com validação completa |
| **Cadastro** | Nome, e-mail, senha e confirmação |
| **Dashboard** | Saldo, gráfico de distribuição, últimas transações |
| **Transações** | Lista completa com filtros e swipe to delete |
| **Notícias** | Feed de dicas e notícias financeiras |

---

## 👥 Grupo
_[Adicione os nomes dos integrantes aqui]_
