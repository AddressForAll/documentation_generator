# documentation_generator
&nbsp; *Source-code of the documentartion converter,<br/>&nbsp; from Markdown files of all gits to static pretty HTML. Using mkdocs.*

*Bash script* para gerar a documentação de repositórios git de quatro domínios:
* itgs.org.br
* osm.codes
* digital-guard.org
* addressforall.org

São necessários `mkdocs` e `mkdocs-material` instalados

Para executar: `bash gera_docs.bash`

Lista de repositórios para gerar documentação devem estar no arquivo: `lista_git`. Um repositório por linha.

Referência para programação em bash: "Pequeno Manual do Programador GNU Bash",  https://odysee.com/@debxp:9/pmpgb-ed1-free:f

Estrutura da pasta utilizada para sobrescrever partes do tema mkdocs 'material'
```
└── overrides
    ├── assets
    │   ├── images
    │   │   ├── a4a.png
    │   │   ├── address_for_all-01-colorful.ico.png
    │   │   ├── digitalguard.png
    │   │   ├── índice.png
    │   │   ├── logo.ea6edf06.png
    │   │   └── osmcodes.png
    │   ├── javascripts
    │   └── stylesheets
    │       └── extra.css
    ├── main.html
    └── partials
        ├── footer.html
        └── header.html
```

Exemplo de estrutura gerada pelo script:
```
└── all_docs
    ├── docs.addressforall.org
    │   ├── index.html
    │   ├── suporte
    │   │   ├── en
    │   │   └── pt
    │   └── WS
    └── docs.osm.codes
        ├── BR_IBGE
        ├── BR_new
        └── index.html
```
Exemplos do conteúdo do arquivo contendo os repositórios para os quais se deve gerar documentação, já em operação:
* http://docs.AddressForAll/suporte
* http://docs.AddressForAll/WS
* http://docs.osm-codes/BR_IBGE
* http://docs.osm-codes/BR_new