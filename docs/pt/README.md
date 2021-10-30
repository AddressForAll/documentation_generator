# documentation_generator
&nbsp; *Source-code of the documentartion converter,<br/>&nbsp; from Markdown files of all gits to static pretty HTML. Using mkdocs.*

*Bash script* para gerar a documentação de repositórios git de quatro organizações:
* itgs.org.br
* osm.codes
* digital-guard.org
* addressforall.org

Referência para programação em bash: [Pequeno Manual do Programador GNU Bash](https://odysee.com/@debxp:9/pmpgb-ed1-free:f)


## Ambiente de execução

Para viabilizar ambientes virtuais no python:

`sudo apt install python3-venv`

Criar o ambiente virtual:

```
mkdir abc
python3 -m venv abc
```

Para ativá-lo:

`source abc/bin/activate`

Para desativá-lo

`deactivate`

## Softwares necessários:

São necessários `mkdocs` e `mkdocs-material` instalados.

Para instalá-los no ambiente virtual:

```
pip install mkdocs
pip install mkdocs-material
```

## Execução:

Para executar o script:

```
pushd /opt/gits/_a4a/documentation_generator/
bash gera_docs.bash
```
As documentações geradas estarão em `/tmp/mkdocs`, por exemplo:

```
/tmp/
└── mkdocs
    ├── docs.addressforall.org
    │   ├── documentation_generator
    │   ├── index.html
    │   ├── suporte
    │   └── WS
    ├── docs.digital-guard.org
    │   ├── index.html
    │   ├── preserv
    │   ├── preserv-BR
    │   ├── preserv-CO
    │   └── preserv-PE
    ├── docs.itgs.org.br
    │   └── index.html
    └── docs.osm.codes
        ├── BR_IBGE
        ├── BR_IBGE_new
        └── index.html
```

## Execução local

Para execução local do script:

```
base_dir="/opt/gits"

sudo rm -rf ${base_dir}/
sudo mkdir -p ${base_dir}/_{a4a,osmc,dg,itgs,okbr}
sudo chmod -R a+rw ${base_dir}

git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/WS.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-BR.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-CO.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-PE.git
git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/documentation_generator.git
git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/suporte.git
git -C ${base_dir}/_osmc clone https://github.com/osm-codes/BR_IBGE.git
git -C ${base_dir}/_osmc clone https://github.com/osm-codes/BR_IBGE_new.git
```

## Execução no servidor

No servidor, `git pull` nos repositórios ou removê-los e cloná-los novamente com os seguintes comandos:


```
base_dir="/opt/gits"

for folder in a4a/WS a4a/documentation_generator a4a/suporte dg/preserv dg/preserv-BR dg/preserv-CO dg/preserv-PE osmc/BR_IBGE osmc/BR_IBGE_new
do
    [ -d ${base_dir}/_${folder} ] && rm -rf ${base_dir}/_${folder}
done

git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/WS.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-BR.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-CO.git
git -C ${base_dir}/_dg   clone https://github.com/digital-guard/preserv-PE.git
git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/documentation_generator.git
git -C ${base_dir}/_a4a  clone https://github.com/AddressForAll/suporte.git
git -C ${base_dir}/_osmc clone https://github.com/osm-codes/BR_IBGE.git
git -C ${base_dir}/_osmc clone https://github.com/osm-codes/BR_IBGE_new.git
```


## Sobrescrever tema

Estrutura da pasta utilizada para sobrescrever partes do tema mkdocs _material_:

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
