# UnitTestingDemo

App que lista usuários de uma API e serve de estudo de testes unitários com XCTest.

- `UsersViewModel` depende de um protocolo de repositório, então os testes injetam mocks.
- Cenários testados: sucesso, lista vazia e erro, no formato given/when/then.

Rode os testes com ⌘U.
