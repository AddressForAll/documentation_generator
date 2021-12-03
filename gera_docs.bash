#!/bin/bash

# Apresentação e instruções no README.md
dir_tmp='/tmp/mkdocs'                       # Diretório temporário utilizado durante a geração de build
base_path="/var/gits"                       # Localização dos repositórios

index_html='index.html'                     # Arquivo que conterá o html do index de cada subdominio doc.
file_index='README.md'                      # Nome do arquivo utilizado no lugar do index.md, que o mkdocs esperaria encontrar.
path_overrides='overrides'                  # Diretório com arquivos utilizados para sobrescrever partes do tema material


# detalhes sobre cada uma das 4 organizações
logo_git_a4a="a4a.png"                              # Nome do arquivo contendo o logo
home_docs_a4a="http://docs.addressforall.org"       # URL da documentação da organização
home_git_a4a="git.addressforall.org"                # URL do git da organização
site_name_a4a="AddressForAll"                       # Nome da organização
favicon_a4a="address_for_all-01-colorful.ico.png"   # Nome do arquivo contendo favicon
codigo_a4a="a4a"                                    # Código da organização

logo_git_dg="digitalguard.png"
home_docs_dg="http://docs.digital-guard.org"
home_git_dg="git.digital-guard.org"
site_name_dg="Digital Guard"
favicon_dg=""
codigo_dg="dg"

logo_git_osmc="osmcodes.png"
home_docs_osmc="http://docs.osm.codes"
home_git_osmc="git.osm.codes"
site_name_osmc="OSM Codes"
favicon_osmc=""
codigo_osmc="osmc"

logo_git_itgs="itgs.png"
home_docs_itgs="http://docs.itgs.org.br"
home_git_itgs="git.itgs.org.br"
site_name_itgs="ITGS"
favicon_itgs=""
codigo_itgs="itgs"


[ -d $dir_tmp ] && rm -rf $dir_tmp
mkdir -p $dir_tmp

cp -rf $path_overrides $dir_tmp

# para cada organizaçao gera documentaçao para seus repositórios 
for codigo in $codigo_a4a $codigo_dg $codigo_itgs $codigo_osmc
do
    gits=$(ls $base_path/_${codigo})

    logo_git="logo_git_${codigo}"
    home_docs="home_docs_${codigo}"
    home_git="home_git_${codigo}"
    site_name="site_name_${codigo}"
    favicon="favicon_${codigo}"
    codigoid="codigo_${codigo}"

    # cria diretório nomeado com url sem 'http://'
    [ ! -d $dir_tmp/${!home_docs##*/} ] && mkdir $dir_tmp/${!home_docs##*/}

    # mkdocs build para cada repositório da organização
    for name_repo in $gits
    do
        echo -e "\n\n\n###########################\nURL: ${!home_git}\nREPOS: $gits\nBUILD: $name_repo\n###########################\n"
                
        # build do mkdocs necessita que a pasta se chame docs
        [ -d $dir_tmp/docs ] && rm -rf $dir_tmp/docs
        mkdir $dir_tmp/docs

# trecho inicial do arquivo de configuração do mkdocs, sem nav
mkdocs_yaml_begin="## Site metadata
site_name: $name_repo
site_url: ${!home_docs}
repo_url: http://${!home_git}/$name_repo"

# parte final do arquivo de configuração do mkdocs, sem nav
mkdocs_yaml_end="## Build setings
theme:
    name: material
    features:
        - navigation.indexes
        - navigation.top
        - navigation.expand
        - navigation.sections
        - toc.integrate
    custom_dir: overrides
    logo: assets/images/${!logo_git}
    favicon: assets/images/${!favicon}

extra_css:
- assets/stylesheets/extra.css

extra:
    homepage: ${!home_docs}
    generator: false"

        # gera build mkdocs considerando se existe docs e multilinguagem
        if [ -d "$base_path/_${codigo}/$name_repo/docs" ]
        then
            # verifica existência tem outras linguagens
            if [ -d "$base_path/_${codigo}/$name_repo/docs/pt" ] || [ -d "$base_path/_${codigo}/$name_repo/docs/es" ] || [ -d "$base_path/_${codigo}/$name_repo/docs/en" ]
            then
                # 'lang' é a variável utilizada no javascript de seleção de linguagem
                html_hub_li="<li><a href=\"${!home_docs}/$name_repo/'+lang+'\">$name_repo</a></li>"

                # build para cada linguagem
                for lang in pt en es
                do
                    if [ -d "$base_path/_${codigo}/$name_repo/docs/$lang" ]
                    then
                        # build do mkdocs necessita que a pasta se chame docs
                        [ -d $dir_tmp/docs ] && rm -rf $dir_tmp/docs
                        mkdir $dir_tmp/docs

                        cp -sr -t $dir_tmp/docs $base_path/_${codigo}/$name_repo/docs/$lang/*

                        for folder in _assets assets
                        do
                            if [ -d "$base_path/_${codigo}/$name_repo/docs/$folder" ]
                            then
                                cp -sr -t $dir_tmp/docs $base_path/_${codigo}/$name_repo/docs/$folder
                            fi
                        done

                        # ajusta a url de edição e constrói nav do mkdocs
                        mkdocs_yaml_nav="\nedit_uri: edit/main/docs/$lang\nnav:\n"

                        # faz com que readme seja o primeiro
                        if [ -f "$dir_tmp/docs/$file_index" ]
                        then
                            mkdocs_yaml_nav+="- $file_index\n"
                        fi

                        # demais arquivos após readme
                        for arq in $(ls -pr $dir_tmp/docs | grep -v / | grep -v $file_index | grep -E *.md)
                        do
                            mkdocs_yaml_nav+="- $arq\n"
                        done

                        # criar o arquivo de configuração do mkdocs
                        echo -e "$mkdocs_yaml_begin\n$mkdocs_yaml_nav\n$mkdocs_yaml_end" > $dir_tmp/mkdocs.yml

                        echo -e "###########################\nARQUIVO CONFIG MKDOCS\nLANG: $lang\n###########################\n"
                        cat $dir_tmp/mkdocs.yml

                        # build e move o conteúdo para o diretório
                        cd $dir_tmp
                        mkdocs build
                        mkdir -p $dir_tmp/${!home_docs##*/}/$name_repo
                        mv site/ ${!home_docs##*/}/$name_repo/$lang
                    fi
                done
            # build se existir diretório docs e não existir outras linguagens
            else
                html_hub_li="<li><a href="${!home_docs}/$name_repo">$name_repo</a></li>"

                cp -sr -t $dir_tmp/docs $base_path/_${codigo}/$name_repo/docs/*
                
                # ajusta a url de edição e constrói nav do mkdocs
                mkdocs_yaml_nav="\nedit_uri: edit/main/docs\nnav:\n"

                # faz com que readme seja o primeiro
                if [ -f "$dir_tmp/docs/$file_index" ]
                then
                    mkdocs_yaml_nav+="- $file_index\n"
                elif [ -f "$base_path/_${codigo}/$name_repo/$file_index" ]
                then
#                     mv $dir_tmp/docs/$file_index $dir_tmp/docs/docs/
                    cp -s -t $dir_tmp/docs $base_path/_${codigo}/$name_repo/$file_index
                    mkdocs_yaml_nav+="- $file_index\n"
                fi

                # demais arquivos após readme
                for arq in $(ls -pr $dir_tmp/docs | grep -v / | grep -v $file_index | grep -E *.md)
                do
                    mkdocs_yaml_nav+="- $arq\n"
                done

                # criar o arquivo de configuração do mkdocs
                echo -e "$mkdocs_yaml_begin\n$mkdocs_yaml_nav\n$mkdocs_yaml_end" > $dir_tmp/mkdocs.yml

                echo -e "###########################\nARQUIVO CONFIG MKDOCS\n###########################\n"
                cat $dir_tmp/mkdocs.yml

                # build e move o conteúdo para o diretório
                cd $dir_tmp
                mkdocs build
                mv site/ ${!home_docs##*/}/$name_repo
            fi
        # build se o repositório não estiver usando diretório docs, usando src e/ou data
        else
            html_hub_li="<li><a href="${!home_docs}/$name_repo">$name_repo</a></li>"
            
            cp -sr -t $dir_tmp/docs $base_path/_${codigo}/$name_repo/*

            # ajusta a url de edição e constrói nav do mkdocs
            mkdocs_yaml_nav="\nedit_uri: edit/main\nnav:\n"

            # faz com que readme seja o primeiro
            if [ -f "$dir_tmp/docs/$file_index" ]
            then
                mkdocs_yaml_nav+="- $file_index\n"
            fi

            # demais arquivos após readme
            for arq in $(ls -pr $dir_tmp/docs | grep -v / | grep -v $file_index | grep -E *.md)
            do
                mkdocs_yaml_nav+="- $arq\n"
            done

            for folder in src data
            do
                if [ -d "$dir_tmp/docs/$folder" ]
                then
                    if [ -f "$dir_tmp/docs/$folder/$file_index" ]
                    then
                        mkdocs_yaml_nav+="- $folder/$file_index\n"
                    fi

                    for arq in $(ls -pr $dir_tmp/docs/$folder | grep -v / | grep -v $file_index | grep -E *.md)
                    do
                        mkdocs_yaml_nav+="- $folder/$arq\n"
                    done
                fi
            done

            # criar o arquivo de configuração do mkdocs
            echo -e "$mkdocs_yaml_begin\n$mkdocs_yaml_nav\n$mkdocs_yaml_end" > $dir_tmp/mkdocs.yml

            echo -e "###########################\nARQUIVO CONFIG MKDOCS\n###########################\n"
            cat $dir_tmp/mkdocs.yml

            # build e move o conteúdo para o diretório
            cd $dir_tmp
            mkdocs build
            mv site/ ${!home_docs##*/}/$name_repo
        fi

        # armazena li na sua respectiva ul
        if [[ ${codigo} == $codigo_a4a ]]
        then
            html_hub_ul_a4a+=$html_hub_li

        elif [[ ${codigo} == $codigo_dg ]]
        then
            html_hub_ul_dg+=$html_hub_li
        elif [[ ${codigo} == $codigo_osmc ]]
        then
            html_hub_ul_osmc+=$html_hub_li
        elif [[ ${codigo} == $codigo_itgs ]]
        then
            html_hub_ul_itgs+=$html_hub_li
        fi
    done
done

# Remove arquivo yaml e links simbólicos da pasta temporária
[ -d $dir_tmp/$path_overrides ] && rm -rf $dir_tmp/$path_overrides
[ -d $dir_tmp/docs ] && rm -rf $dir_tmp/docs
[ -f $dir_tmp/mkdocs.yml ] && rm $dir_tmp/mkdocs.yml



# criar arquivos index para cada git
for codigo in $codigo_a4a $codigo_dg $codigo_itgs $codigo_osmc
do
    home_docs="home_docs_${codigo}"
    hub="html_hub_$codigo"
    site_name="site_name_${codigo}"
    html_hub_ul="html_hub_ul_${codigo}"

   
    # listas não ordenadas para cada index de git
    html_ul_in=""
    for k in $codigo_a4a $codigo_dg $codigo_itgs $codigo_osmc
    do
        if [[ $k != $codigo ]]
        then
            html_hub_ul_k="html_hub_ul_${k}"
            home_docs_k="home_docs_${k}"
            site_name_k="site_name_${k}"
            html_ul_in+="<li><a href=\"${!home_docs_k}\">${!site_name_k}</a><ul>${!html_hub_ul_k}</ul></li>"
        fi
    done

    html_js="<ul>
        <li>Documentação <a href=\"${!home_docs}\">${!site_name}</a>:
            <ul>${!html_hub_ul}</ul>
        </li>
        <li>Demais documentações de projetos vinculados ao <a href=\"${home_docs_itgs}\">${site_name_itgs}</a>:
            <ul>
                $html_ul_in
            </ul>
        </li>
    </ul>"


    # html do respectivo index
    html_hub="<!DOCTYPE html>
    <html>
        <head>
            <title>Documentação ${!site_name}</title>
            <style>
            </style>
        </head>
        <body>

        <p>Selecione a língua preferida:
        <select id='lang_selector' onchange='recarrega_pagina_idioma()'>
            <option value='pt' selected>Português</option>
            <option value='en'>English</option>
            <option value='es'>Español</option>
        </select>
        </p>

        <ul id='list'></ul>

        <script>
        window.onload = recarrega_pagina_idioma();

        function recarrega_pagina_idioma() {
            var lang = document.getElementById('lang_selector').value;
            document.getElementById('list').innerHTML = ' ${html_js} ';
        }
        </script>
        </body>
    </html>"

        # criar o index no respectivo diretório
        echo $html_hub > "$dir_tmp/${!home_docs##*/}/$index_html"
done
