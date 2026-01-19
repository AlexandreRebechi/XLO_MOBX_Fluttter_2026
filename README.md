# XLO MobX App

Aplicativo mobile desenvolvido em **Flutter**, com arquitetura reativa baseada em **MobX** e **GetIt**, integração com **Firebase**, **Parse Server** e notificações via **OneSignal**. O projeto segue boas práticas de separação de responsabilidades, repositórios e stores para gerenciamento de estado.

## Sumário

* Visão Geral
* Tecnologias e Dependências
* Arquitetura
* Estrutura de Pastas
* Configuração do Ambiente
* Instalação e Execução
* Serviços Integrados
* Gerenciamento de Estado
* Padrões e Boas Práticas
* Build
* Licença

## Visão Geral

O app implementa funcionalidades de autenticação, anúncios, chat em tempo real e notificações push. A comunicação com backend utiliza **Firebase** para serviços essenciais e **Parse Server** para dados e LiveQuery.

## Tecnologias e Dependências

Principais dependências utilizadas no projeto:

### Core

* **flutter**: SDK principal para desenvolvimento mobile multiplataforma
* **dart**: linguagem base do projeto

### Gerenciamento de Estado e Injeção

* **mobx**: gerenciamento de estado reativo
* **flutter_mobx**: bindings do MobX para Flutter
* **get_it**: injeção de dependências

### Backend e Dados

* **firebase_core**: inicialização do Firebase
* **firebase_auth**: autenticação de usuários
* **cloud_firestore**: banco de dados NoSQL em tempo real
* **parse_server_sdk_flutter**: integração com Parse Server e LiveQuery

### Notificações

* **onesignal_flutter**: notificações push

### Utilidades

* **intl**: formatação de datas e números
* **collection**: helpers para listas e coleções

## Arquitetura

O projeto adota uma arquitetura baseada em **Stores + Repositories**:

* **Stores (MobX)**: controlam o estado e regras de negócio reativas
* **Repositories**: encapsulam acesso a dados (Firebase/Parse)
* **Models**: representam as entidades da aplicação
* **UI (Widgets)**: consomem os stores via `Observer`

## Estrutura de Pastas

```
lib/
 ├─ components/        # Widgets reutilizáveis
 ├─ helpers/           # Extensões e utilitários
 ├─ models/            # Modelos de dados
 ├─ repositories/      # Acesso a dados e serviços externos
 ├─ screens/           # Telas do aplicativo
 ├─ stores/            # Stores MobX
 └─ main.dart          # Ponto de entrada
```

## Configuração do Ambiente

Pré-requisitos:

* Flutter SDK instalado
* Android Studio ou VS Code
* Conta Firebase configurada
* Instância do Parse Server
* Conta OneSignal

## Instalação e Execução

```bash
flutter pub get
flutter run
```

Para gerar os arquivos do MobX:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Serviços Integrados

### Firebase

* Inicialização no `main.dart`
* Autenticação e Firestore configurados por ambiente
* Onde o chat está funcionando 

### Parse Server

* Como projeto futuro sera usado LiveQuery para o chat
* Repositórios encapsulam queries e subscriptions

### OneSignal

* Responsável por notificações push
* Inicializado durante o bootstrap do app

## Gerenciamento de Estado

O estado é observado via **MobX**, utilizando:

* `@observable` para estados
* `@action` para mutações
* `Observer` para atualização reativa da UI

## Padrões e Boas Práticas

* Separação clara entre UI, estado e dados
* Injeção de dependências com GetIt
* Código modular e testável
* Uso de null-safety

## Build

Android:

```bash
flutter build apk --release
```

## Licença

Projeto de uso educacional e experimental.
