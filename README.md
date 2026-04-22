# Definindo o conteúdo do README em Markdown
readme_content = """# MiniLink

O MiniLink é um aplicativo iOS de encurtamento de URLs desenvolvido com SwiftUI. Ele permite que os usuários insiram uma URL longa, gerem uma versão curta através de um serviço de backend e visualizem o histórico de links recentes.

---

## Como Executar o Projeto

1.  Abra o arquivo `MiniLink.xcodeproj`.
2.  Selecione um simulador (ex: iPhone 15 ou superior).
3.  Execute o app utilizando o atalho `⌘R`.

**Para rodar os testes:**
* Atalho: `⌘U` (executa testes unitários, de snapshot e de UI).

---

## Arquitetura

O projeto utiliza a arquitetura **MVVM (Model-View-ViewModel)** com uma camada de **Repository** e o padrão **Factory (Composition Root)** para injeção de dependências.

### Estrutura de Pastas

MiniLink/
├── App/                → Ponto de entrada e composição de dependências
├── DesignSystem/       → Tokens de design (Espaçamento, Raio, Cores)
├── Features/
│   └── LinkShortener/  → View, ViewModel (State/Action), Factory
├── Models/             → Objetos de domínio e modelos de visualização
├── Network/
│   ├── Core/           → Protocolo NetworkClient, implementação padrão e endpoints
│   ├── Endpoints/      → Definições específicas de API (ex: ShorteningLinkEndpoint)
│   └── Models/         → Payloads de Requisição/Resposta (Codable)
├── Repository/         → Protocolos e implementações (LinkShorteningRepository)
└── Resources/          → Strings localizadas e assets

### Principais Decisões Técnicas

* **Fluxo de Dados Unidirecional (UDF):**
    A ViewModel expõe uma `State` struct e recebe `Action` enums via uma função `send(_:)`. Isso garante transições de estado previsíveis e facilita drasticamente a depuração e os testes.
* **Networking Orientado a Protocolos:**
    O `NetworkClient` é definido como um protocolo, permitindo que diferentes implementações (ex: produção vs. clientes de mock para testes) sejam injetadas sem a necessidade de compilação condicional.
* **Padrão Factory (Composition Root):**
    A `AppFactory` é responsável por montar as dependências (cliente de rede → repositório → view model → view). Isso centraliza a configuração e melhora a manutenibilidade do código.
* **Abstração de Repositório:**
    O `LinkShorteningRepositoryProtocol` desacopla a ViewModel de detalhes de implementação de rede e mapeia as respostas brutas da API em modelos prontos para a camada de visualização.

---

## Design System

Introduzi um Design System leve para garantir a consistência da interface sem excesso de engenharia. Ele inclui tokens reutilizáveis para:
* Espaçamento (Spacings)
* Cores (Colors)
* Arredondamento (Corner Radius)

---

## Estratégia de Testes

### Testes Unitários (`MiniLinkTests`)
Cobre o comportamento da ViewModel, Repository e NetworkClient utilizando o novo framework **Swift Testing**.

### Testes de Snapshot (`MiniLinkSnapshotTests`)
Garante a integridade visual através da biblioteca `SnapshotTesting`. Os testes cobrem diversos estados da UI:
* Estado vazio, carregamento (loading) e erros.
* Listagens com um ou múltiplos itens.
* Variantes de Modo Claro (Light) e Escuro (Dark).
* Suporte a tamanhos de tela compactos.

### Testes de UI (`MiniLinkUITests`)
Testes de ponta a ponta (E2E) que validam os fluxos do usuário. Utilizo um cliente de rede dedicado para testes, injetado via argumentos de inicialização (`launchArguments`), garantindo que os testes de UI sejam herméticos e não dependam do backend real.

---

## Decisões de Engenharia e Trade-offs

Ao projetar o MiniLink, priorizei a escalabilidade e a manutenibilidade, tomando as seguintes decisões:

* **Abstração vs. Bibliotecas Externas:** Optei por construir uma camada de rede leve e nativa em vez de utilizar frameworks de terceiros (como Alamofire). Isso reduz o tamanho do binário, acelera o tempo de compilação e evita dependências desnecessárias em um ambiente de grande escala.
* **Simplicidade Visual:** A UI é intencionalmente minimalista, focando na aplicação correta dos tokens de Design System e na robustez da arquitetura, uma vez que o critério principal é a qualidade do código e engenharia.
* **In-Memory Storage:** Para atender aos requisitos de simplicidade do exercício, os dados são mantidos em memória. A persistência foi omitida propositalmente para manter o escopo focado na arquitetura e testes.

---

## Reflexões e Melhorias Futuras

Considerando um cenário de evolução contínua (como um produto real em produção):

1.  **Persistência de Dados:** Implementaria uma camada de persistência local utilizando **SwiftData** ou CoreData, garantindo que o histórico do usuário estivesse disponível offline.
2.  **Monitoramento e Observabilidade:** Adicionaria logs estruturados e integração com ferramentas de analytics (ex: Amplitude/Firebase) para monitorar taxas de erro e performance da rede.
3.  **Modularização:** Caso o projeto crescesse, o próximo passo seria mover as camadas de `Network` e `DesignSystem` para frameworks independentes (Swift Packages), facilitando o reuso em outros apps da companhia.

---

## Requisitos

* Xcode 15+
* iOS 17+
* Swift 6
"""