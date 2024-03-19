# Banco Digio - FCamara

## Sobre o projeto

- O projeto foi desenvolvido na arquitetura MVVM utilizando-se somente de ViewCode. A arquitetura escolhida e a forma como o projeto foi desenvolvido comporta o possível crescimento do aplicativo para outras telas e áreas sem grandes dificuldades e adaptações.

- Para buildar, basta abrir o projeto no Xcode 13+ e rodar em um dispositivo iOS 12+.

- Foi utilizado URLSessions + Codable para as requests realizadas no projeto, tanto para recuperar os dados do JSON disponibilizado quando para as imagens dos Banners.

- Não foram utilizadas bibliotecas externas para o desenvolvimento.

## Detalhamento das classes

#### HomePageWorker
- Fetches the JSON with all the information needed to build the HomePage

#### HomePageViewModel
- Calls HomePageWorker and builds HomePageDataStore
- Builds HomeViewConfiguration to configure the view with the images

#### HomePageView
- Builds the views (UILabels and BannerViews) with their respective constraints

#### BannerView
- Downloads the images from URLs
- Builds the banners


## Dificuldades técnicas

- O projeto foi desenvolvido em um Macbook Air, i5 de 2014.
- Nessas condições e considerando o prazo para entrega do projeto, não foi possível:
  - Desenvolver a tela de detalhe do produto, porém o caminho que seria realizado está descrito no código por meio de comentários (//TODO)
  - Entrar em detalhes no layout e funcionamento do app.
