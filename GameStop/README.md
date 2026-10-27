# GameStop

App iOS de loja de jogos em SwiftUI.

## Funcionalidades
- Login com sessão salva no Keychain
- Catálogo de jogos vindo de uma API (mockapi.io) e cadastro de novos jogos
- Carrinho com checkout e lista de desejos por usuário, persistidos com Core Data
- Tema claro/escuro e splash screen

## Arquitetura
MVVM com repositórios atrás de protocolos (`RemoteProtocol`, `CartProtocol`), permitindo injetar mocks nos testes.

```
GameStop/
├── App/            ponto de entrada
├── Core/           stack do Core Data, Keychain, tema
├── Models/         Game, CartItem
├── Repositories/   remoto, carrinho, wishlist
├── ViewModels/     Auth, Game, Cart, AddGame, GameCard
└── Views/          telas SwiftUI
```

## Testes
`GameStopTests` (unitários, com mocks) e `GameStopUITests`. Rode com ⌘U.

## Observações
- A autenticação é **apenas demonstrativa**, com usuários fixos no código: `admin/admin123`, `joao/joao123`, `maria/maria123`.
- A API é um mock público e pode ficar indisponível; nesse caso o catálogo não carrega.
